function res = testTrueScore(itemThresholds, itemDiscrimination, ability, scale_values)

if nargin == 3 || isempty(scale_values)
    scale_values = 1;
    for k = 1:size(itemThresholds,1)
        n_ = size(itemThresholds(k,:),2);
        if n_ > size(scale_values,2) 
            scale_values(end, n_) = 0;
        end;
        r_ = 1:n_; 
        scale_values(k,:) = r_;
    end
end;    


res = zeros(1,size(ability,2));
for k = 1:size(itemThresholds,1)
    res = res + irT.grm.itemTrueScore(itemThresholds(k,:), itemDiscrimination, ability, scale_values(k,:));
end;