% check my packaged code can give same result as the old code.
% passed 20150201T212001
import UFLDL.sparseCodingExerciseDebug

fprintf('select non topo version!\n');
sparseCodingExerciseDebug;
load('UFLDL_data/sparse_coding_result_no_topo.mat');
assert(isequal(sparse_coding_result.weightMatrix,weightMatrix));
fprintf('select topo version!\n');
sparseCodingExerciseDebug;
load('UFLDL_data/sparse_coding_result_topo.mat');
assert(isequal(sparse_coding_result.weightMatrix,weightMatrix));