%2ND STEP: IMPLEMENTING THE RULES OF THE BREAKTHROUGH GAME

function all_pos = genMove(pos,turn)
%genMove decides which pawn to move and where depending on the input
%Format of call: genMove(position of the pawn,turn of the player)
%Moves the pawn in accordance to the player's preference

%Declare the following variables to be 'global' to allow access through the
%other scripts and functions.
global rows cols;

all_pos = [];
valid_move = pos;
where_black = find(pos == 1);
where_white = find(pos == -1);

%Configures the movement of the black pawns.
if mod(turn,2) == 1
    for i = 1:length(where_black)
        if (where_black(i)-rows+1 > 0) && (pos(where_black(i)-rows+1) ~= 1)
            valid_move(where_black(i)-rows+1) = 1;
            valid_move(where_black(i)) = 0;
            all_pos = [all_pos valid_move];
            valid_move = pos;
        end
    end
    for i = 1:length(where_black)
        if (where_black(i)+rows+1 < rows*cols) && (pos(where_black(i)+rows+1) ~= 1)
            valid_move(where_black(i)+rows+1) = 1;
            valid_move(where_black(i)) = 0;
            all_pos = [all_pos valid_move];
            valid_move = pos;
        end
    end
    for i = 1:length(where_black)
        if (where_black(i)+1 < rows*cols) && (pos(where_black(i)+1) == 0)
            valid_move(where_black(i)+1) = 1;
            valid_move(where_black(i)) = 0;
            all_pos = [all_pos valid_move];
            valid_move = pos;
        end
    end
%Configures the movement of the white pawns.    
else
    for i = 1:length(where_white)
        if (where_white(i)-rows-1 > 0) && (pos(where_white(i)-rows-1) ~= -1)
            valid_move(where_white(i)-rows-1) = -1;
            valid_move(where_white(i)) = 0;
            all_pos = [all_pos valid_move];
            valid_move = pos;
        end
    end
    for i = 1:length(where_white)
        if (where_white(i)+rows-1 < rows*cols) && (pos(where_white(i)+rows-1) ~= -1)
            valid_move(where_white(i)+rows-1) = -1;
            valid_move(where_white(i)) = 0;
            all_pos = [all_pos valid_move];
            valid_move = pos;
        end
    end
    for i = 1:length(where_white)
        if (where_white(i)-1 > 0) && (pos(where_white(i)-1) == 0)
            valid_move(where_white(i)-1) = -1;
            valid_move(where_white(i)) = 0;
            all_pos = [all_pos valid_move];
            valid_move = pos;
        end
    end
end

all_pos = reshape(all_pos,rows,cols,[]);

end