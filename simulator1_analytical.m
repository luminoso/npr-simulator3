% analytical analysis. 
% fills the following table:

% 2.1
%
% | Case | λ (reqs/hr) | 1/μ (minutes) | C (Mbps) | M (Mbps) | Block probability | Avg. Connection Load (MBPS) |
% |------|-------------|---------------|----------|----------|-------------------|-----------------------------|
% | A    | 1.0         | 90            | 10       | 2        |                   |                             |
% | B    | 1.0         | 95            | 10       | 2        |                   |                             |
% | C    | 1.5         | 90            | 10       | 2        |                   |                             |
% | D    | 1.5         | 95            | 10       | 2        |                   |                             |
% | E    | 25          | 90            | 100      | 2        |                   |                             |
% | F    | 25          | 95            | 100      | 2        |                   |                             |
% | G    | 30          | 90            | 100      | 2        |                   |                             |
% | H    | 30          | 95            | 100      | 2        |                   |                             |
% | I    | 300         | 90            | 1000     | 2        |                   |                             |
% | J    | 300         | 95            | 1000     | 2        |                   |                             |
% | K    | 350         | 90            | 1000     | 2        |                   |                             |
% | L    | 350         | 95            | 1000     | 2        |                   |                             |
% 

M = 2;
C_all = [10 10 10 10 100 100 100 100 1000 1000 1000 1000];
lambda_all = [1.0 1.0 1.5 1.5 25 25 30 30 300 300 350 350];
minutes_all = [90 95 90 95 90 95 90 95 90 95 90 95];  
result = []; 
%format shorte; 
format short; 
for i= 1:size(C_all,2)
	ro = (lambda_all(i)/60) * minutes_all(i); 
	N = floor(C_all(i)/M); 
	result(i,1) = blocking_probability(N, ro) * 100;
	result(i,2) = average_connection_load(N, ro) * M ; % ocupacao media em mbps e necessario multiplicar por M 
end

result	

