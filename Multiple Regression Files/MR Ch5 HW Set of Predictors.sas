proc print data=import;
run;
*CH5 HW1ab ******************************************;
proc reg data=import;
	model PSQ= Income LOMS Experience Length Change /scorr1 scorr2 selection=rsquare;
	ExperienceLengthChange: test Experience, Length, Change;
run;

proc reg data=import plots;
	modelB: model PSQ= Experience Length Change Income LOMS /scorr1 scorr2 selection=rsquare;
	IncomeLOMS: test Income, LOMS;
	run;
	
*CH5 HW2ab ******************************************;
proc reg data=import;
	modelA: model PSQ= Income LOMS Length /scorr1 scorr2 selection=rsquare;
	Length: test Length;
run;

proc reg data=import plots;
	modelB: model PSQ= Experience Length Change LOMS /scorr1 scorr2 selection=rsquare;
	LOMS: test LOMS;
	run;