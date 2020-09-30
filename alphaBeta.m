%3RD STEP: IMPLEMENTING THE ARTIFICIAL INTELLIGENCE

function [chosen_score,chosen_move] = alphaBeta(pos,depth,turn,alpha,beta)
%alphaBeta returns the best score and best move for the black pawn
%Format of call: alphaBeta(position,depth,turn,score,move)

best_move = pos;

if depth == 0 || abs(get_value(pos,turn)) >= 490000
    best_score = get_value(pos,turn);
elseif mod(turn,2) == 1
    move_list = genMove(pos,turn);
    for i = 1:size(move_list,3)
        the_move = move_list(:,:,i);
        [the_score,~] = alphaBeta(the_move,depth-1,turn+1,alpha,beta);
        if the_score > alpha
            alpha = the_score;
            best_move = the_move;
        end
        if beta <= alpha
            break;
        end
    end
    best_score = alpha;
else
   move_list = genMove(pos,turn);
    for i = 1:size(move_list,3)
        the_move = move_list(:,:,i);
        [the_score,~] = alphaBeta(the_move,depth-1,turn+1,alpha,beta);
        if the_score < beta
            beta = the_score;
        end
        if beta <= alpha
            break;
        end
    end
    best_score = beta; 
end

chosen_move = best_move;
chosen_score = best_score;

end