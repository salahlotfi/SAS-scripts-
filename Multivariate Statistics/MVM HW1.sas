***HW 1....*;

proc means data=import chartype mean var std min max n vardef=df;
	var Pat_Satis Age;
run;

*****Plot satisfaction and age;

proc plot;
 plot Pat_Satis*Age = '*'/vref=61.347 href=39.6;
 run;
 

 ***to calculate correlation, covariance and cross sum of squares and cross production;

 proc corr cov csscp;
 var Pat_Satis Age;
 run;
 
 ***To run the smooth plot of regression model;

 proc reg data=import plots= (prediction (x=Age nolimits) residuals (smooth));
	model Pat_Satis= Age;
run;