addpath('../')
load('../reducedProblem.mat');
fprintf('Running Tabu Search for 50 iterations\n');
Iterations = 50;
TabuListLength = 3;
[BestSoln, BestSolnCost] = TabuCamSearch(sens,map,cam,TabuListLength,Iterations,@GenInitialCamSoln,@GetBestNeighbourCamSoln,@DetermineCost)