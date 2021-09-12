function [movement] = movement_direction (dirToGoal)
 
switch dirToGoal
    case 0
        movement = [1 0];        
    case 1 
        movement=[1 1]; %45 diagonaly
    case 2 
        movement= [0 1];
    case 3 
        movement=[-1 1]; %45 diagonal
    case 4 
        movement=[-1 0];
    case 5
        movement=[-1 -1]; %45 diagonal
    case 6
        movement=[0 -1];
    case 7
        movement=[1 -1]; %45 diagonal
    otherwise
        movement=[0 0];%stop
        disp('Abort Mission');
end
end
 
