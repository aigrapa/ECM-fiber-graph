function [all_rows,all_cols] = LinearCoord2(SizeMatrix)


A3 = [1:SizeMatrix(1)] ;
B3 = [1:SizeMatrix(2)] ;
[all_rows,all_cols] = ndgrid(A3,B3);
all_rows = all_rows(:)';
all_cols = all_cols(:)';

