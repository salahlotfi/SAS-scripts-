*************HW 10 Categorical and Continuous interaction;

proc means data=import chartype mean std min max n vardef=df;
	var Reading ses;
run;
*************** Q1a Centering SES;
data Cimport; set import;
CSES=ses-0.062;
run;

*************************MODEL without INTERACTION***;
proc glm data=cimport;
class care;
model reading= care ses/solution;
run;

********MODEL WITH INTERACTION***;
proc glm data=cimport;
class care;
model reading= care ses care*ses/solution;
run;