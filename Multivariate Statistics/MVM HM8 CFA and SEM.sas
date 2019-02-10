***CFA and SEM with my own data***;

proc calis data=import mod residual;
	var Penn_SWQ_Total1 ACS_Total1 ASRS_Total_1 DASS21_ANX_1
	DASS21_STR_1 STAIT_Total_1 Rumi_Respon_Tot_1 Worry_Domain_Q_total1 Resp_AnxQ_Total_1;

lineqs
	ACS_Total1= L2 F2 + E2,
	ASRS_Total_1 = L3 F2 + E3, 
	DASS21_ANX_1 = L4 F1 + E4,
	DASS21_STR_1 = L5 F1 + E5,
	STAIT_Total_1 = L6 F1 + E6,
	Rumi_Respon_Tot_1= L7 F1 + E7,
	Worry_Domain_Q_total1 = L8 F1 + E8,
	Resp_AnxQ_Total_1 = L9 F2 + E9,
	Penn_SWQ_Total1 = L1 F2 + L10 F1 + E1;
variance
	f1-f2 = 2*1,
	e1-e9 = th1-th9;
cov
	f1-f2 = ph12;
run;















proc factor data=import METHOD=principal nfactors=2 residual rotate = varimax plots=all;
	var  Penn_SWQ_Total1 ACS_Total1 ASRS_Total_1 DASS21_ANX_1
DASS21_STR_1 STAIT_Total_1 Rumi_Respon_Tot_1 Worry_Domain_Q_total1 Resp_AnxQ_Total_1;
run;