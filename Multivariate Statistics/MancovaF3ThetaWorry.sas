
***CH 7 HW Continuous interaction***;
**Q1;
*simple model;
proc reg data=import;
	SIMPLEREG: model F3_Theta_TST1_3Diff_1=Worry_Domain_Q_total1 RSPAN_Absolute1/ scorr2;
Run;

***Interaction model;
**naming the new intraction variable;

data F3_diffInte; set import;
	XZ=Worry_Domain_Q_total1*RSPAN_Absolute1;
run;

**Now interaction model;
proc reg data=F3_diffInte;
	F3_diffInteraction: model F3_Theta_TST1_3Diff_1= Worry_Domain_Q_total1 RSPAN_Absolute1 xz/ scorr1;
	XZinteraction: test XZ;
run;


***Simple mean and SD;

proc means data=PSQinterac chartype mean std min max n vardef=df;
	var LOMS EXPERIENCE PSQ XZ;
run;


	
***mean centering variable;
data F3_diffInteMC; set F3_diffInte;
	MCworry= Worry_Domain_Q_total1-31.93;
	MCRspan= RSPAN_Absolute1-15.70;
	MCXZ= MCworry*MCRspan;
run;
 
 
 proc reg data=F3_diffInteMC;
	SimpleRegMC: model F3_Theta_TST1_3Diff_1= MCworry MCRspan/ scorr2;
Run;
 
 proc reg data=F3_diffInteMC;
	F3_diffMCInter: model F3_Theta_TST1_3Diff_1= MCworry MCRspan MCXZ/ scorr1 vif;
	MCXZ: test mcXZ;
run;


***************************Just for fun;
*****Models for interactions between a linear and a curvilinear predictor (e.g., Z and X 2);


 data IntNonLinea; set PSQInterMC;
	QuadExperi= Experience**2;
run;

proc reg data=IntNonLinea plots= (prediction (x=LOMS nolimits) residuals (smooth));
	model PSQ= LOMS QuadExperi /scorr1 scorr2 selection=rsquare;
	test QuadExperi;
run;






