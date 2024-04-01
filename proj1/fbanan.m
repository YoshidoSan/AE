function [z, g] = fbanan(x, a, b)
    z = (1 - x(1) + a)^2 + 100*(x(2) - b - (x(1) - a)^2)^2;
    dx = 2*(200*(x(1)-a)*(a^2-2*a*x(1)+b+x(1)^2-x(2))-a+x(1)-1);
    dy = 200*(-(x(1)-a)^2-b+x(2));
   
    g = [dx, dy];
    % y ~ -0.5
    % x ~ 0
end