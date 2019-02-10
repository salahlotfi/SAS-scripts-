***PCA HW. Pastry data***;
proc means data=import chartype mean std min max n vardef=df;
	var oil density crispy fracture hardness;
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

***Not running these plots***;
PATTERN (ncomp= 2 vector) PROFILE