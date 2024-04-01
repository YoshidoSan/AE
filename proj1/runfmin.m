function [xsol,fval,history, info] = runfmin(mainAlgorytm, inAlgorytm, Gradient, initPoint, const, i)
% Call optimization
x0 = [initPoint(1), initPoint(2)];
a = const(1);
b = const(2);
plotlim = 3;

    function [X, Y, Z] = xyz()
        [X,Y] = meshgrid(-plotlim:0.2:plotlim, -plotlim:0.2:plotlim);
        Z = (1 - X + a).^2 + 100*(Y - b - (X - a).^2).^2;
    end
           
% Set up shared variables with outfun
history.x = [];
history.fval = [];
 
grad = true;
if strcmp(Gradient, 'None')
    grad = false;
end

accuracy = 1e-10;
display = 'off'; %off / iter
if strcmp(mainAlgorytm, 'fminunc')
    if grad == true
        opts = optimoptions('fminunc','Algorithm', inAlgorytm, ...
        'Display',display,'GradObj', 'on', 'TolFun', accuracy,...
        'OutputFcn',@outfun);
        [xsol,fval, f, info] = fminunc(@(x) fbanan(x, a, b), [x0(1), x0(2)], opts);
        logPlot(history)
        
    else
        opts = optimoptions('fminunc','Algorithm', inAlgorytm, ...
        'Display',display,'GradObj', 'off', 'TolFun', accuracy,...
        'OutputFcn',@outfun);
        [xsol,fval, f, info] = fminunc(@(x) fbanan(x, a, b), [x0(1), x0(2)], opts);
        logPlot(history)
        
    end
elseif strcmp(mainAlgorytm, 'fminsearch')
     opts = optimset('Display',display,...
         'TolFun', accuracy, 'OutputFcn',@outfun);
    [xsol,fval, f, info] = fminsearch(@(x) fbanan(x, a, b), [x0(1), x0(2)], opts);
    logPlot(history)
    
end
    
 function stop = outfun(x,optimValues,state)  % rysowanie wykresu przebiegu kolejnych iteracji algorytmu
     stop = false;
     hold on
     switch state
         case 'iter'
         % Concatenate current point and objective function
         % value with history. x must be a row vector.
           history.fval = [history.fval; optimValues.fval];
           history.x = [history.x; x];
            
           [X, Y, Z] = xyz();
           figure(2*i-1)
           surf(X,Y,Z);
           hold on;
           grid on;
           plot3(x(1),x(2), fbanan(x, a, b), '.','Color','yellow','MarkerSize',20);
           axis([-plotlim plotlim -plotlim plotlim 0 10000000]);
           view(0,90)
           axis equal;
           
           %after second iteration start arrows
           headWidth = 1;
           headLength = 2;
           LineLength = 0.1;
           if size(history.x)>=2
               one=history.x(end,:);
               two=history.x(end-1,:);
               diff = one-two;
               
               hq = quiver(two(1),two(2),diff(1),diff(2));
               U = hq.UData;
               V = hq.VData;
               X = hq.XData;
               Y = hq.YData;
               for ii = 1:length(X)
                   for ij = 1:length(X)
                       headWidth = 1;
                       ah = annotation('arrow','Color','green',...
                       'headStyle','cback1','HeadLength',headLength,'HeadWidth',headWidth);
                       set(ah,'parent',gca);
                       set(ah,'position',[X(ii,ij) Y(ii,ij) LineLength*U(ii,ij) LineLength*V(ii,ij)]);
                   end
               end
           end
           if strcmp(inAlgorytm, 'None')
                var = '';
            else
                var = [', ', inAlgorytm];
            end
           if grad
               text = ['Matlab algorytm: ', mainAlgorytm, var, ', ', 'GradSupp', ', ', ...
                   ' Start point: ', num2str(x0(1)), ', ', num2str(x0(2))];
           else
               text = ['Matlab algorytm: ', mainAlgorytm, var, ' Start point: ',...
                   num2str(x0(1)), ', ', num2str(x0(2))];
           end
           title(text);
         case 'done'
             hold off
             if grad
                 text = [mainAlgorytm, '_', inAlgorytm, ',', 'Grad', ',',...
                     'Start point_', num2str(x0(1)), '_', num2str(x0(2)), '.png'];
             else
                 text = [mainAlgorytm, '_', inAlgorytm, 'Start point_', num2str(x0(1)), ...
                     '_', num2str(x0(2)), '.png'];
             end
             print('-dpng', text, '-r400')
         otherwise
     end
 end
    function stop = logPlot(history)  % rysowanie logarytmicznego wykresu wartości funkcji 
        stop = false;
        figure(2*i)
        semilogy((1:1:length(history.fval)) , history.fval)
        ylabel("Value of Function")
        xlabel("Iteration")
        if strcmp(inAlgorytm, 'None')
            var = '';
        else
            var = [', ', inAlgorytm];
        end
        if grad
           text = ['Matlab algorytm: ', mainAlgorytm, var ', ', 'GradSupp', ', ', ...
               ' Start point: ', num2str(x0(1)), ',', num2str(x0(2))];
       else
           text = ['Matlab algorytm: ', mainAlgorytm, var, ' Start point: ',...
               num2str(x0(1)), ',', num2str(x0(2))];
       end
        title(text)
        if grad
            text = ['LOG', mainAlgorytm, '_', inAlgorytm, '_', 'GRAD', ...
                'Start point_', num2str(x0(1)), '_', num2str(x0(2)), '.png'];
        else
            text = ['LOG', mainAlgorytm, '_', inAlgorytm, 'Start point_', num2str(x0(1)), ...
                     '_', num2str(x0(2)), '.png'];
        end
        print('-dpng', text, '-r400')
    end
end