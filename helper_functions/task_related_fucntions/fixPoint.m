function fixPoint(t_time, seconds, color, stimText)
% fixation point
global theWindow;
% stimText = '+';
% Screen(theWindow,'FillRect', bgcolor, window_rect);
DrawFormattedText(theWindow, double(stimText), 'center', 'center', color, [], [], [], 1.2);
Screen('Flip', theWindow);
waitsec_fromstarttime(t_time, seconds);
end
%% OLD
% function fixPoint(seconds, color, stimText)
% global theWindow;
% % stimText = '+';
% % Screen(theWindow,'FillRect', bgcolor, window_rect);
% start_fix = GetSecs; % Start_time_of_Fixation_Stimulus
% DrawFormattedText(theWindow, double(stimText), 'center', 'center', color, [], [], [], 1.2);
% Screen('Flip', theWindow);
% waitsec_fromstarttime(start_fix, seconds);
% end