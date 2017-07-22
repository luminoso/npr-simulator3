function [b_s, b_h] = simulator2(lambda, p, invmiu, S, W, Ms, Mh, R, N)
%lambda = movies request rate (in requests/hour)
%p = percentage of requests for high-definition movies (in %)
%invmiu= average duration of movies (in minutes)
%S = number of servers (each server with a capacity of 100 Mbps)
%W = resource reservation for high-definition movies (in Mbps)
%Ms = throughput of movies in standard definition (2 Mbps)
%Mh = throughput of movies in high definition (5 Mbps)
%R = number of movie requests to stop simulation
%N = movie request number to start updating the statistical counters

N_C = 100;                  % node capacity
C = S * N_C;

invlambda_S = 60 / ((1-p)*lambda);    % average time between requests (in minutes)
invlambda_H = 60 / (p*lambda);    % average time between requests (in minutes)

%Events definition:
ARRIVAL_S = 0;
ARRIVAL_H = 1;
DEPARTURE_S = 2;
DEPARTURE_H = 3;

%State variables initialization:
STATE= zeros(1,S);
STATE_S = 0;

%Statistical counters initialization:
NARRIVALS= 0;
NARRIVALS_S = 0;
NARRIVALS_H = 0;

BLOCKED_H= 0;
BLOCKED_S = 0;

%Simulation Clock and initial List of Events:
Clock = 0;
EventList= [ARRIVAL_S exprnd(invlambda_S) 0; ARRIVAL_H exprnd(invlambda_H) 0];
EventList= sortrows(EventList,2);

while NARRIVALS < R + N
    event = EventList(1,1);
    Clock = EventList(1,2);
    node_id = EventList(1,3);
    
    EventList(1,:) = [];
    
    % process arrivals
    if event == ARRIVAL_H || event == ARRIVAL_S
        
        % find most available server
        loadbalancer = find(STATE==min(STATE));
        loadbalancer = loadbalancer(1); % pick just one server

        NARRIVALS = NARRIVALS + 1;
        
        if event == ARRIVAL_S % arrival standard video
            
            EventList= [EventList; ARRIVAL_S Clock+exprnd(invlambda_S) 0];
            NARRIVALS_S = NARRIVALS_S + 1;
            
            % ter banda para Standard e reserva disponivel
            if STATE(loadbalancer) + Ms <= N_C && STATE_S + Ms<= (C - W)
                
                STATE(loadbalancer) = STATE(loadbalancer) + Ms;
                STATE_S = STATE_S + Ms;
                EventList= [EventList; DEPARTURE_S Clock+exprnd(invmiu) loadbalancer];
                
            else
                BLOCKED_S = BLOCKED_S + 1;
            end
            
        else % arrival high def video
            
            EventList= [EventList; ARRIVAL_H Clock+exprnd(invlambda_H) 0];
            NARRIVALS_H = NARRIVALS_H + 1;
            
            % servidor tem que ter pelo menos banda Mh disponivel
            if STATE(loadbalancer) + Mh <= N_C
                
                STATE(loadbalancer) = STATE(loadbalancer) + Mh;
                EventList= [EventList; DEPARTURE_H Clock+exprnd(invmiu) loadbalancer];
                
            else
                BLOCKED_H = BLOCKED_H + 1;
            end
            
        end
        
    else % departures
        if event == DEPARTURE_S
            STATE(node_id) = STATE(node_id) - Ms;
            STATE_S = STATE_S - Ms;
        else
            STATE(node_id) = STATE(node_id) - Mh;
        end
        
        
    end
    
    EventList= sortrows(EventList,2);
    
    if NARRIVALS == N
        % reset stats and start counting only afer N arrivals
        BLOCKED_S = 0;
        BLOCKED_H = 0;
        NARRIVALS_S = 0; 
        NARRIVALS_H = 0; 
    end
    
end

b_s = BLOCKED_S/NARRIVALS_S;
b_h = BLOCKED_H/NARRIVALS_H;

end