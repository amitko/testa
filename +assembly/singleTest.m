function res = singleTest(nOfItems, itemParams, varargin)
% function res = irT.assembly.singleTest(nOfItems, itemParams, varargin)
%
% Returnt the item indexex from the itemParams
% which compose a test.
%
% nOfItems - number of items in teh test.
% itemParams - list of IRT item parameters
%   [difficulty distcrimination guessing]
%   in rows
%
% Optional parameters: ['Name',value] pairs
%   abilityScaleValues - values on the ability scale: default -3:0.5:3
%
%   targetInfFunctionValuesDN - Lower boundary for test information
%               function. Should be a vector with values for any value of
%               abilityScaleValues.
%               The default value is zeros.
%
%   targetInfFunctionValuesUP - Upper boundary for for test information
%               function. Should be a vector with values for any value of
%               abilityScaleValues. If missing, an upper restriction of the
%               test information function is not considered.

% Dimitar Atanasov, i-Research, 2018
% datanasov@ir-statistics.net

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
parse(inP, nOfItems, itemParams, varargin{:});

disp('===== Compose single test with parameters ====');
inP.Results

% ====== Init Values =====

numItems = size(inP.Results.itemParams,1);

lb = zeros(numItems,1);
ub = ones(numItems,1);

IntCon = 1:numItems;

itemInf = irT.expected.ItemInformation(itemParams,inP.Results.abilityScaleValues);
itemInf(isfinite(itemInf) == 0) = 0;

% === Equality constraints ====

% number of items in the test
Ae = [ones(1,numItems)];
be = [nOfItems];

if isempty(inP.Results.targetFunction)
    f = ones(1,numItems);
else
    f = inP.Results.targetFunction;
end;

% === Inequality constraints ====
A = [];
b = [];

% greater than the target TIF
if ~isempty(inP.Results.targetInfFunctionValuesDN)
    A = [A; -itemInf'];
    b = [b; -inP.Results.targetInfFunctionValuesDN'];
end;

% smaller than the target TIF
if ~isempty(inP.Results.targetInfFunctionValuesUP)
    A = [A; itemInf'];
    b = [b; inP.Results.targetInfFunctionValuesUP'];
end;

% excluded items forced to be 0 : Ax = 0
if ~isempty(inP.Results.excludedItems)
    zr = zeros(1,numItems);
    zr(inP.Results.excludedItems) = 1;
    Ae = [Ae; zr];
    be = [be; 0];
end;

% required items forced to be 1 : Ax = size(requiredItems)
if ~isempty(inP.Results.requiredItems)
    zr = zeros(1,numItems);
    zr(inP.Results.requiredItems) = 1;
    Ae = [Ae; zr];
    be = [be; size(inP.Results.requiredItems,2)];
end;

% additional equalities
if ~isempty(inP.Results.addEqualitiesLHS)
    Ae = [Ae; inP.Results.addEqualitiesLHS];
    be = [be; inP.Results.addEqualitiesRHS];
end;

% additional inequalities
if ~isempty(inP.Results.addInequalitiesLHS)
    A = [A; inP.Results.addInequalitiesLHS];
    b = [b; inP.Results.addInequalitiesRHS];
end;

% ===== Optimizing =======
options = optimoptions('intlinprog','MaxNodes',numItems * 2);
x = intlinprog(f,IntCon,A,b,Ae,be,lb,ub,options);

if abs(sum(x) - nOfItems) > 1
    error('singleTest:NoItems',['Can not find a required set of items! Review the restrictions! ' num2str(sum(x)) ' of ' num2str(nOfItems) ' items found!!!']);
end;

res = find(x > 0);

