%% Find linear approximation
function [a,b] = find_line_pars(p1,p2)
    a = (p1(2) - p2(2))./(p1(1) - p2(1));
    b = p1(2) - a.*p1(1);