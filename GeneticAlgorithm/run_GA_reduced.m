addpath('../');
load('simple-airport.mat');
fprintf('Running Genetic Algorithm for maximum 300 generations\n');
[BestSoln, BestSolnCost] = GA(@DetermineCost, cam, sens, map, 300);
