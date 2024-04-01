clear all
clc
close all

items = skrypt1();
itemsLength = length(items);
maxW = get_max_weight(items);

lb(1:1:32) = 0;
ub(1:1:32) = 1;

calkowite_parametry(1:1:32) = (1:1:32);

seletion = {'selectionroulette', 'selectiontournament'};

for sel=1:length(seletion)
    global history_pop history_Best history_Score history_Var history_Worst history_Avg
    history_pop     = {};
    history_Score   = {};
    history_Best    = [];
    history_Worst   = [];
    history_Var     = [];
    history_Avg     = [];
    
    opts = optimoptions('ga', 'OutputFcn',@gaoutfun, 'Display', 'iter', ...
        'EliteCount', 1, ...
        'CrossoverFraction', 0.8, ...
        'MutationFcn', {@mutationadaptfeasible, 0.2}, ...
        'SelectionFcn', seletion(sel), ...
        'PopulationSize',75,"MaxGenerations",750, ...
        'MaxStallGenerations', 750);
    
    wektor = ga(@(x) forAG(x, items, maxW, itemsLength), 32, [], [], [], [], lb, ub, [], calkowite_parametry, opts);
    wektor_num = transformBinaryToItems(wektor, items, itemsLength);
    wektor_value = getValue(wektor_num);
    wektor_weight = getWeight(wektor_num);
    disp(wektor)
    disp(['Value: ', num2str(wektor_value)])
    disp(['Weight: ', num2str(wektor_weight)])
    
    
    figure(1)
    hold on
    plot(history_Worst)    
    figure(2)
    hold on
    plot(history_Var)
    figure(3)
    hold on
    plot(history_Avg)
    figure(4)
    hold on
    plot(history_Best)
end
figure(1)
title("Najgorsze")
legend("Ruletka", "Turniej")
figure(2)
title("Wariacja")
legend("Ruletka", "Turniej")
figure(3)
title("Średnia")
legend("Ruletka", "Turniej")
figure(4)
title("Najlepsze")
legend("Ruletka", "Turniej")

%% functions
function maxW = get_max_weight(items)
    maxW = sum(items(:, 2)) * 3/10; 
end

function valid = isValid(itemsGet, maxW)
    W = sum(itemsGet(:, 2));
    if W > maxW
        valid = false; 
    else
        valid = true;
    end
end

function value = getValue(itemsGet)
    value = sum(itemsGet(:, 1));
end

function value = getWeight(itemsGet)
    value = sum(itemsGet(:, 2));
end

function itemsTrans = transformBinaryToItems(binaryItems, items, itemsLength)
    itemsTrans = [];
    for k=1:itemsLength
       if binaryItems(k) == 1
          itemsTrans = [itemsTrans; [items(k, 1) items(k, 2)]];
       else
          itemsTrans = [itemsTrans; [0 0]];
       end
    end
end

function value = forAG(itemsGet, items, maxW, itemsLength)
   items = transformBinaryToItems(itemsGet, items, itemsLength);
   valid = isValid(items, maxW);
   if valid == false
       value = 0;
   else
       value = -getValue(items);
   end
end