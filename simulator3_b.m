parte3_bWS()

function parte3_bWS()
p = 0.2;                % 10% of requests are HD

subscribers = 10*2500 + 24*1000;
lambda = 2 / (24 * 7);  % 1 request / week. lambda is requests/hour
lambda = lambda * subscribers;

invmiu = 90;
Ms = 2;
Mh = 5;
R = 10000;
N = 1000;

%S_limit = 6;
%W_limit = 250;

S_limit = 25;
W_limit = 1000;

runs = 40;

b_s_confidence = zeros(W_limit, S_limit);
b_s_confidence_error = zeros(W_limit, S_limit);
b_h_confidence = zeros(W_limit, S_limit);
b_h_confidence_error = zeros(W_limit, S_limit);
%23 a 24
for S=23:S_limit
    for W=750:W_limit
        
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
w=1
end
