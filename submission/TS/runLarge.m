addpath('../')
load('../largeProblem.mat');
fprintf('Running Tabu Search for 300 iterations\n');
Iterations = 300;
TabuListLength = 15;
[BestSoln, BestSolnCost] = TabuCamSearch(SectionCosts,BoundaryMap,Cameras,TabuListLength,Iterations,@GenInitialCamSoln,@GetBestNeighbourCamSoln,@DetermineCost)