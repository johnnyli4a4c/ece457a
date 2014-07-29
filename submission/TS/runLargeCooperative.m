addpath('../')
load('../largeProblem.mat');
fprintf('Ensure you have the parallel computing toolbox for Matlab installed in order to run this script\n');
matlabpool open
fprintf('Running Tabu Search for 300 iterations\n');
Iterations = 300;
TabuListLength = 15;
[BestSoln, BestSolnCost] = TabuCamSearch(sections,boundary,cameras,TabuListLength,Iterations,@GenInitialCamSoln,@GetBestNeighbourCamCoopSoln,@DetermineCost)
matlabpool close
