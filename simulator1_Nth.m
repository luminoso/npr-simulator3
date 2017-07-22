function [b o]= simulator1_new(lambda,invmiu,C,M,R,N)
%lambda = request arrival rate (in requests per hour)
%invmiu= average movie duration (in minutes)
%C= Internet connection capacity (in Mbps)
%M= throughput of each movie (in Mbps)
%R= stop simulation on ARRIVAL no. R

invlambda=60/lambda; %average time between requests (in minutes)

%Events definition:
ARRIVAL= 0; %movie request
DEPARTURE= 1; 	%termination of a movie transmission

%State variables initialization:
STATE= 0;

%Statistical counters initialization:
LOAD= 0;
NARRIVALS= 0;
BLOCKED= 0;

%Simulation Clock and initial List of Events:
Clock= 0;
EventList= [ARRIVAL exprnd(invlambda)];

while NARRIVALS < N
    event= EventList(1,1);
    %Previous_Clock= Clock;
    Clock= EventList(1,2);
    EventList(1,:)= [];
    
    %LOAD= LOAD + STATE*(Clock-Previous_Clock);
    
    if event == ARRIVAL
        EventList= [EventList; ARRIVAL Clock+exprnd(invlambda)];
        NARRIVALS= NARRIVALS+1;
        if STATE + M <= C
            STATE= STATE+M;
            EventList= [EventList; DEPARTURE Clock+exprnd(invmiu)];
        else
            %BLOCKED= BLOCKED+1;
        end
    else
        STATE= STATE-M;
    end
    EventList= sortrows(EventList,2);
end

Clock_tmp = Clock;
while NARRIVALS < R
    event= EventList(1,1);
    Previous_Clock= Clock;
    Clock= EventList(1,2);
    EventList(1,:)= [];
    
    LOAD= LOAD + STATE*(Clock-Previous_Clock);
    
    if event == ARRIVAL
        EventList= [EventList; ARRIVAL Clock+exprnd(invlambda)];
        NARRIVALS= NARRIVALS+1;
        if STATE + M <= C
            STATE= STATE+M;
            EventList= [EventList; DEPARTURE Clock+exprnd(invmiu)];
        else
            BLOCKED= BLOCKED+1;
        end
    else
        STATE= STATE-M;
    end
    EventList= sortrows(EventList,2);
end

b= BLOCKED/(NARRIVALS-N);
o= LOAD/(Clock-Clock_tmp);

end