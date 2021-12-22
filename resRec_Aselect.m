%             if keyCode(reskey)
%                 rt(j,b) = when - startTime ;
%                 % acc(j,b) = ((keycode(keyz)&& tarOri == 0)||(keycode(keym)&&tarOri == 1));
%                 acc(j,b) = Apresent(j,b);% Aselect: 1 hit, 0 false alarm ;  V select:coordTarX>xCenter ==>1
%             elseif ~keyisdown
%                 rt(j,b) = 9;
%                 timeout(j,b) = 1;
%             end