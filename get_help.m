%1ST STEP: IMPLEMENTING THE SKELETON OF THE PROJECT AND THE USER INTERFACE

function get_help
%get_help displays the instructions of the game when the player chooses the
%help button
%Format of call: get_help

   msg=char('INSTRUCTIONS:                            ',...
             'Players may only move one pawn per turn, and on an alternate basis. The pawns can move as follows: a valid move for a pawn is a forward move of a single square either straight or diagonally; no backward moves are allowed. Note that if the forward square is already occupied, the pawn cannot move there. A pawn can capture an adversary pawn when a move is done in forward diagonal (either left or right). The goal of the game is for the player to make one of his own pawns reach the opponent border, in which case, he will win the game. If one player has no more pawns on the board, he looses the game.');
     
    msgbox(msg,'BREAKTHROUGH','help');

end