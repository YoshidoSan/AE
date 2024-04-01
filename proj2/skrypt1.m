function items = skrypt1()
numerAlbumu=310173; %% Wpisz swój numer albumu 
rng(numerAlbumu);
N=32;
items(:,2)=round(0.1+0.9*rand(N,1),1);
items(:,1)=round(1+99*rand(N,1));
end