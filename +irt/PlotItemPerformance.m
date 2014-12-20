function res=PlotItemPerformance(item_performance,o)
%function res = irt.PlotItemPerformance(item_performance,th,opt)
%   Plots a items curve for item with IRT parameters
%
%
%   INPUT:
%       item_performance - probamility of correct 
%               responce from person with agiven ability
%       o     - irt.Options 
%
%   OUTPUT:
%   res - 1

% Dimitar Atanasov, 2014
% datanasov@ir-statistics.net

if nargin < 2
    o= irt.Options;
end;

    opt = o.Plot;
    th  = o.LatentTraitValues;

if ~isfield(opt,'legend_values')
    for k=1:size(item_performance,1)
    opt.legend_values{k} = num2str(k);
    end
end;

res=1;
hold on;
c = 'brgymck';
t = '.x+*odpsh<>v^';
lt{1} = '-';
lt{2} = ':';
lt{3} = '-.';
lt{4} = '--';

c_cnt = 1;
t_cnt = 1;
l_cnt = 1;

m = 1;
leg = {};

for p = item_performance'

    y = p';
    if opt.colour == 1
        plot(th,y,[c(c_cnt) t(t_cnt) lt{l_cnt}],'LineWidth',1.5);
    elseif opt.colour == 2
        plot(th,y,[ 'k' t(t_cnt) lt{l_cnt} ] ,'LineWidth',1.5);
        c_cnt = 7;
    else
        plot(th,y);
    end;
    
    if c(c_cnt) == 'k'
        t_cnt = mod(t_cnt , 13) + 1;
    end;
    
    if t_cnt == 13
        l_cnt = mod(l_cnt, 4) + 1;
    end;
    
    c_cnt = mod(c_cnt, 7) + 1;
    l_cnt = mod(l_cnt, 4) + 1;

    if isempty( opt.legend_values{m} )
        leg{m} = num2str(m);
    else
        leg{m} = opt.legend_values{m};
    end;
    
    m = m + 1;
end;
hold off;


if opt.legend == 1
    legend(leg,'Location','Best'); 
elseif opt.legend == 2
        c1 = 1;
        c2 = size(item_performance,2)-1;
        ex = [];
        ey = [];
    for k = 1:size(item_performance,1)
        if ~isempty( find( ex == th(c1) + .1 ) )
            c1 = c1 + 1;
            if c1 > size(th,2)
                c1 = 1;
            end;
        end;
        if ~isempty( find( ey ==  item_performance(k,c2)) )
            c2 = c2 - 1;
            if c2 > size(th,2)
                c2 = 1;
            end;
        end;
        
        t1 = th(c1);
        t2 = th(c2);
        text(t1 + .1, item_performance(k,c1), leg{k} );
        text(t2 + .1, item_performance(k,c2), leg{k} );
        
        ex = [ex t1 + .1];
        ey = [ey item_performance(k,c2)];
    end;
end;
