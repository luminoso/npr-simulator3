function [average, term] = confidence_level(alfa, results, N)
% Returns the interval calculated for the given target alfa and data
%
% alfa: confidence level to compute 0 < level < 1
% results: matrix with the values
%
% Returns [average, term]

average = mean(results);
term = norminv(1-alfa/2)*sqrt(var(results)/N);

end