addpath('../');
load('../reducedProblem.mat');
pso2(100, cam, map, sens, @DetermineCost)