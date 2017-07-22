clear;
M = 2;
C_all = [10 10 10 10 100 100 100 100 1000 1000 1000 1000];
lambda_all = [1.0 1.0 1.5 1.5 25 25 30 30 300 300 350 350];
minutes_all = [90 95 90 95 90 95 90 95 90 95 90 95];

% Uncomment to run each simulation according to Guide3_DDR_16_17v2.pdf
%ex2_2a(M, C_all, lambda_all, minutes_all);
%ex2_2b(M, C_all, lambda_all, minutes_all);
ex2_2c(M);
%ex2_2d(M);


%% runs simulator1 according to the tests
function [result_b, result_o] = simulator1_wrapper(M, C_all, lambda_all, minutes_all, R, runs)
% runs simulator 1 and saves the results
% N: numer of times to run
% *_all: vector of the table to compute results

result_b = zeros(size(C_all,2), runs);  % vector resultados: o 'blocking prob'
result_o = zeros(size(C_all,2), runs);  % vector resultados: b 'average occupation'

format short;
for it= 1:runs
    for i= 1:size(C_all,2)
        [b, o] = simulator1(lambda_all(i), minutes_all(i), C_all(i), M ,R );
        result_b(i,it) = b*100;
        result_o(i,it) = o;
    end
end

end

%% runs simulator1 according to the tests
function [result_b, result_o] = simulator1_new_wrapper(M, C_all, lambda_all, minutes_all, R, N, runs)
% runs simulator 1 and saves the results
% N: numer of times to run
% *_all: vector of the table to compute results

result_b = zeros(size(C_all,2), runs);  % vector resultados: o 'blocking prob'
result_o = zeros(size(C_all,2), runs);  % vector resultados: b 'average occupation'

format short;
for it= 1:runs
    for i= 1:size(C_all,2)
        [b, o] = simulator1_Nth(lambda_all(i), minutes_all(i), C_all(i), M ,R, N);
        result_b(i,it) = b*100;
        result_o(i,it) = o;
    end
end

end

%% 2.2 a)
function ex2_2a(M, C_all, lambda_all, minutes_all)

nr_runs = 10; % nr de simulacoes
R=10000;

[b, o] = simulator1_wrapper(M, C_all, lambda_all, minutes_all, R, nr_runs);

b_confidence = zeros(size(C_all,2),2);
o_confidence = zeros(size(C_all,2),2);

% print results
for i=1:size(C_all,2)
    [b_confidence(i,1), b_confidence(i,2)] = confidence_level(0.1,b(i,:),nr_runs);
    [o_confidence(i,1), o_confidence(i,2)] = confidence_level(0.1,o(i,:),nr_runs);
    fprintf('Case %c = %.2e +- %.2e || ',char(i+64), b_confidence(i,1), b_confidence(i,2))
    fprintf('%.2e +- %.2e\n',o_confidence(i,1), o_confidence(i,2))
end

end

%% 2.2 b)
function ex2_2b(M, C_all, lambda_all, minutes_all)

N = 1000; % simula so depois da Nth chegada
R = 10000;

[b, o] = simulator1_new_wrapper(M, C_all, lambda_all, minutes_all, R, N, 10);

b_confidence = zeros(size(C_all,2),2);
o_confidence = zeros(size(C_all,2),2);

% print results
for i=1:size(C_all,2)
    [b_confidence(i,1), b_confidence(i,2)] = confidence_level(0.1,b(i,:),N);
    [o_confidence(i,1), o_confidence(i,2)] = confidence_level(0.1,o(i,:),N);
    fprintf('Case %c = %.2e +- %.2e || ',char(i+64), b_confidence(i,1), b_confidence(i,2))
    fprintf('%.2e +- %.2e\n',o_confidence(i,1), o_confidence(i,2))
end

end

%% 2.2 c)
function ex2_2c(M, ~, ~, ~)

caseJ_lambda = 300;
caseJ_minutes = 95;
caseJ_C = 1000;

R = 10000;
N= 1000;

[b, o] = simulator1_new_wrapper(M, caseJ_C, caseJ_lambda, caseJ_minutes, R, N, 100);

% print results

[b_avg, b_termo] = confidence_level(0.1,b(1,:),N);
[o_avg, o_termo] = confidence_level(0.1,o(1,:),N);
fprintf('Case J = %.2e +- %.2e || ', b_avg, b_termo)
fprintf('%.2e +- %.2e\n',o_avg, o_termo)

end


%% 2.2 d)
function ex2_2d(M, ~, ~, ~)

caseJ_C = 1000;
caseJ_lambda = 300;
caseJ_minutes = 95;

R = 100000;
N= 1000;

[b, o] = simulator1_new_wrapper(M, caseJ_C, caseJ_lambda, caseJ_minutes, R, N, 10);

% print results

[b_avg, b_termo] = confidence_level(0.1,b(1,:),N);
[o_avg, o_termo] = confidence_level(0.1,o(1,:),N);
fprintf('Case J = %.2e +- %.2e || ', b_avg, b_termo)
fprintf('%.2e +- %.2e\n',o_avg, o_termo)

end