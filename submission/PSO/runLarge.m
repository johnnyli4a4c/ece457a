addpath('../');
load('../largeProblem.mat');
pso2(100, cam, map, sens, @DetermineCost);