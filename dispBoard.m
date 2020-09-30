%1ST STEP: IMPLEMENTING THE SKELETON OF THE PROJECT AND THE USER INTERFACE

function dispBoard(pos) %1...black  -1...white  0...empty
%dispBoard configures the display board of the game depending on the input
%Format of call: dispBoard(position of the pawn)
%Displays the updated board according to the moves that have been made

%Declare the following variables to be 'global' to allow access through the
%other scripts and functions.
global tile rows cols;

%Clear figure window.
clf;

board = zeros(504*rows,504*cols,3,'uint8');

for i = 1:rows
    for j = 1:cols
        switch pos(i,j)
            %Displaying tiles with the black pawn.
            case 1
                if mod(i+j,2) == 0
                    board(i*504-503:i*504,j*504-503:j*504,1:3) = tile{1};
                else
                    board(i*504-503:i*504,j*504-503:j*504,1:3) = tile{4};
                end
            %Displaying tiles with the white pawn.    
            case -1
                if mod(i+j,2) == 0
                    board(i*504-503:i*504,j*504-503:j*504,1:3) = tile{2};
                else
                    board(i*504-503:i*504,j*504-503:j*504,1:3) = tile{5};
                end
            %Displaying empty tiles.    
            otherwise
                if mod(i+j,2) == 0
                    board(i*504-503:i*504,j*504-503:j*504,1:3) = tile{3};
                else
                    board(i*504-503:i*504,j*504-503:j*504,1:3) = tile{6};
                end
        end
    end
end

uicontrol('CData',imresize(board,[400,400]),'Units','normalized','position',[0.3,0.05,0.7,0.95]);

end
