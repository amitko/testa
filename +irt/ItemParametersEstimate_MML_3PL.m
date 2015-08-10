function pars = ItemParametersEstimate_MML_3PL( response, o )

global response;
global o;
global pars;

if nargin < 2
    o = irt.Options();
end;

o.Model = 3;

pars = ones(size(response,2),1) * getfield(o, ['StartingPoint_' o.irtModels{ o.Model }]);

cond = 1;

while cond > 0.1
    pars_new = [];
    parfor k = 1:size(response,2)
        f = @(pars)f2solve(pars,k);
        pars_new(k,:) = fsolve(f,pars);
    end;

    
    pars_new
    
    C = [];
    for k = 1:size(response,2)
        C(k) = irt.compare2ICC(pars(k,:),pars_new(k,:));
    end;
    
    cond = max(C);
end;


function res = f2solve(pl3,item)

global response;
global o;



s1 = zeros(size(response,1),1);
for k = 1:size(response,1)
    s1(k) = integral(@(th)int4b(th,item,k),o.LatentTraitInterval(1), o.LatentTraitInterval(2));
end;


res(1) = (1 - pl3(3)) * ( - pl3(2) ) * sum(s1);

s2 = zeros(size(response,1),1);
for k = 1:size(response,1)
    s2(k) = integral(@(th)int4a(th,item,k),o.LatentTraitInterval(1), o.LatentTraitInterval(2));
end;

res(2) = (1 - pl3(3))* sum(s2);


s3 = zeros(size(response,1),1);
for k = 1:size(response,1)
    s3(k) = integral(@(th)int4c(th,item,k),o.LatentTraitInterval(1), o.LatentTraitInterval(2));
end;

res(3) = (1 - pl3(3)) ^ (-1 ) * sum(s3);


function res = int4a(th, item, person)

global response;
global o;
global pars;

res = (response(person,item) - irt.LogisticProbability(pars, th, o.D)) .* ...
      ww(th,item) .* (th - pars(1)) .* bayes_lklh(th, person);

  
function res = int4b(th, item, person)

global response;
global o;
global pars;

res = (response(person,item) - irt.LogisticProbability(pars, th, o.D)) .* ...
      ww(th,item) .* bayes_lklh(th, person);

function res = int4c(th, item, person)

global response;
global o;
global pars;

res = (response(person,item) - irt.LogisticProbability(pars, th, o.D)) ./ ...
       irt.LogisticProbability(pars, th, o.D) .* ...
       bayes_lklh(th, person);

  

  
  
function w = ww(th,item)

global response;
global o;
global pars;
  
    w = (irt.LogisticProbability([pars(item,1:2) 0], th, o.D ) .* ...
    (1 - irt.LogisticProbability([pars(item, 1:2) 0], th, o.D))) ./...
    (irt.LogisticProbability(pars(item,:), th, o.D) .* ...
    (1 - irt.LogisticProbability(pars(item,:),th, o.D)));
  
  

function res = bayes_lklh( th, person)
global o;
res = (person_lklh(th, person) .*  pdf('norm',th,0,o.VarOfLatentTrait) ) ./ prior_distribution(person);




function res = prior_distribution( person )
global response;
global o;

res = integral(@(th)prior_dirt2int(th,person), o.LatentTraitInterval(1), o.LatentTraitInterval(2));


function res = prior_dirt2int(th,person)
global o;
res = person_lklh(th, person) .* pdf('norm',th,0,o.VarOfLatentTrait);



function res = person_lklh(th, person)

global response;
global o;
global pars;

p = [];
for k = 1:size(response, 2)
    if response(person,k) == 1
        p(k,:) = irt.LogisticProbability(pars(k,:),th,o.D);
    else
        p(k,:) = 1 - irt.LogisticProbability(pars(k,:),th,o.D);
    end;
end;
res = prod(p);