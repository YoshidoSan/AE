clear all
close all

[a, b, X1, Y1, X2, Y2, X3, Y3, X4, Y4] = stale();
X = [X1, X2, X3, X4];
Y = [Y1, Y2, Y3, Y4];

i = 1;
for k=1:length(X)
    x = X(k);
    y = Y(k);
    
    disp('Start point: ')
    disp('x:')
    disp(x)
    disp('y:')
    disp(y)
    % fminunc #1 Quasi Newton  Approximated by solver
    [xsol,fval,history,info] = runfmin('fminunc', 'quasi-newton', 'None', [x, y], [a, b], i);
    i = i + i;
    disp('Quasi Newton  Approximated by solver')
    disp(['Point: ', num2str(xsol)])
    disp(['MinValue: ', num2str(fval)])
    disp(['Iterations: ', num2str(info.iterations)])
    disp(['Function counts: ', num2str(info.funcCount)])

%     % fminunc #2 Quasi Newton Gradient supplied
    [xsol,fval,history,info] = runfmin('fminunc', 'quasi-newton', 'on', [x, y], [a, b], i);
    i = i + 1;
    disp('Quasi Newton Gradient supplied')
    disp(['Point: ', num2str(xsol)])
    disp(['MinValue: ', num2str(fval)])
    disp(['Iterations: ', num2str(info.iterations)])
    disp(['Function counts: ', num2str(info.funcCount)])


     % fminunc #3 Trust region Approximated by solver
    [xsol,fval,history,info] = runfmin('fminunc', 'trust-region', 'On', [x, y], [a, b], i);
    i = i + 1;
    disp('Trust region Approximated by solver')
    disp(['Point: ', num2str(xsol)])
    disp(['MinValue: ', num2str(fval)])
    disp(['Iterations: ', num2str(info.iterations)])
    disp(['Function counts: ', num2str(info.funcCount)])


%    fminunc #4 fminsearch
    [xsol,fval,history,info] = runfmin('fminsearch', 'None', 'None', [x, y], [a, b], i); 
    i = i + 1;
    disp('fminsearch')
    disp(['Point: ', num2str(xsol)])
    disp(['MinValue: ', num2str(fval)])
    disp(['Iterations: ', num2str(info.iterations)])
    disp(['Function counts: ', num2str(info.funcCount)])

    disp('#############################')
end