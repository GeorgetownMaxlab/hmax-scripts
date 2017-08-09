function fi = fisher(target, distractor)
% fi = fisher(target, distractor)
%
% return the Fisher Information of a feature across classes.
%
% note: works on 2-d arrays if each column represents a feature.
%
% target: double array, a vector of feature values in the target class
% distractor: double array, a vector of feature values in the distractor class
%
% fi: the Fisher Information of the feature
    fi = (mean(target)-mean(distractor)).^2 ./ (var(target) + var(distractor));
end
