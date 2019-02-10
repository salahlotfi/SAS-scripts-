*CH6 HW1 NONLinear Relationship ******************************************;
data SqImport;Set import;
	SqExperi=Experience**2;
run;

*Below you ask to plot x axis based on variable "Experience". You can do "SqExperi" as well that 
doesn't make sense to if you look for comparing "experience scatterplot" before and after making it 'quadratic'. 
I like that smooth line.;


***Quadratic or NONLINEAR regression code for "experience";

proc reg data=SqImport plots= (prediction (x=Experience nolimits) residuals (smooth));
	model PSQ= Experience SqExperi /scorr1 scorr2 selection=rsquare;
run;


***Linear or Simple regression code for "experience";

proc reg data=import plots= (prediction (x=Experience nolimits) residuals (smooth));
	model PSQ= Experience /scorr1 scorr2;
run;
	
		
*Mean******************************************;
proc means data=WORK.SQIMPORT chartype mean std min max n vardef=df;
	var EXPERIENCE PSQ;
run;


riable 	Label 	Mean 	Std Dev 	Minimum 	Maximum 	N
EXPERIENCE
PSQ
	
EXPERIENCE
PSQ
	
21.8613333
2.9175867
	
8.9605179
0.6979077
	
1.0000000
1.0574745
	
52.0000000
5.1796557
	
375
375

