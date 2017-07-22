clear;
lambda = [13 13 13 50 50 50];
S = [1 1 1 3 3 3];
W = [0 60 80 0 180 240];

%ex3_a(lambda, S, W)
ex3_b()
%ex3_c()

function ex3_a(lambda, S, W)
p = 0.4;
invmiu = 90;
Ms = 2;
Mh = 5;
R = 10000;
N = 1000;

runs = 40;
test_count = size(lambda,2);

b_s = zeros(test_count, runs);
b_h = zeros(test_count, runs);

b_s_confidence = zeros(test_count,2);
b_h_confidence = zeros(test_count,2);

for test_nr=1:size(lambda,2)
    for lap=1:runs
        [b_s(test_nr,lap), b_h(test_nr,lap)] = simulator2(lambda(test_nr), p, invmiu, S(test_nr), W(test_nr), Ms, Mh, R, N);
    end
    [b_s_confidence(test_nr,1), b_s_confidence(test_nr,2)] = confidence_level(0.1, b_s(test_nr,:), runs);
    [b_h_confidence(test_nr,1), b_h_confidence(test_nr,2)] = confidence_level(0.1, b_h(test_nr,:), runs);
    
    fprintf('%.6f +- %.6f || %.6f +- %.6f\n', b_s_confidence(test_nr,1)*100, b_s_confidence(test_nr,2)*100, b_h_confidence(test_nr,1)*100, b_h_confidence(test_nr,2)*100);
end

end

function ex3_b()
S = 2;                  % 2 server farms
p = 0.1;                % 10% of requests are HD

subscribers = 8000;
lambda = 1 / (24 * 7);  % 1 request / week. lambda is requests/hour
lambda = lambda * subscribers;

invmiu = 90;
Ms = 2;
Mh = 5;
R = 10000;
N = 1000;       % one month warm up

b_s = zeros(1,100);
b_h = zeros(1,100);

runs = 5;
W_limit = 100;

b_s_confidence = zeros(W_limit,2);
b_h_confidence = zeros(W_limit,2);

for W=1:W_limit
    for lap=1:runs
        [b_s(W,lap), b_h(W,lap)] = simulator2(lambda, p, invmiu, S, W, Ms, Mh, R, N);
    end
    [b_s_confidence(W,1), b_s_confidence(W,2)] = confidence_level(0.1, b_s(W,:), runs);
    [b_h_confidence(W,1), b_h_confidence(W,2)] = confidence_level(0.1, b_h(W,:), runs);
    
    fprintf('W:%.0f : %.6f +- %.6f || %.6f +- %.6f\n', W, b_s_confidence(W,1)*100, b_s_confidence(W,2)*100, b_h_confidence(W,1)*100, b_h_confidence(W,2)*100);
end

plot(1:W_limit,b_s_confidence(:,1), 1:W_limit, b_h_confidence(:,1));

dist = zeros(1,W_limit);
for i=1:W_limit
    dist(i)= abs(b_s_confidence(i,1) - b_h_confidence(i,1));
end

find(dist==min(dist))

end

function ex3_c()

p = 0.2;        % 20% HD requests
lambda = 1 / (24*7);
lambda = lambda * 17000; % 17000 subscribers
invmiu = 90;
Ms = 2;
Mh = 5;
R = 10000;
N = 1000;

S_limit = 6;
W_limit = 250;

runs = 40;

b_s_confidence = zeros(W_limit, S_limit);
b_s_confidence_error = zeros(W_limit, S_limit);
b_h_confidence = zeros(W_limit, S_limit);
b_h_confidence_error = zeros(W_limit, S_limit);

for S=1:S_limit
    for W=0:W_limit
        
        b_s = zeros(1,runs);
        b_h = zeros(1,runs);
        
        for lap=1:runs
            [b_s(lap), b_h(lap)] = simulator2(lambda, p, invmiu, S, W, Ms, Mh, R, N);
        end
        
        [b_s_confidence(W+1,S), b_s_confidence_error(W+1,S)] = confidence_level(0.1, b_s, runs);
        [b_h_confidence(W+1,S), b_h_confidence_error(W+1,S)] = confidence_level(0.1, b_h, runs);
        
        fprintf('W %.0f S %.0f: %.5f || %.5f\n', W, S, b_s_confidence(W+1,S), b_h_confidence(W+1,S))
    end
end

% compute worse case of the two streams
worse_case = zeros(size(b_s_confidence,1), size(b_s_confidence,2));

for i=1:size(b_s_confidence,1)
    for j=1:size(b_s_confidence,2)
        if b_s_confidence(i,j) >= b_h_confidence(i,j)
            worse_case(i,j) = b_s_confidence(i,j);
        else
            worse_case(i,j) = b_h_confidence(i,j);
        end
    end
end

surf(1:S_limit, 0:W_limit, worse_case)
xlabel('Nr Servers');
ylabel('W reservation');
zlabel('Worst case');
%axis([1 S_limit 0 W_limit 0 0.5])
view(70,27)
grid on

% a = [2,2,3;0,2,5;1 2 3]
% [row,column]=find(a==min(min(a(a>0))))

[W_optimal, S_optimal] = find(worse_case==min(min(worse_case(worse_case>=0.001))))
menos_um_server=worse_case(:,1:5);
[W_optimal, S_optimal] = find(menos_um_server==min(min(menos_um_server)))

w=1
end

