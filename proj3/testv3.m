clear all
close all
clc

global history_b history_w1 history_w2 history_w3 test_data_error learn_data_error full_data_error
history_w1 = [];
history_w2 = [];
history_w3 = [];
history_b = [];
test_data_error = [];
learn_data_error = [];
full_data_error = [];

[x, y] = AEproj3_data(310173); 

D = [x, y];

eta = 0.9;
[w, b] = Classification(D, eta);

printPerceptronParams(history_w1, history_w2, history_w3, history_b, test_data_error, learn_data_error, full_data_error, eta)

printPoints(x, y, eta)

function [w, b] = Classification(D, eta)
    numRows = size(D, 1);
    selectedRows = randperm(numRows, 16);
    allRows = 1:numRows;
    missingRows = setdiff(allRows, selectedRows);    
    
    learn = D(selectedRows, :);
    test = D(missingRows, :);

    global history_w1 history_w2 history_w3 history_b test_data_error full_data_error learn_data_error
    w = [0, 0, 1]';
    b = 0;
    
    r = max(vecnorm(learn(:, 1:end-1)'));

    history_w1 = [history_w1 w(1)];
    history_w2 = [history_w2 w(2)];
    history_w3 = [history_w3 w(3)];
    history_b = [history_b b];
    iter_err = get_error(test, w, b);
    disp(iter_err)
    test_data_error = [test_data_error, iter_err];
    iter_err_lear = get_error(learn, w, b);
    learn_data_error = [learn_data_error, iter_err_lear];
    data_err = get_error(D, w, b);
    full_data_error = [full_data_error, data_err];
    
    while ~all(classify(learn, w, b) == learn(:, end))
        for i = 1:size(learn, 1)
            xi = learn(i, 1:end-1)';
            yi = learn(i, end);
            
            % Jeśli punkt jest nieprawidłowo sklasyfikowany -> aktualizacja wag
            if sign(w' * xi - b) ~= yi
                w = w + eta * yi * xi;
                b = b - eta * yi * r^2;
            end
            history_w1 = [history_w1 w(1)];
            history_w2 = [history_w2 w(2)];
            history_w3 = [history_w3 w(3)];
            history_b = [history_b b];
            disp(classify(test, w, b) == test(:, end))
            iter_err = get_error(test, w, b);
            disp(iter_err)
            test_data_error = [test_data_error, iter_err];
            iter_err_lear = get_error(learn, w, b);
            learn_data_error = [learn_data_error, iter_err_lear];
            data_err = get_error(D, w, b);
            full_data_error = [full_data_error, data_err];
        end
    end
end

function error = get_error(D, w, b)
    err = 0;
    len = length(D);
    for k=1:len
        if sign(w' * D(k, 1:3)' - b) ~= D(k, 4)
            err = err + 1;
        end
    end
    error = 100*err/len;
end

function classification = classify(D, w, b)
    classification = sign(D(:, 1:end-1) * w - b);
end

function printPerceptronParams(history_w1, history_w2, history_w3, history_b, learning_error, learn_data_error, full_data_error, eta)
    figure(1)
    subplot(3,1,1);
    hold on;
    title(['Zmiany wag klasyfikatora, eta: ', num2str(eta)])
    plot(history_w1);
    grid on;
    legend('w1')
    subplot(3,1,2);
    plot(history_w2);
    grid on;
    legend('w2')
    subplot(3,1,3);
    plot(history_w3);
    grid on;
    legend('w3')
    print('-dpng', ['zmiana_w_eta', num2str(eta), '.png'], '-r400')

    figure(2)
    plot(history_b)
    title(['Zmiany biasu klasyfikatora', ', eta: ', num2str(eta)])
    grid on;
    legend('b')
    print('-dpng', ['zmiana_b_eta', num2str(eta), '.png'], '-r400')

    figure(3)
    hold on
    grid on;
    ylabel("%")
    plot(learning_error)
    title('Błąd na danych testowych w trakcie uczenia, eta: ', num2str(eta))
    print('-dpng', ['zmiana_e_eta', num2str(eta), '.png'], '-r400')

    figure(4)
    hold on
    grid on;
    ylabel("%")
    plot(full_data_error)
    title('Błąd na wszytskich danych w trakcie uczenia, eta: ', num2str(eta))
    print('-dpng', ['zmiana_fe_eta', num2str(eta), '.png'], '-r400')

    figure(5)
    hold on
    grid on;
    ylabel("%")
    plot(learn_data_error)
    title('Błąd na danych uczących w trakcie uczenia, eta: ', num2str(eta))
    print('-dpng', ['zmiana_te_eta', num2str(eta), '.png'], '-r400')
end

function printPoints(dataX, dataY, eta) % do gifa
    global history_b history_w1 history_w2 history_w3

    figure(10);
    for i=1:length(history_b)
        b = history_b(i);
        w1 = history_w1(i);
        w2 = history_w2(i);
        w3 = history_w3(i);

        x = linspace(-10, 10, 100);
        y = -(b + w1 * x) / w2;
        z = -(b + w1 * x) / w3;
        % 
        % subplot(3, 1, 1)
        plot(x, y, 'b', 'LineWidth', 2);
        xlabel('X');
        ylabel('Y');
        title(['Wykres 2D', ', i: ', num2str(i), ', eta: ', num2str(eta)]);

        hold on
        grid on

        for k=1:length(dataY)
            if dataY(k) == 1
                scatter(dataX(k, 1), dataX(k, 2), 'r', 'filled');
            else 
                scatter(dataX(k, 1), dataX(k, 2), 'b', 'filled');
            end
        end
        hold off
        drawnow;

        % Zapisywanie klatki do pliku GIF
        frame = getframe(gcf);
        im = frame2im(frame);
        [imind, cm] = rgb2ind(im, 256);

        if i == 1
            imwrite(imind, cm, ['animacja_eta_', num2str(eta), '.gif'], 'gif', 'Loopcount', inf);
        else
            imwrite(imind, cm, ['animacja_eta_', num2str(eta), '.gif'], 'gif', 'WriteMode', 'append');
        end 
    end

    imshow(['animacja_eta_', num2str(eta), '.gif']);
end