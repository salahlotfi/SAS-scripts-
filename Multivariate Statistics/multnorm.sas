%macro multnorm (version,
       data=_last_ ,    /*            input data set           */
       var=        ,    /* REQUIRED:  variables for test       */
                        /* May NOT be a list e.g. var1-var10   */
       plot=both   ,    /* Create multivar and/or univar plot? */
       hires=yes        /* Create high-res plots?              */
                );

%let _version=1.4;
%if &version ne %then %put MULTNORM macro Version &_version;

%if %sysevalf(&sysver < 8) %then %do;
   %put MULTNORM: SAS 8 or later is required.  Terminating.;
   %let opts=;
   %goto exit;
%end;

%let opts = %sysfunc(getoption(notes))
            _last_=%sysfunc(getoption(_last_));
%if &data=_last_ %then %let data=&syslast;
%if &version ne debug %then %str(options nonotes;);

/* Check for newer version */
 %if %sysevalf(&sysver >= 7) %then %do;
  filename _ver url 'http://ftp.sas.com/techsup/download/stat/versions.dat';
  data _null_;
    infile _ver;
    input name:$15. ver;
    if upcase(name)="&sysmacroname" then call symput("_newver",ver);
    run;
  %if &syserr ne 0 %then
    %put &sysmacroname: Unable to check for newer version;
  %else %if %sysevalf(&_newver > &_version) %then %do;
    %put &sysmacroname: A newer version of the &sysmacroname macro is available.;
    %put %str(         ) You can get the newer version at this location:;
    %put %str(         ) http://support.sas.com/ctx/samples/index.jsp;
  %end;
 %end;

/* DATA= must be specified and data set must exist */
%if &data= or %sysfunc(exist(&data)) ne 1 %then %do;
  %put ERROR: DATA= data set not specified or not found.;
  %goto exit;
%end;

/* Verify that VAR= option is specified */
%if &var= %then %do;
    %put ERROR: Specify test variables in the VAR= argument;
    %goto exit;
%end;

/* Check existence and get number of VAR= variables */
%let _i=1; %let _p=0;
%let dsid=%sysfunc(open(&data));
%if &dsid %then %do;
  %let _token=%scan(&var,&_i);
  %do %while ( &_token ne %str() );
    %if %sysfunc(varnum(&dsid,&_token)) ne 0 %then %do;
      %let _p=%eval(&_p+1);
      %let _v&_p = &_token;
    %end;
    %else %do;
      %put ERROR: Variable &_token not found.;
      %goto exit;
    %end;
    %let _i=%eval(&_i+1);
    %let _token=%scan(&var,&_i);
  %end;
  %let rc=%sysfunc(close(&dsid));
%end;
%else %do;
  %put ERROR: Could not open DATA= data set.;
  %goto exit;
%end;
%let nvar=&_p;

/* Remove observations with missing values */
%put MULTNORM: Removing observations with missing values...;
data _nomiss;
  set &data;
  if nmiss(of &var )=0;
  run;

/* Quit if covariance matrix is singular */
%let singular=nonsingular;
%put MULTNORM: Checking for singularity of covariance matrix...;
proc princomp data=_nomiss noprint outstat=_evals out=_prins(keep=prin:) 
  std vardef=n;
  var &var ;
  run;
%if &syserr=3000 %then %do;
  %put MULTNORM: PROC PRINCOMP required for singularity check.;
  %put %str(          Covariance matrix not checked for singularity.);
  %let princomp=na;
  %goto findproc;
%end;
%else %let princomp=yes;
data _null_;
  set _evals;
  where _TYPE_='EIGENVAL';
  if round(min(of &var ),1e-8)<=0 then do;
    put 'ERROR: Covariance matrix is singular.';
    call symput('singular','singular');
  end;
  run;
%if &singular=singular %then %goto exit;

%findproc:
/* Produce univariate plots if requested (not available in low res) */
%if (%upcase(%substr(&plot,1,1))=U or %upcase(%substr(&plot,1,1))=B) and 
    %upcase(%substr(&hires,1,1))=Y %then %do;
   ods exclude fitquantiles parameterestimates;
   proc univariate data=_nomiss noprint;
     hist &var / normal;
     run;
%end;

/* Is MODEL available for analysis? */
%let mult=yes; %let multtext=%str( and Multivariate);
%put MULTNORM: Checking if PROC MODEL is available...;
proc model; quit;
%if &syserr=0 and %substr(&sysvlong,1,1)>=8 %then %do;
  %put MULTNORM: Using SAS/ETS PROC MODEL...;
  %goto model;
%end;
%if &princomp=na %then %do;
  %put MULTNORM: SAS/ETS PROC MODEL or SAS/STAT PROC PRINCOMP is required;
  %put %str(          to perform tests of multivariate normality.  Univariate);
  %put %str(          normality tests will be done.);
  %let mult=no; %let multtext=;
  %goto univar;
