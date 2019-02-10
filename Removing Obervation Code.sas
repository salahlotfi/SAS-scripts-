*Sas code of removing an obervation;

data import;
   modify import;
   if STIDSTD=420 then remove;
run;