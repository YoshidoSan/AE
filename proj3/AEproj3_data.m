function [x,y] = AEproj3_data(numer_albumu)
% AEPROJ3_DATA Generacja danych treningowych do projektu nr 3 z przedmiotu AE
% [X Y] = AEPROJ3_DATA(NUMER_ALBUMU) generuje macierz punktów X i wektor
% etykiet Y dla numeru albumu. W przypadku wykonania projektu w parze należy 
% wprowadzić niższy numer albumu.
%
rng(numer_albumu); 
N=20;
x(:,1:2)=randn(N/2,2)+N/10;
x(:,3)=randn(N/2,1);
for n=1:N/2
 x(N/2+n,:)=-x(n,:);
end
y=[-ones(N/2,1); ones(N/2,1)];
end