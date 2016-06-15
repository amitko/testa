function res = singleTest(nOfItems, itemParams, varargin)
% function res = singleTest(nOfItems, itemParams)
%
% Returnt the item idexex from the itemParams
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

% Dimitar Atanasov. 2016
% datanasov@ir-statistics.net

% =====  parse the inputs ====

inP = inputParser;
inP.KeepUnmatched = true;

def_abilityScaleValues = -3:0.5:3;
addParameter(inP,'abilityScaleValues',def_abilityScaleValues, @isnumeric);

def_targetInfFunctionValuesDN = zeros(1,size(def_abilityScaleValues,2));
def_targetInfFunctionValuesUP = [];


addRequired(inP,'nOfItems',@isnumeric);
addRequired(inP,'itemParams',@isnumeric);


addParameter(inP,'targetInfFunctionValuesDN',def_targetInfFunctionValuesDN,@isnumeric);
addParameter(inP,'targetInfFunctionValuesUP',def_targetInfFunctionValuesUP,@isnumeric);


%parse(inP, nOfItems, itemParams, abilityScaleValues,varargin{:});
parse(inP, nOfItems, itemParams, varargin{:});

disp('===== Compose with parameters ====');
inP.Results

% ====== Init Values =====

numItems = size(inP.Results.itemParams,1);

lb = zeros(numItems,1);
ub = ones(numItems,1);

IntCon = 1:numItems;

% === Equality constraints ====
Ae = [ones(1,numItems)];
be = [nOfItems];

f = ones(1,numItems);

itemInf = expected.ItemInformation(itemParams,inP.Results.abilityScaleValues);

% === Inequality constraints ====

% greater than the target TIF
A = [-itemInf'];
b = [-inP.Results.targetInfFunctionValuesDN'];


% smaller than the target TIF
if ~isempty(inP.Results.targetInfFunctionValuesUP)
    A = [A; itemInf'];
    b = [b; inP.Results.targetInfFunctionValuesUP'];
end;

x = intlinprog(f,IntCon,A,b,Ae,be,lb,ub);

if sum(x) > nOfItems || sum(x) < nOfItems
    error('Can not find a required set of items! Review the restrictions!');
end;

res = x == 1;

%[x,fval,exitflag,output] = intlinprog(f,intcon,A,b,Aeq,Beq,lb,ub,options) 
%x = intlinprog(f,intcon,[],[],[],[],lb,ub)






% ========= FOR genetic algorithm ====== not works properly
%F = @(x) fit_fcn(x,itemData, targetInfFunctionValues, abilityScaleValues);


%options = gaoptimset('Display','iter');

%[res,fval,exitflag,output] = ga(F,numItems,A,b,[],[],lb,ub,[],IntCon, options)



%function res = fit_fcn(x,itemData, targetInfFunction, abilityScale)
%res = sum( (targetInfFunction - x * +expected.ItemInformation(itemData,abilityScale) ).^2);
