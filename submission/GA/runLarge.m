addpath('../');
load('../largeProblem.mat');
fprintf('Running Genetic Algorithm for maximum 1000 generations\n');
[BestSoln, BestSolnCost] = GA(@DetermineCost, cameras, sections, boundary, 1000)
