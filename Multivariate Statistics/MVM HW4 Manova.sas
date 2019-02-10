******HW4.2 MANOVA but with my own data

A) First checking Normality testing_Multivariate*****;


**Univariate normality***;
proc univariate data=import plot normal;
	var Flank_Incong_RT2 Penn_SWQ_Total2 SSPAN_Absolute2;
	histogram Flank_Incong_RT2 Penn_SWQ_Total2 SSPAN_Absolute2/normal;
run;


******Multivariate Normality*****;
**For Scatter plot all together**;
ods graphics on;
proc corr data=import COV plots (maxpoints=NONE)=matrix (histogram);
	var Flank_Incong_RT2 Penn_SWQ_Total2 SSPAN_Absolute2;
	ods select MatrixPlot;
run;


***For Tri-variate scatterplot, for each set of 3 variables..***SAS Studio does not have this option though;
Proc G3D data=import;
	scatter math*verbal = pt_ratio/noneedle;
run;

****running the Q-Q plot and normality test for multivariate data, using multnorm.sas macro***;
*****************YAyyyyy...I finally ran this...;
**Frist drap and drop the multnorm macro into the SAS window and run the code: %multnom (data.....);

%include "C:\Users\slotfi\Documents\SASUnivesityEdition\MYFolderNew\multnorm.sas";
	%multnorm(data=import, var=Flank_Incong_RT2 Penn_SWQ_Total2 SSPAN_Absolute2, plot=MULT);
run;


**B) Second checking Homogeneity of variances_Multivariate*****;
proc sort; by Group;
proc corr cov data=import; 
var Flank_Incong_RT2 Penn_SWQ_Total2 SSPAN_Absolute2; 
by Group; 
run;


***Running MANOVA****;
 
proc glm; class group; 
model Flank_Incong_RT2 Penn_SWQ_Total2 SSPAN_Absolute2 = group Flank_Incong_RT1 Penn_SWQ_Total1 SSPAN_Absolute1/ss3 nouni; 
manova h = _all_ /printe printh canonical; 
lsmeans group;
run;


data lc; set import;
ycomb = 0.0222*Flank_Incong_RT2 + 0.0960*Penn_SWQ_Total2 + -0.1162*SSPAN_Absolute2;
run;
symbol1 value=dot;
symbol2 value=square;
proc SGPLOT data=lc;
plot ycomb*Penn_SWQ_Total = group;
run;

****Again, testing the normality quickly...***;
proc sort data=import; by group Group_Tot_PashK1; run;
proc univariate normal plot; 
var Flank_Incong_RT2 Penn_SWQ_Total2 SSPAN_Absolute2; 
by group Group_Tot_PashK1; 
run;


proc corr data=import plots(maxpoints=NONE)=matrix(histogram); 
var Flank_Incong_RT2 Penn_SWQ_Total2 SSPAN_Absolute2; 
by group Group_Tot_PashK1; 
ods select MatrixPlot;









***Matrix Concept HM***;
**Question 1******************************;


****Group1***;


proc IML;
start;

X= {6	7,
5	9,
8	6,
4	9,
7	9
};
n = nrow(X);

ones = J(n,1,1); **Define a matrix that has n rows, 1 column, and 1’s as 
values (note: n is defined in the line above as the number of rows of X).**;

meanvec = (1/n)*x`*ones;
meanmat = ones*meanvec`;
devmat = X - meanmat;
print X;
print n;
print ones;
print meanvec;
print meanmat;
print devmat;

SSCP= devmat`*devmat;
Smat= (1/(n-1))*SSCP;
print SSCP;
print Smat;


DetSmat= det(Smat);
print DetSmat;
DetWmat= det(X);
print DetWmat;

SD= sqrt (diag (Smat));
R = inv (SD)*Smat*inv(SD);
print SD;
print R;

CALL eigen (evals, evecs, Smat);
print evals;
print evecs; 

finish;
run;
QUIT;

**Q5****;

proc glm; 
class group;
 model y1 y2  = group /ss3 nouni;
 manova h = _all_ /printe printh canonical; 
 lsmeans group; 
 run;
