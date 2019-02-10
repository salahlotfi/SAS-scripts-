data lab2;
input Year RetunRate;
datalines;
    1963 20.6
    1964 18.7
    1965 14.2
    1966 -15.7
    1967 19.0
    1968 7.7
    1969 -11.6
    1970 8.8
    1971 9.8
    1972 18.2
;
run;

proc print data=lab2;
    title" Average Retun of Dow-Jones";
run;
data hw30;
input x1 x2;
datalines;
	1 18.95
	2 19
	3 17.95
	3 15.54
	4 14
	5 12.95
	6 8.94
	8 7.49
	9 6
	11 3.99
	;
run;
proc print data=hw30;
	 title 'Power Transformation';
	run;
title 'basic box-cox';
data x;
 do x= -3 to 3 by .01;
  	x1= exp(x + normal(7));
  	output;
  	end;
  run;
  
  ods graphics on;
  title2 'default options';
  proc transreg data= x test;
  model boxcox(x1)=identity(x);
  run;
  
 