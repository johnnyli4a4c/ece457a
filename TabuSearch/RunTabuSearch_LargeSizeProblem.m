load('LargeProblem.mat');
fprintf('Running Tabu Search for 300 iterations\n');
Iterations = 300;
TabuListLength = 15;
[BestSoln, BestSolnCost] = TabuCamSearch(sections,boundary,cameras,TabuListLength,Iterations,@GenInitialCamSoln,@GetBestNeighbourCamCoopSoln,@DetermineCost)
