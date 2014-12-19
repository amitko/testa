function res=GenerateData(pars,th,d,varargin)
% Function res=irt.GenerateData(pars,th,d...)
%
% Simulate dichotomous item response from
% a given set of IRT item parameters and
% vector of person abilities.
%
% Input:
%      pars - item parameters, at any row
%             [difficulty dicriminative guessing]
%      th    - row vector of subjects abilities
%
%      d    - the ogive curve fit parameter, default = 1.702.

%      'guess' - probability for guessing
%      'sleep' - probability for chating
%      'cheat' - probability for cheating
% for example res=GenerateData(pars,a,'cheat',0.1,0.2)
%
% Output:
%      res - matrix of dichotomous item response
%            rows represent subjects response,
%            columns represent items.
%

% Dimitar Atanasov, 2014
% datanasov@ir-statistics.net

if nargin < 3
    d = 1.702;
end;

res = [];
%% -- Generate response as a binomial trials ---
for ability = th
    person_response = [];

    if size(varargin,2) >= 2
        attr = random('bino', 1, varargin{3}, 1, size(pars,1));
    end;

    for p = 1:size(pars,1);
        pr = irt.LogisticProbability( pars(p,:), ability, d);

        if size(varargin,2) >= 2
            if strcmp(varargin{1},'guess') == 1 && attr(p) == 1
                pr = min([1, pr + varargin{2}(p)]);
            elseif strcmp(varargin{1},'sleep') == 1 && attr(p) == 1
                pr = max([0,pr - varargin{2}(p)]);
            elseif strcmp(varargin{1},'cheat') == 1 && attr(p) == 1
                pr = min([1,pr + varargin{2}(p)]);
            end;
        end;
        person_response = [person_response, random('bino', 1, pr, 1, 1)];
    end;
    res = [res' person_response']';
end;