%end;

/* If MODEL not available, use this method */
%dsmethod:
%put MULTNORM: Using alternative method of computation...;
proc transpose data=_prins out=_tprins; 
  run; 
proc corr data=_tprins sscp noprint 
          outp=_Mangle(where=(_TYPE_="SSCP")); 
  var _numeric_; 
  run; 
data _mult; 
  retain nparm; 
  keep TEST N VALUE STAT PROB; 
  set _Mangle end=eof nobs=nobs; 
  array col{*} col:; 
  if _n_=1 then nparm=Intercept; 
  else do; 
    mk+(col{_n_-1})**2; 
    do k=1 to dim(col); 
      ms+col{k}**3; 
    end; 
  end; 
  if eof then do; 
    TEST="Mardia Skewness"; 
    N=nobs-1; 
    VALUE=ms/N**2; 
    small_sample_correction=(nparm+1)*(N+1)*(N+3)/(N*((N+1)*(nparm+1)-6))/6; 
    STAT=VALUE*N*small_sample_correction; 
    DF=nparm*(nparm+1)*(nparm+2)/6; 
    PROB=1-probchi(STAT,DF); 
    output; 
    TEST="Mardia Kurtosis"; 
    VALUE=mk/N; 
    STAT=(VALUE-nparm*(nparm+2))/sqrt(8*nparm*(nparm+2)/N); 
    df=.; 
    PROB=2*(1-probnorm(abs(STAT))); 
    output; 
  end; 
run;

%univar:
/* get univariate test results */
proc univariate data=_nomiss noprint;
  var &var;
  output out=_stat normal=&var ;
  output out=_prob  probn=&var ;
  output out=_n         n=&var ;
  run;

data _univ;
  set _stat _prob _n;
  run;

proc transpose data=_univ name=variable
               out=_tuniv(rename=(col1=stat col2=prob col3=n));
   var &var ;
   run;

data _both;
  length test $15.;
  set _tuniv
      %if &mult=yes %then _mult;;
  if test='' then if n<=2000 then test='Shapiro-Wilk';
                  else test='Kolmogorov';
  run;

proc print data=_both noobs split='/';
  var variable n test      %if &mult=yes %then value;
      stat prob;
  format prob pvalue.;
  title "MULTNORM macro: Univariate&multtext Normality Tests";
  label variable="Variable"
            test="Test"       %if &mult=yes %then
           value="Multivariate/Skewness &/Kurtosis";
            stat="Test/Statistic/Value"
            prob="p-value";
  run;
%if (%upcase(%substr(&plot,1,1))=M or %upcase(%substr(&plot,1,1))=B) and
    &mult=yes %then %goto plot;
%else %goto exit;


%model:
/* Multivariate and Univariate tests with MODEL */
ods select normalitytest;
proc model data=_nomiss;
  %do _i=1 %to &nvar;
    &&_v&_i = _a;
  %end;
  fit &var / normal;
  title "MULTNORM macro: Univariate&multtext Normality Tests";
  run;
  quit;
%if &syserr ne 0 %then %do; 
  %if &princomp=yes %then %goto dsmethod;
  %else %do;
    %let mult=no;
    %goto univar;
  %end;
%end;
%if %upcase(%substr(&plot,1,1))=N or %upcase(%substr(&plot,1,1))=U or 
    &princomp=na %then %goto exit;


%plot:
/* compute values for chi-square Q-Q plot */
data _chiplot;
  set _prins;
  mahdist=uss(of prin1-prin&nvar );
  keep mahdist;
  run;
proc rank data=_chiplot out=_chiplot;
  var mahdist;
  ranks rdist;
  run;
data _chiplot;
  set _chiplot nobs=_n;
  chisq=cinv((rdist-.5)/_n,&nvar);
  keep mahdist chisq;
  run;
/* Create a chi-square Q-Q plot
   NOTE: Very large sample size is required for chi-square asymptotics
   unless the number of variables is very small.
*/
%if %upcase(%substr(&hires,1,1))=Y %then %do;
  proc sgplot; run;
  %if &syserr ne 3000 %then %do;
    proc sgplot data=_chiplot; scatter y=mahdist x=chisq;
  %end;
  %else %do;
    %if %sysprod(graph)=1 %then 
      %str(proc gplot data=_chiplot; plot mahdist*chisq;);
    %else %do;
      %put MULTNORM: High resolution graphics procedures not found.;
      %put %str(          PROC PLOT will be used instead.);
      proc plot data=_chiplot; plot mahdist*chisq;
    %end;
  %end;
%end;
%else %str(proc plot data=_chiplot; plot mahdist*chisq;);
label mahdist="Squared Distance"
        chisq="Chi-square quantile";
title "MULTNORM macro: Chi-square Q-Q plot";
run;
quit;

%exit:
options &opts;
title;
%mend;

