function [x_mov, y_mov] = movement_direction (dirToGoal)
 
switch dirToGoal
    case 0
        y_mov=0; x_mov=1; 
    case 1 
        y_mov=1; x_mov=1; %45 diagonaly
    case 2 
        y_mov=1; x_mov=0; 
    case 3 
        y_mov=1; x_mov=-1; %45 diagonal
    case 4 
        y_mov=0; x_mov=-1;
    case 5
        y_mov=1; x_mov=-1; %45 diagonal
    case 6
        y_mov=-1; x_mov=0;
    case 7
        y_mov=-1; x_mov=1; %45 diagonal
    otherwise
        y_mov=0; x_mov=0;%stop
        disp('Abort Mission');
end
end

 
