addpath('../')
load('../reducedProblem.mat');
fprintf('Ensure you have the parallel computing toolbox for Matlab installed in order to run this script\n');
matlabpool open
fprintf('Running Tabu Search for 50 iterations\n');
Iterations = 50;
TabuListLength = 3;
[BestSoln, BestSolnCost] = TabuCamSearch(sens,map,cam,TabuListLength,Iterations,@GenInitialCamSoln,@GetBestNeighbourCamCoopSoln,@DetermineCost)
matlabpool close
