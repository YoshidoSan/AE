function [state,options,optchanged] = gaoutfun(options,state,flag)
global history_pop history_Best history_Score history_Var history_Worst history_Avg
optchanged = false;

%% - bo odwrócone zadanie optymalizacji
history_pop   = [history_pop;state.Population];
history_Best  = [history_Best; max(-state.Score)];
history_Worst = [history_Worst; min(-state.Score)];
history_Score = [history_Score;state.Score];
history_Var   = [history_Var; std(state.Score)^2];
history_Avg   = [history_Avg; mean(-state.Score)];
end