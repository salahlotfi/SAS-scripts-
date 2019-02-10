****Discriminant Analysis***

***Plotting***;
proc plot data=import1; 
	plot SSPAN_Absolute2*Penn_SWQ_Total2 = group; 
run;

****Normality check***;

proc sort; by group; 
proc univariate plot; 
	var SSPAN_Absolute2 Penn_SWQ_Total2; 
	by group;
run;

***Homogeneity of Covariance check***;
proc corr cov; 
	var SSPAN_Absolute2 Penn_SWQ_Total2; 
	by group;
run;

****MANOVA results from proc glm***;
proc glm data=import1; 
	class group; 
	model SSPAN_Absolute2 Penn_SWQ_Total2 = group /ss3 nouni; 
	manova h=_all_ /canonical; 
	lsmeans group; 
run;

********Descriptive Discriminant Analysis***;
proc discrim manova wcov pcov canonical; 
var SSPAN_Absolute2 Penn_SWQ_Total2; 
class group; 
run;


*******REALLY cool part to show two groups PLot on the Disc Function****;
proc discrim canonical out=dscores; 
	var SSPAN_Absolute2 Penn_SWQ_Total2; 
	class group; 
run;

 proc sort; by group; 
 proc univariate data=dscores; 
 	class group; var Can1; 
 	histogram Can1 / nrows=2; 
 run;
 
 *****Predictive Discriminant Analysis***Classification Rate***;
**This is code it gonna take care of the homogeneity of covariances as well...So, no need for above codes***;

 ***linear and quadratic classification with resubstitution medthod****;

proc discrim wcov pcov data= import1 pool=no listerr;
var SSPAN_Absolute2 Penn_SWQ_Total2; 
class group; 
run;


 ***linear and quadratic classification with Cross-validation (Jackknife) medthod****;

proc discrim wcov pcov data= import1 pool=no crossvalidate crosslisterr;
var SSPAN_Absolute2 Penn_SWQ_Total2; 
class group; 
run;

***When done with the classification procedure, It is time to enter new data and see how the DF works**;

data newset;
infile '\....\newset.dat';
input SSPAN_Absolute2 Penn_SWQ_Total2;

proc print data=import2;
run;

proc discrim data=import1 testdata=import2 testlist;
	class group;
run;
