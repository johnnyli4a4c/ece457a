function [CamSoln, CamSolnCost, n] = GeneticAlgorithm( ...
    CalcCostFn, CamList, SectionCosts, BoundaryMap, MaxGens)
%%  Variables
%   Global Variables
global solution newsolution;
global population newpopulation;
global fitness newfitness;
global yMax xMax nCameras;
global func clist cmap bmap;

%   Problem Specific Parameters
func = CalcCostFn;
cmap = SectionCosts;
clist = CamList;
bmap = BoundaryMap;
[yMax , xMax] = size(BoundaryMap);
nCameras = size(CamList, 1);

%   Genetic Algorithm Parameters

populationSize =    nCameras;   % This is a correlation to problem complexity
maxGenerations =    MaxGens
chanceCrossover =   0.95;
chanceMutation =    0.1;
mutationPoints =    2; 
count =             0;

%% Function Core
% Create the first generation
newpopulation = generatePopulation(populationSize, lengthString);
newfitness = zeroes(1, populationSize);
for p=1:populationSize,
        %Generate Solution Matrix
end
% GA Loop
for i=1:maxGenerations,
    % Record old values
    solution=newsolution; population=newpopulation; fitness=newfitness;
    
    for p=1:populationSize,
        %Perform Crossover
        ii=floor(populationSize*rand)+1; jj=floor(populationSize*rand)+1;
        if chanceCrossover > rand,
            [newpopulation(ii,:),newpopulation(jj,:)] = genCrossover(population(ii,:),population(jj,:));
            count = count + 2;
            evolve(ii);
            evolve(jj);
        end
        
        if chanceMutation > rand,
            kk = floor(populationSize * rand) +1; count = count+1;
            newpopulation(kk,:) = mutate(population(kk,:), mutationPoints);
            evolve(kk);
        end
    end
    
    bestFitness(i) = min(newfitness);
    bestSolution(i) = mean(newsolution(bestFitness(i)==newfitness));
end
    index = find(bestFitness == min(bestFitness(:)));
    CamSoln = bestSolution(index);
    CamSolnCost = bestFitness(i);
end

% Other Functions
%==
% Generate new population

function [geneLength] = getGeneLength(MaxHeight, MaxWidth, numCameras)
    yBits =  ceil(log2(MaxHeight));
    xBits =  ceil(log2(MaxWidth));
    geneLength = numCameras * (yBits + xBits + 1);
end

% CBS = Camera Bit String
function [cbs] = getCBSLength(MaxHeight, MaxWidth)
    cbs = ceil(log2(MaxHeight)) + ceil(log2(MaxWidth));
end

function [newpop] = generatePopulation(popSize, lenStr)
    newpop = rand(popSize,lenStr)>0.5;
end

function listCameras = bin2CameraList(binary)
    global xMax yMax nCameras;
    
    listCameras = zeros(nCameras, 3);    
    yBits   = ceil(log2(MaxHeight));
    xBits   = ceil(log2(MaxWidth));
    camBits = yBits + xBits + 1;
    dirBits = 1;
    curBit  = 1;
    
    for i=1:nCameras,
        listCameras(i) = [bi2de(binary(curBit:curBit+yBits - 1)), bi2de(binary(curBit + yBits: curBit + yBits + xBits - 1)), binary(curBit + yBits + xBits)];
        curBit = curBit + yBits + xBits + 1;
    end
end

function evolve(j)
    % Evolves the new generation
    global newsolution newpopulation newfitness fitness population solution func clist bmap cmap;
    newsolution(j)=bin2CameraList(newpopulation(j,:));
    newfitness(j)=feval(func, clist, cmap, bmap, newsolution(j));
    if newfitness(j) < fitness(j), % Min question
       population(j,:) = newpopulation(j,:);
       solution(j) = newsolution(j);
    end
end

function mutated = mutate(a, msite)
    % Mutate the binary string
    nn = length(a); mutated=a;
    for i=1:msite,
        j=floor(rand*nn)+1;
        mutated(j)=mod(a(j)+1,2);
    end
end

function [c,d] = genCrossover(a,b)
    nn = length(a) - 1;
    crossPoint = floor (nn * rand) + 1;
    c = [a(1:crossPoint) b(crossPoint + 1:end)];
    d = [b(1:crossPoint) a(crossPoint + 1:end)];
end