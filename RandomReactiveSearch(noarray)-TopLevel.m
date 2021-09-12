clear all
clc
scaling = 10;
 
load('OccupancyMap_v2.mat');
 
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
%movement(2)=y_mov;
%movement(1)=x_mov;
direction=1;
RobotPath=zeros(size(OccupancyMap));
randomize=0;
%loop until we reach the goal location or some maximum number of moves have
%been tried or we are not moving and have no hope of movement
while(~isequal(RobotLocation, GoalLocation) && (pathLength < 2000))
   
    if(~obstacleAvoidance)
         dirToGoal=atan2d(GoalLocation(2)-RobotLocation(2), GoalLocation(1)-RobotLocation(1));%returns [-180,180] based on the coordinates
         dirToGoal = mod(round((dirToGoal/45)),8);%incrementing 45 degrees worked best, 8 movement cases including otherwise
         [x_mov, y_mov] = movement_direction(dirToGoal);
    %[newRobotLocation, obstacleHitInMove] = moveRobot(x_move, y_move, CurrentRobotLocation, OccupancyMap)
    %x_move and y_move are either -1, 0, +1
         [RobotLocation, obstacleEncountered, pathLength] = moveRobot(x_mov, y_mov, RobotLocation, OccupancyMap);
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
        [x_mov, y_mov]= movement_direction(angle);
        while (TestMovement(x_mov, y_mov, RobotLocation, OccupancyMap))
            angle=mod(angle+direction,8);
            [x_mov, y_mov]= movement_direction(angle);
     
        end             
            [RobotLocation, obstacleEncountered, pathLength] = moveRobot(x_mov, y_mov, RobotLocation, OccupancyMap);
            obstacleAvoidance=0;
            for a=0:7 %7 cases for directions
                [x_mov, y_mov]=movement_direction(a);
                if TestMovement(x_mov, y_mov,RobotLocation, OccupancyMap)
                    obstacleAvoidance=1;                  
                end                               
            end
            if (RobotPath(RobotLocation(1), RobotLocation(2))==1 && randomize==0)
                randomize=1;
                count=10;
                randomAngle=randi([0 7], 1);%generate a 1-by-1 vector of uniformly distributed random ints
            end
            
    end
    toc();
    %pause for dramatic effect
    pause(.01);    
    %plot out the robot location
    PlotRobotLocation(RobotLocation);
    title('1573116')
    RobotPath(RobotLocation(1), RobotLocation(2))=1;
end
%Just display some extremely relevant information
if(isequal(RobotLocation, GoalLocation))
    disp('Goal Reached! YAY!');
else
    disp('Goal Not Achieved... :(');
end
disp(strcat('Path Length =  ', num2str(pathLength)));
