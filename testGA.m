cscost = zeros(10);
for i=1:10
    for j=1:10
        eRate = 0.05*i + 0.1;
        mRate = 0.05*j;
        [CSoln, cscost(i, j), n] = BetterGA(@DetermineCost, Cameras, SectionCosts, BoundaryMap, 200, eRate, mRate);
    end
end