data wisc1;
infile '/folders/myshortcuts/MYFolderNew/DataSets/wiscsem1.dat' firstobs=2;
input client agemate info comp arith simil vocab digit pictcomp parag block object coding;
run;

***EFA HM with WISC data**** Running 2 and 3 factor solutions;
proc factor data=import METHOD=principal nfactors=2 residual rotate = varimax plots=all;
	var  Penn_SWQ_Total1 ACS_Total1 ASRS_Total_1 DASS21_ANX_1
DASS21_STR_1 STAIT_Total_1 Rumi_Respon_Tot_1 Worry_Domain_Q_total1 Resp_AnxQ_Total_1;
run;

proc factor data=import METHOD=principal nfactors=3 residual rotate = varimax plots=all;
	var  Penn_SWQ_Total1 ACS_Total1 ASRS_Total_1 DASS21_ANX_1
DASS21_STR_1 STAIT_Total_1 Rumi_Respon_Tot_1 Worry_Domain_Q_total1 Resp_AnxQ_Total_1;
run;






*****PCA example using my own STAI-T data**;
proc princomp data=import out=pcout plots =score(ellipse ncomp=2);
var Penn_SWQ_Total1 ACS_Total1 ASRS_Total_1 DASS21_ANX_1
DASS21_STR_1 STAIT_Total_1 Rumi_Respon_Tot_1 Worry_Domain_Q_total1 Resp_AnxQ_Total_1;
run;

***Wasted so much of my time on this Proc corr. IF you don't specify variables, given the large data set, it does corr for all
variables, that's why it takes so long to finish it..**;

proc corr data=pcout;
var prin1 prin2 prin3 prin4;
with
Penn_SWQ_Total1 ACS_Total1 ASRS_Total_1 DASS21_ANX_1
DASS21_STR_1 STAIT_Total_1 Rumi_Respon_Tot_1 Worry_Domain_Q_total1 Resp_AnxQ_Total_1;
run;

proc print data=pcout;run;

proc plot data=pcout;
plot prin2*prin1 = 'O';
run;