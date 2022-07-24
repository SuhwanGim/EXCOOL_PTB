function exp_scale(scale, joystick)

% explane scale (overall and continuous)
% THIS FUNCTION WILL RUN EVERY RUN.
% scale = 'predict'
% joystick = false or true, but it can be obtain own scripts.

global theWindow W H window_num;                  % window screen property
global white red red_Alpha orange bgcolor yellow; % set color
global window_rect lb rb tb bb scale_H            % scale size parameter
global lb1 rb1 lb2 rb2;
global fontsize;                                  % fontsize
global anchor_y anchor_y2 anchor anchor_xl anchor_xr anchor_yu anchor_yd anchor_lms anchor_lms_y anchor_lms_x; % anchors
global cir_center


Screen(theWindow,'FillRect',bgcolor, window_rect);
velocity = cal_vel_joy('cont');

switch scale
    case 'predict'
        msg = double('이 척도가 화면에 나타나면\n "이번 자극이 최대 얼마나 아플까요?"\n에 대해 보고를 해 주시면 되겠습니다.(Space)');
        % display
        Screen('TextSize', theWindow, fontsize);
        DrawFormattedText(theWindow, msg, 'center', 1/5*H, orange, [], [], [], 1.5);
        draw_scale('cont_predict_semicircular');
        Screen('Flip', theWindow);
        
        WaitSecs(1); %For preventing double-typed 'Space' key
        while (1)
            [~,~,keyCode] = KbCheck;
            if keyCode(KbName('space'))==1
                break
            elseif keyCode(KbName('q'))==1
                abort_experiment;
            end
        end
        %         Screen('TextSize', theWindow, fontsize);
        %         msg = double('그러면 지금부터 연습을 시작하겠습니다.\n 척도가 화면에 뜨면 바로 움직여 주세요.');
        %         DrawFormattedText(theWindow, msg, 'center', 'center', white, [], [], [], 1.5);
        %         Screen('Flip', theWindow);
        %        WaitSecs(1);
        rnd=randperm(2,1);
        WaitSecs(rnd);
        %
        %         cir_center = [(lb1+rb1)/2 H*3/4+100];
        %
        %         x=cir_center(1); y=cir_center(2);
        %         SetMouse(cir_center(1), cir_center(2)); % set mouse at the center
        %         start_while = GetSecs;
        %         while GetSecs-start_while < 11
        %             if joystick
        %                 [pos, ~] = mat_joy(0);
        %                 xAlpha=pos(1);
        %                 x=x+xAlpha*velocity;
        %                 yAlpha=pos(2);
        %                 y=y+yAlpha*velocity;
        %             else
        %                 [x,y,~]=GetMouse(theWindow);
        %             end
        %             % [x,y,~]=GetMouse(theWindow);
        %             radius = (rb1-lb1)/2; % radius
        %             theta = atan2(cir_center(2)-y,x-cir_center(1));
        %             % current euclidean distance
        %             curr_r = sqrt((x-cir_center(1))^2+ (y-cir_center(2))^2);
        %             % current angle (0 - 180 deg)
        %             curr_theta = rad2deg(-theta+pi);
        %             % For control a mouse cursor:
        %             % send to diameter of semi-circle
        %             if y > cir_center(2)%%bb
        %                 y = cir_center(2); %%bb;
        %                 SetMouse(x,y);
        %             end
        %             % send to arc of semi-circle
        %             if sqrt((x-cir_center(1))^2+ (y-cir_center(2))^2) > radius
        %                 x = radius*cos(theta)+cir_center(1);
        %                 y = cir_center(2)-radius*sin(theta);
        %                 SetMouse(x,y);
        %             end
        %             draw_scale('cont_predict_semicircular');
        %             Screen('DrawDots', theWindow, [x y], 15, orange, [0 0], 1);
        %             Screen('Flip', theWindow);
        
    case 'overall'
        msg = double('이 척도가 화면에 나타나면\n "방금 전의 자극이 얼마나 아팠나요?" \n 혹은 \n "방금 전의 자극이 얼마나 불쾌했나요?" \n 에 대해 보고를 해 주시면 되겠습니다.(Space)');
        Screen('TextSize', theWindow, fontsize);
        DrawFormattedText(theWindow, msg, 'center', 1/5*H, orange, [], [], [], 1.5);
        draw_scale('overall_predict_semicircular');
        Screen('Flip', theWindow);
        
        
        WaitSecs(1); %For preventing double-typed 'Space' key
        while (1)
            [~,~,keyCode] = KbCheck;
            if keyCode(KbName('space'))==1
                break
            elseif keyCode(KbName('q'))==1
                abort_experiment;
            end
        end
                
        
        radius = (rb2-lb2)/2; % radius
        SetMouse(cir_center(1),cir_center(2));
        while GetSecs - start_t < 99
            [x,y,button]=GetMouse(theWindow);               
            theta = atan2(cir_center(2)-y,x-cir_center(1));        
            curr_r = sqrt((x-cir_center(1))^2+ (y-cir_center(2))^2);        
            curr_theta = rad2deg(-theta+pi);        
            if y > cir_center(2) %bb
                y = cir_center(2); %bb;
                SetMouse(x,y);
            end       
            if sqrt((x-cir_center(1))^2+ (y-cir_center(2))^2) > radius
                x = radius*cos(theta)+cir_center(1);
                y = cir_center(2)-radius*sin(theta);
                SetMouse(x,y);
            end
        
            msg = double('통증 세기');        
            DrawFormattedText2([double(sprintf('<size=%d><font=-:lang=ko><color=ffffff>',fontsize)) msg],'win',theWindow,'sx','center','sy',(window_rect(2)+window_rect(4))/3,'xalign','center','yalign','center');
            draw_scale('overall_predict_semicircular');
            Screen('DrawDots', theWindow, [x y], 15, orange, [0 0], 1);
            Screen('Flip', theWindow);
        
            if button(1)
                draw_scale('overall_predict_semicircular');
                Screen('DrawDots', theWindow, [x y]', 18, red, [0 0], 1);  % Feedback
                Screen('Flip',theWindow);
                WaitSecs(min(0.5, 5-(GetSecs-start_while)));
                ready3=0;
                while ~ready3 %GetSecs - sTime> 5
                    msg = double(' ');
                    DrawFormattedText(theWindow, msg, 'center', 150, white, [], [], [], 1.2);
                    Screen('Flip',theWindow);
                    if  GetSecs - start_while > 5
                        break
                    end
                end
                break;
            else
                %do nothing
            end
        
        end
        
        rnd=randperm(2,1);
        WaitSecs(rnd);
end
end