addpath('../');
load('../reducedProblem.mat');
pso2(100, cameras, boundary, sections, @DetermineCost);