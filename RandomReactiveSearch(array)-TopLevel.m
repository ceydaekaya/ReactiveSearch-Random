clear all
clc
scaling = 10;
 
load('OccupancyMap_v1.mat');
 
%The goal is where we are trying to get to.
GoalLocation = [5, 5]';
 
pathLength = 0;
obstacleEncountered = 0;
 
%Begin the plotting routines by plotting the base map.
PlotOccupancyMap(OccupancyMap, GoalLocation);
 
%This is the RobotStartingLocation, I will provide this for the competition
RobotLocation = [98,98]';
%Draw the robot location on the map
PlotRobotLocation(RobotLocation);
 
obstacleAvoidance=0;
 
direction=1;
RobotPath=zeros(size(OccupancyMap));
randomize=0;
 
while(~isequal(RobotLocation, GoalLocation) && (pathLength < 2000))   
    if(~obstacleAvoidance)
         tic(); %keeps the elapsed time
         dirToGoal=atan2d(GoalLocation(2)-RobotLocation(2), GoalLocation(1)-RobotLocation(1));%returns [-180,180] based on the coordinates
         dirToGoal = mod(round((dirToGoal/45)),8);%incrementing 45 degrees worked best, 8 movement cases including otherwise
         movement= movement_direction(dirToGoal);
         [RobotLocation, obstacleEncountered, pathLength] = moveRobot(movement(1), movement(2), RobotLocation, OccupancyMap);
         obstacleAvoidance=obstacleEncountered;
         if (obstacleAvoidance)
             direction=-1*direction;%change dir to avoid obstacle
         end
    else        
        if(randomize)
           count=count-1; 
           if(count==0)
               randomize=0;
           end
           dirToGoal=randomAngle;
        end
        angle=mod(dirToGoal+direction,8);
        movement= movement_direction(angle);
        while (TestMovement(movement(1), movement(2), RobotLocation, OccupancyMap))
            angle=mod(angle+direction,8);
            movement= movement_direction(angle);
     
        end             
            [RobotLocation, obstacleEncountered, pathLength] = moveRobot(movement(1), movement(2), RobotLocation, OccupancyMap);
            obstacleAvoidance=0;
            for a=0:7 %7 cases for directions
                movement=movement_direction(a);
                if TestMovement(movement(1),movement(2),RobotLocation, OccupancyMap)
                    obstacleAvoidance=1;                  
                end                               
            end
            if (RobotPath(RobotLocation(1), RobotLocation(2))==1 && randomize==0)
                randomize=1;
                count=10;
                %tic(); %keeps the elapsed time
                randomAngle=randi([0 7], 1);%generate a 1-by-1 vector of uniformly distributed random ints
            end            
    end
    %pause for dramatic effect
    pause(.01);    
    %plot out the robot location
    PlotRobotLocation(RobotLocation);
    title('1573116')
    RobotPath(RobotLocation(1), RobotLocation(2))=1;
end
%Just display some extremely relevant information
if(isequal(RobotLocation, GoalLocation))
    toc()
    disp('Goal Reached! YAY!');
    
else
    disp('Goal Not Achieved... :(');
end
disp(strcat('Path Length =  ', num2str(pathLength)));
