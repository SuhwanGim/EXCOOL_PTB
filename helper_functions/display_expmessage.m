function display_expmessage(msg)
% diplay_expmessage("");
% type each MESSAGE
% Using DrawFormattedText2

global theWindow white bgcolor window_rect fontsize; % rating scale

EXP_start_text = double(msg);

% display
%Screen(theWindow,'FillRect',bgcolor, window_rect);
DrawFormattedText2([double(sprintf('<size=%d><font=-:lang=ko><color=ffffff>',fontsize)) EXP_start_text],'win',theWindow,'sx','center','sy','center','xalign','center','yalign','center');
%DrawFormattedText(theWindow, EXP_start_text, 'center', 'center', white, [], [], [], 1.5);
Screen('Flip', theWindow);

end


%%
% function display_expmessage(msg)
% % diplay_expmessage("");
% % type each MESSAGE
% 
% global theWindow white bgcolor window_rect; % rating scale
% 
% EXP_start_text = double(msg);
% 
% % display
% Screen(theWindow,'FillRect',bgcolor, window_rect);
% DrawFormattedText(theWindow, EXP_start_text, 'center', 'center', white, [], [], [], 1.5);
% Screen('Flip', theWindow);
% 
% end