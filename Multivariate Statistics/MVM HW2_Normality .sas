
******HW2 Normality testing_Multivariate*****;


**Univariate normality***;
proc univariate data=import plot normal;
	var Flank_Incong_RT2 Penn_SWQ_Total2 SSPAN_Absolute2;
	histogram math verbal/normal;
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
	%multnorm(data=import, var=pt_ratio math verbal, plot=MULT);
run;
