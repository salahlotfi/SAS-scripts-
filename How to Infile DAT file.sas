data wisc1;
infile '/folders/myshortcuts/MYFolderNew/DataSets/wiscsem1.dat' firstobs=2;
input client agemate info comp arith simil vocab digit pictcomp parag block object coding;
run;