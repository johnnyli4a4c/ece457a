function [ Cameras, SectionCosts, BoundaryMap ] = genMatrices()
%Generates the standard matrices
Cameras = [ 2 3 2 3 2;
            4 5 6 4 7];

SectionCosts = [2 1 1 1];

BoundaryMap = [1 1 1 1 1 1 1 1;
               1 1 1 1 1 1 1 1;
               1 1 1 1 1 1 1 1;
               2 2 2 2 2 2 2 2;
               3 3 3 4 4 4 4 4;
               3 3 3 4 4 4 4 4;
               3 3 3 4 4 4 4 4;
               4 4 4 4 4 4 4 4];
end

