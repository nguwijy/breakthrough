function BT(action)
%breakthrough decides which command in the game to carry out depending on 
%the input
%Format of call: breakthrough(action to be carried out)
%Runs the game according to the corresponding command

%Declare the following variables to be 'global' to allow access through the
%other scripts and functions.
global tile rows cols pos error turn ai_player difficulty history;

%1ST STEP: IMPLEMENTING THE SKELETON OF THE PROJECT AND THE USER INTERFACE

%Import the tile images for the board display.
tile{6} = imread('tw.png','png');
tile{5} = imread('twpw.png','png');
tile{4} = imread('twpb.png','png');
tile{3} = imread('tb.png','png');
tile{2} = imread('tbpw.png','png');
tile{1} = imread('tbpb.png','png');

%When there is no input argument, the function will start the game from the
%beginning.
if nargin < 1, action = 'initialize'; end

if strcmp(action,'initialize')
    
    %Prompt the player on whether he wants to use the default board size.
    y_n = menu('Do you want to use the default board size(8*8)?','Yes','No');
    %Quit when the player chooses an invalid choice.
    if y_n == 0
        return;
    end
    
    %Assign values to the variables 'rows' and 'columns' if the player
    %chooses the default board size.
    if y_n == 1
        rows = 8;
        cols = 8;
    
    %Prompt the player for his preferred board size if he chooses not to
    %use the default board size.
    else
        row_choice = cell(1,9);
        col_choice = cell(1,11);
        for i = 1:9
            row_choice{i} = i+3;
        end
        for j = 1:11
            col_choice{j} = j+1;
        end
        
        %Prompt the player for his preferred number of rows.
        rows = menu('Choose the number of rows that you want:',row_choice) + 3;
        %Quit if the player chooses an invalid choice.
        if rows == 3
            return;
        end
        
        %Prompt the player for his
        cols = menu('Choose the number of columns that you want:',col_choice) + 1;
        %Quit if the player chooses an invalid choice.
        if cols == 1
            return;
        end
        
    end
    
    %Prompt the player on whether he wants to play with the computer.  
    ai_player = menu('Do you want to play with computer?','Yes','No');
    %Error-check that the user chooses a valid choice.
    while ai_player == 0
        ai_player = menu('Do you want to play with computer?','Yes','No');
    end
    
    %Prompt the player for his preferred difficulty level.
    if ai_player == 1
        difficulty = menu('Please select difficulty!','Advanced','Intermediate','Beginner');
        %Quit if the user chooses an invalid choice.
        if difficulty == 0
            return;
        end
    end
    
    %Configure the settings at the beginning of the game.
    pos = zeros(rows,cols);
    pos(1:2,:) = 1;
    pos(rows-1:end,:) = -1;
    turn = 0;
    error = 0;
    
    %Configure the settings and window of the game.
    figure('Name','breakthrough','Pointer','crosshair','Units','normalized','Resize','off');
    history{1} = pos;
    dispBoard(pos);
    
    %Conditions that have to be met to decide if it is the white pawns'
    %turn or the black pawns' turn.
    if mod(turn,2) == 0
        BT('white');
    else
        BT('black');
    end
    
end

%Configure the display and actions of the option buttons.
uicontrol('Style', 'pushbutton','String','New game','Units','normalized','Position',[.01,.9,.2,.05],'Callback','close(gcf); BT;');
uicontrol('Style', 'pushbutton','String','Help','Units','normalized','Position',[.01,.8,.2,.05],'Callback','get_help');
uicontrol('Style', 'pushbutton','String','Feedback','Units','normalized','Position',[.01,.7,.2,.05],'Callback','web mailto:nguwijy@hotmail.com');
uicontrol('Style', 'pushbutton','String','Undo last move','Units','normalized','Position',[.01,.6,.2,.05],'Callback','BT(''undo'')');
uicontrol('Style', 'pushbutton','String','Exit','Units','normalized','Position',[.01,.5,.2,.05],'Callback','delete(gcf)');

%Undo the player's last move when he chooses the 'undo' button.
if strcmp(action,'undo')
    %Error-check that the player does not attempt to undo more moves than
    %what has already been played.
    if turn == 0
        msgbox('You can''t undo any further!!','BREAKTHROUGH','warn')
    end
        
    if ai_player == 1
        pos = history{turn-1};
        turn = turn - 2;
        dispBoard(pos);
    else
        pos = history{turn};
        turn = turn - 1;
        dispBoard(pos);
    end
    
    %Conditions that have to be met to decide if it is the white pawns'
    %turn or the black pawns' turn.
    if mod(turn,2) == 0
        BT('white');
    else
        BT('black');
    end
    
end

%2ND STEP: IMPLEMENTING THE RULES OF THE BREAKTHROUGH GAME

