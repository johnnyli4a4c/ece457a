addpath('../');
load('../reducedProblem.mat');
fprintf('Running Genetic Algorithm for maximum 300 generations\n');
[BestSoln, BestSolnCost] = GA(@DetermineCost, cam, sens, map, 300);