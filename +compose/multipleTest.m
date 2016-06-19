function res = multipleTest(nOfTest, nOfItems, itemParams, varargin)

% =====  parse the inputs ====

inP = inputParser;
inP.KeepUnmatched = true;

def_abilityScaleValues = -3:0.5:3;
addParameter(inP,'abilityScaleValues',def_abilityScaleValues, @isnumeric);

def_targetInfFunctionValuesDN = zeros(1,size(def_abilityScaleValues,2));
def_targetInfFunctionValuesUP = [];
def_excludedItems = [];
def_requiredItems = [];
def_addEqualitiesLHS = [];
def_addEqualitiesRHS = [];
def_addInequalitiesLHS = [];
def_addInequalitiesRHS = [];

addRequired(inP,'nOfTest',@isnumeric);
addRequired(inP,'nOfItems',@isnumeric);
addRequired(inP,'itemParams',@isnumeric);


addParameter(inP,'targetInfFunctionValuesDN',def_targetInfFunctionValuesDN,@isnumeric);
addParameter(inP,'targetInfFunctionValuesUP',def_targetInfFunctionValuesUP,@isnumeric);
addParameter(inP,'excludedItems',def_excludedItems,@isnumeric);
addParameter(inP,'requiredItems',def_requiredItems,@isnumeric);

addParameter(inP,'addEqualitiesLHS',def_addEqualitiesLHS,@isnumeric);
addParameter(inP,'addEqualitiesRHS',def_addEqualitiesRHS,@isnumeric);
addParameter(inP,'addInequalitiesLHS',def_addInequalitiesLHS,@isnumeric);
addParameter(inP,'addInequalitiesRHS',def_addInequalitiesRHS,@isnumeric);


%parse(inP, nOfItems, itemParams, abilityScaleValues,varargin{:});
parse(inP, nOfTest, nOfItems, itemParams, varargin{:});

disp('===== Compose multiple test with parameters ====');
inP.Results

% ====== Init Values =====

numItems = size(inP.Results.itemParams,1);

lb = zeros(numItems * 2,1);
ub = ones(numItems * 2,1);

IntCon = 1:numItems;

itemInf = expected.ItemInformation(itemParams,inP.Results.abilityScaleValues);

% === Equality constraints ====

res = [];
excludedItems = [];

if ~isempty(inP.Results.excludedItems)
    excludedItems = inP.Results.excludedItems;
end;

for k = 1:nOfTest
    
   
    % number of items in the test
    Ae = [ones(1,numItems), zeros(1,numItems); zeros(1,numItems) , ones(1,numItems) ];
    be = [nOfItems; nOfItems * (nOfTest - k) ];

    f = ones(1,numItems * 2);

    % === Inequality constraints ====
    A = [];
    b = [];
    
    A = [zeros(numItems) eye(numItems)];
    b = ones(numItems,1) .* (nOfItems + 1);
    
    % greater than the target TIF
    if ~isempty(inP.Results.targetInfFunctionValuesDN)
        A = [A; -itemInf' zeros(size(itemInf')); -itemInf' zeros(size(itemInf'))];
        b = [b; -inP.Results.targetInfFunctionValuesDN'; -inP.Results.targetInfFunctionValuesDN'];
    end;

    % smaller than the target TIF
    if ~isempty(inP.Results.targetInfFunctionValuesUP)
        A = [A; itemInf' zeros(size(itemInf')); itemInf' zeros(size(itemInf'))];
        b = [b; inP.Results.targetInfFunctionValuesUP'; inP.Results.targetInfFunctionValuesUP'];
    end;
    
    % excluded items forced to be 0 : Ax = 0
    if ~isempty(excludedItems)
        zr = zeros(1,numItems * 2);
        zr([excludedItems' excludedItems' + numItems]) = 1;
        Ae = [Ae; zr];
        be = [be; 0];
    end;

    % ===== Optimizing =======
    %x = intlinprog(f,IntCon,A,b,Ae,be,lb,ub);
    %inCurrentTest = find(x(1:numItems) == 1);
    
    inCurrentTest = compose.singleTest(nOfItems + nOfItems * (nOfTest - k), [itemParams; itemParams], ...
                                    'abilityScaleValues', inP.Results.abilityScaleValues,...
                                    'targetInfFunctionValuesDN',[],...
                                    'addEqualitiesLHS',Ae,...
                                    'addEqualitiesRHS',be,...
                                    'addInequalitiesLHS',A,...
                                    'addInequalitiesRHS',b,...
                                    'targetFunction',f...
                                    );
    
    res = [res inCurrentTest(1:nOfItems)];
    excludedItems = [excludedItems; inCurrentTest(1:nOfItems)];
    
end;


