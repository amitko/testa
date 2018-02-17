function res = multipleTest(nOfTest, nOfItems, itemParams, varargin)

% Required items can be alligned with 0

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
def_targetFunction = [];


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

addParameter(inP,'targetFunction',def_targetFunction,@isnumeric);


%parse(inP, nOfItems, itemParams, abilityScaleValues,varargin{:});
parse(inP, nOfTest, nOfItems, itemParams, varargin{:});

disp('===== Compose multiple test with parameters ====');
inP.Results

% ====== Check =====
if ~isempty(inP.Results.requiredItems) && (size(inP.Results.requiredItems,1) ~= nOfTest)
    error('Required items does not match teh number of tests!!!');
end;

% ====== Init Values =====
numItems = size(inP.Results.itemParams,1);

lb = zeros(numItems * 2,1);
ub = ones(numItems * 2,1);

IntCon = 1:numItems;

itemInf = expected.ItemInformation(itemParams,inP.Results.abilityScaleValues);
itemInf(isfinite(itemInf) == 0) = 0;

res = [];
excludedItems = [];

if ~isempty(inP.Results.excludedItems)
    excludedItems = inP.Results.excludedItems;
end;

if ~isempty(inP.Results.targetFunction)
    f = [inP.Results.targetFunction inP.Results.targetFunction];
else
    f = ones(1,numItems * 2);
end;
    

for k = 1:nOfTest
    
    % === Equality constraints ====

    % number of items in the test
    Ae = [ones(1,numItems), zeros(1,numItems); zeros(1,numItems) , ones(1,numItems) ];
    be = [nOfItems; nOfItems * (nOfTest - k) ];
   
    
    % === Inequality constraints ====
    A = [];
    b = [];
    
    % No item overlap
    A = [eye(numItems) eye(numItems)];
    b = ones(numItems,1);
    
    
    
    % greater than the target TIF
    
    if k == nOfTest
        shadowTestScale = 1;
    else
        shadowTestScale = (nOfTest - k);
    end;
    
    if ~isempty(inP.Results.targetInfFunctionValuesDN)
        A = [
            A; ...
            -itemInf' zeros(size(itemInf'));...
%            zeros(size(itemInf')) -itemInf';... % ?????
            ];
        b = [
            b; ...
            -inP.Results.targetInfFunctionValuesDN'; ...
%            -inP.Results.targetInfFunctionValuesDN' * shadowTestScale; ... % ????
            ];
    end;

    % smaller than the target TIF
    if ~isempty(inP.Results.targetInfFunctionValuesUP)
        A = [
            A;...
            itemInf' zeros(size(itemInf'));...
%            zeros(size(itemInf')) itemInf';... % ?????
            ];
        b = [
            b;...
            inP.Results.targetInfFunctionValuesUP';...
%            inP.Results.targetInfFunctionValuesUP' * shadowTestScale; ... % ????
            ];
    end;
    
    % excluded items forced to be 0 : Ax = 0
    if ~isempty(excludedItems)
        zr = zeros(1,numItems * 2);
        zr([excludedItems' excludedItems' + numItems]) = 1;
        Ae = [Ae; zr];
        be = [be; 0];
    end;
    
    % required items forced to be 1 : Ax = size(requiredItems)
    if ~isempty(inP.Results.requiredItems)
        reqItems = inP.Results.requiredItems(k,inP.Results.requiredItems(k,:) > 0);
        zr = zeros(1,numItems * 2);
        zr(reqItems) = 1;
        Ae = [Ae; zr];
        be = [be; size(reqItems,2)];
    end;

    
    % additional equalities
    if ~isempty(inP.Results.addEqualitiesLHS)
        Ae = [Ae; [inP.Results.addEqualitiesLHS zeros(size(inP.Results.addEqualitiesLHS))]];
        be = [be; inP.Results.addEqualitiesRHS ];
    end;

    % additional inequalities
    if ~isempty(inP.Results.addInequalitiesLHS)
        A = [A; [inP.Results.addInequalitiesLHS zeros( size(inP.Results.addInequalitiesLHS))]];
        b = [b; inP.Results.addInequalitiesRHS * 2];
    end;

    

    % ===== Optimizing =======
    %x = intlinprog(f,IntCon,A,b,Ae,be,lb,ub);
    inCurrentTest = assembly.singleTest(nOfItems + nOfItems * (nOfTest - k), [itemParams; itemParams], ...
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


