%3RD STEP: IMPLEMENTING THE ARTIFICAL INTELLIGENCE

function value = get_value(pos,turn)
%get_value calculates the score based on the position of the pawns to
%decide the best move of the computer player(intermediate level)
%Format of call: get_value(position of the pawn)

[rows,cols] = size(pos);

WinValue = 500000;
AlmostWinValue = 10000;
HomeGroundValue = 70;
PieceValue = 1300;
DangerValue = 10;
AttackValue = -50;
ProtectionValue = 65;
HorizonValue = 35;
VerticalValue = 15;

value = 0;
for j = 1:cols
    for i = 1:rows
       
        if pos(i,j) == 1
            
           %Points are awarded for every surviving pawn and a higher 
           %value is assigned as the pawn moves further away from home 
           %ground.
           value = value + PieceValue;
           value = value + (i-1)*DangerValue;
           
           %Points are awarded if the pawn is connected horizontally with
           %its allies.
           if ((j~=1) && (pos(i,j-1) == 1)) %|| ((j~=cols) && (pos(i,j+1) == 1))
               value = value + HorizonValue;
           end
           
           %Points are awarded if the pawn is connected vertically with
           %its allies.
           if (i~=rows) && (pos(i+1,j) == 1)
               value = value + VerticalValue;
           end
      
           %Points are deducted if the pawn is exposed to the potential of 
           %being captured.
           if (mod(turn,2) == 0) && (((i~=rows && j~=1) && (pos(i+1,j-1) == -1)) || ((i~=rows && j~=cols) && (pos(i+1,j+1) == -1)))
               value = value + AttackValue;
           end
           
           %Points are awarded if the pawn is protected by its allies.
           if ((i~=1 && j~=1) && (pos(i-1,j-1) == 1)) || ((i~=1 && j~=cols) && (pos(i-1,j+1) == 1))
               value = value + ProtectionValue;
           end
           
           %Points are awarded if the pawn reaches an almost-win position.
           if (i == rows-1) && ((j ~= cols) && (pos(i+1,j+1) == 0)) &&  ((j ~= 1) && (pos(i+1,j-1) == 0))
               value = value + AlmostWinValue;
           end
           
           %Points are awarded if the pawn meets the winning condition.
           if i == rows || isempty(find(pos==-1,1))
               value = value + WinValue;
           end
           
           %Points are awarded if the pawn protects the home ground.
           if i == 1
               if (j == 2) || (j == cols-1)
                   value = value + 10*HomeGroundValue; %very important home ground
               else
                   value = value + HomeGroundValue;
               end
           end
           
        elseif pos(i,j) == -1
           
           %Points are awarded for every surviving pawn and a higher 
           %value is assigned as the pawn moves further away from home 
           %ground.
           value = value - PieceValue;
           value = value - (rows-i)*DangerValue;
           
           %Points are awarded if the pawn is connected horizontally with
           %its allies.
           if ((j~=1) && (pos(i,j-1) == -1)) || ((j~=cols) && (pos(i,j+1) == -1))
               value = value - HorizonValue;
           end
           
           %Points are awarded if the pawn is connected vertically with
           %its allies.
           if (i~=1) && (pos(i-1,j) == -1)
               value = value - VerticalValue;
           end
           
           %Points are deducted if the pawn is exposed to the potential of 
           %being captured.
           if (mod(turn,2) == 1) && (((i~=1 && j~=1) && (pos(i-1,j-1) == 1)) || ((i~=1 && j~=cols) && (pos(i-1,j+1) == 1)))
               value = value - AttackValue;
           end
           
           %Points are awarded if the pawn is protected by its allies.
           if ((i~=rows && j~=1) && (pos(i+1,j-1) == -1)) || ((i~=rows && j~=cols) && (pos(i+1,j+1) == -1))
               value = value - ProtectionValue;
           end
           
           %Points are awarded if the pawn reaches an almost-win position.
           if (i == 2) && ((j ~= cols) && (pos(1,j+1) == 0)) &&  ((j ~= 1) && (pos(1,j-1) == 0))
               value = value - AlmostWinValue;
           end
           
           %Points are awarded if the pawn meets the winning condition.
           if (i == 1) || isempty(find(pos==1,1))
               value = value - WinValue;
           end
           
           %Points are awarded if the pawn protects the home ground.
           if i == rows
               if (j == 2) || (j == cols-1)
                   value = value - 10*HomeGroundValue; %very important home ground
               else
                   value = value - HomeGroundValue;
               end
           end
           
        end
        
    end
end

BlackHG = find(pos(1,:)==0);
WhiteHG = find(pos(rows,:)==0);

%Points are deducted if there is more than one unoccupied tile in home 
%ground
if numel(BlackHG) > 1
    for i = 1:(length(BlackHG)-1)
        if BlackHG(i+1) == BlackHG(i) + 1
            value = value - 30*HomeGroundValue;
        end
    end
end
if numel(WhiteHG) > 1
    for i = 1:(length(WhiteHG)-1)
        if WhiteHG(i+1) == WhiteHG(i) + 1
            value = value + 30*HomeGroundValue;
        end
    end
end

end