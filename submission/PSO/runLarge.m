addpath('../');
load('../largeProblem.mat');
pso2(100, cameras, boundary, sections, @DetermineCost)