%Configure the display and actions of the game when it is the white pawns'
%turn.
if strcmp(action,'white')
    axis off
    text(-.15,0,'White moves...','Color','w','fontsize',18);
    
    %Warn the player about an invalid move if he does not make a valid
    %move.
    if error
        text(-.15,.1,'Invalid move!!!','Color','r','fontsize',18);
        error = 0;
    end
    
    [col_old, row_old] = myginput(1);
    col_old = ceil((col_old-.2177)*cols/.9033);
    row_old = ceil((1.121-row_old)*rows/1.1956);
    [col_new, row_new] = myginput(1);
    col_new = ceil((col_new-.2)*cols/.9033);
    row_new = ceil((1.121-row_new)*rows/1.1956);
    
    %Error-check that the player makes a valid move.
    if row_old <= 0 || col_old <= 0 || row_new <= 0 || col_new <=0
        error = 1;    
    else
        if pos(row_old,col_old) == -1 && pos(row_new,col_new) ~= -1 && row_new == row_old - 1 && ((col_new == col_old + 1 || col_new == col_old - 1) || (col_new == col_old && pos(row_new,col_new) ~= 1))
            pos(row_new,col_new) = pos(row_old,col_old);
            pos(row_old,col_old) = 0;
            turn = turn + 1;
        else
            error = 1;
        end
    end
    
    history{turn+1} = pos;    
    dispBoard(pos);
    
    %When a white pawn first reaches the opponent's border, or when there
    %are no more black pawns on the board, white wins.
    if isempty(find(pos == 1, 1)) || ~isempty(find(pos(1,:) == -1, 1))
        msgbox('White wins!');   
        leave_continue = menu('Do you want to play a new game?','Yes','No');
        if leave_continue == 1
            delete(gcf);
            BT;
            return;
        else
            delete(gcf);
            return;
        end
    end
    
    %When neither sides win on the turn, decide if it is the white pawn's
    %turn, or the black pawn's turn based on the conditions.
    if mod(turn,2) == 0
        BT('white');
    else
        BT('black');
    end

end
    
%Configure the display and actions of the game when it is the black pawns'
%turn(human player).
if strcmp(action,'black') && ai_player == 2
    axis off
    text(-.15,0,'Black moves...','Color','k','fontsize',18);    
    
    %Warn the player about an invalid move if he does not make a valid
    %move.
    if error
        text(-.15,.1,'Invalid move!!!','Color','r','fontsize',18);
        error = 0;
    end
    
    [col_old, row_old] = myginput(1);
    col_old = ceil((col_old-.2177)*cols/.9033);
    row_old = ceil((1.121-row_old)*rows/1.1956);
    [col_new, row_new] = myginput(1);
    col_new = ceil((col_new-.2)*cols/.9033);
    row_new = ceil((1.121-row_new)*rows/1.1956);
    
    %Error-check that the player makes a valid move.
    if row_old <= 0 || col_old <= 0 || row_new <= 0 || col_new <=0
        error = 1;
    else
        if pos(row_old,col_old) == 1 && pos(row_new,col_new) ~= 1 && row_new == row_old + 1 && ((col_new == col_old + 1 || col_new == col_old - 1) || (col_new == col_old && pos(row_new,col_new) ~= -1))
            pos(row_new,col_new) = pos(row_old,col_old);
            pos(row_old,col_old) = 0;
            turn = turn + 1;
        else
            error = 1;
        end
    end
    
    history{turn+1} = pos;
    dispBoard(pos);
    
    %When a black pawn first reaches the opponent's border, or when there
    %are no more white pawns on the board, black(human player) wins.
    if isempty(find(pos == -1, 1)) || ~isempty(find(pos(rows,:)==1, 1))
        msgbox('Black wins!');   
        leave_continue = menu('Do you want to play a new game?','Yes','No');
        if leave_continue == 1
            delete(gcf);
            BT;
            return;
        else
            delete(gcf);
            return;
        end 
    end
    
    %When neither sides win on the turn, decide if it is the white pawn's
    %turn, or the black pawn's turn based on the conditions.
    if mod(turn,2) == 0
        BT('white');
    else
        BT('black');
    end
    
end

%3RD STEP: IMPLEMENTING THE ARTIFICIAL INTELLIGENCE

%Configure the display and actions of the game when it is the black pawns'
%turn(computer player).
if strcmp(action,'black') && ai_player == 1
    axis off
    
    %Configure the moves of the computer for the 'beginner' level.
    if difficulty == 3
        all_pos = genMove(pos,turn);
        ran = randi([1 size(all_pos,3)]);
        pos = all_pos(:,:,ran);
    
    %Configure the moves of the computer for the 'intermediate' level.
    elseif difficulty == 2
        [~,pos] = alphaBeta(pos,2,turn,-inf,inf);
    
    %Configure the moves of the computer for the 'advanced' level.
    elseif difficulty == 1
        [~,pos] = alphaBeta(pos,4,turn,-inf,inf);
    end
    
    dispBoard(pos);
    
    turn = turn + 1;
    history{turn+1} = pos;
    
    %When a black pawn first reaches the opponent's border, or when there
    %are no more white pawns on the board, black(computer player) wins.
    if isempty(find(pos == -1, 1)) || ~isempty(find(pos(rows,:)==1, 1))
        msgbox('Black wins!');        
        leave_continue = menu('Do you want to play a new game?','Yes','No');
        if leave_continue == 1
            delete(gcf);
            BT;
            return;
        else
            delete(gcf);
            return;
        end
    end
    
    %When neither sides win on the turn, decide if it is the white pawn's
    %turn, or the black pawn's turn based on the conditions.
    if mod(turn,2) == 0
        BT('white');
    else
        BT('black');
    end
    
end
 
end
