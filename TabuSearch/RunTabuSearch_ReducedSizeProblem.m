load('ScaledDownProblem.mat');
fprintf('Running Tabu Search for 50 iterations\n');
Iterations = 50;
TabuListLength = 3;
[BestSoln, BestSolnCost] = TabuCamSearch(SectionCosts,BoundaryMap,Cameras,TabuListLength,Iterations,@GenInitialCamSoln,@GetBestNeighbourCamSoln,@DetermineCost)