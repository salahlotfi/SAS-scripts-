proc reg data=WORK.IMPORT3 plots (only label) = (RStudentByLeverage DFFITS CooksD DFBETAS);
	model READING=SES IQ income/vif tol collin ;
	run;
	
proc reg data=WORK.IMPORT3;
	model READING=SES IQ income/influence;
	run;	
	
Proc reg data=WORK.import3;
	model READING=SES IQ;
	output out=influence h=leverage rstudent=tresidual cookd=CooksD;
run;

data highinf;
	set influence;
	absres= abs(tresidual);
	if leverage > 0.03*3 or absres > 2 or D > 1;
run;
proc print data=highinf; run;

