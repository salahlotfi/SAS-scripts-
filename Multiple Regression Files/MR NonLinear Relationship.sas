*This program runs multiple regression using nonlinear relationship...*******************;
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
	
