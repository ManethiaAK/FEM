clear all;
clc;

%% Question- Find displacement of node 2 and 3, node 1 and 4 are fixed.
%% K1=K3=100 N/mm, K2=200 N/mm, force P at node 3 directed toward node 4 is 100 N. All the elements are in series.

nelem = 3
nnode = 4

ndof = 1

totaldof = nnode*ndof

Kglobal = zeros(totaldof, totaldof)

% element 1

K1 = 100*[1 -1; -1 1]

rows = [1 2]
cols = rows;

Kglobal(rows, cols)= Kglobal(rows, cols) + K1

%element 2
K2 = 200*[1 -1; -1 1]

rows = [2 3]
cols = rows;

Kglobal(rows, cols)= Kglobal(rows, cols) + K2

%element 3

K3 = 100*[1 -1; -1 1]

rows = [3 4]
cols = rows;

Kglobal(rows, cols)= Kglobal(rows, cols) + K3


% global force vector

Fglobal = zeros(totaldof, 1)

% we add force P 100 in 3rd row
Fglobal(3) = Fglobal(3) + 100

%%% apply the boundary conditions for unknown values%%%
%% using penalty approach and adding penalty parameter kappa



% Kg = Kglobal;
%  Fg = Fglobal;

 U1 = 0.0;
 U4 = 0.0;

 % kappa = 1e14;

 % node 1
%  Kg(1,1) = Kg(1,1) + kappa
 % Fg(1) = Fg(1) + kappa * U1

 % node 4
 % Kg(4,4) = Kg(4,4) + kappa
%  Fg(4) = Fg(4) + kappa *U4

% now we solve for U by solving Kg/Fg

% Upenalty = Kg\Fg

% U1 and U4 must be zero, something is wrong, increase the value of penalty
% parameter to get desired values, after using 1e9 we are still not getting
% zeros, that is the disadvantage of penalty method. At 1e14 we will get
% zeros but still it is a large value. 




%% Now let's use Row modification approach for each known DOF for boundary conditions


% Kg = Kglobal;
% Fg = Fglobal;

%node 1
% Kg(1,:) = Kg(1,:) *0.0
% Kg(1,1) = Kg(1,1) + 1
% Fg(1) = U1

%node 4
% Kg(4,:) = Kg(4,:) * 0.0
% Kg(4,4) = Kg(4,4) + 1
% Fg(4) = U4

% Urowmod = Kg\Fg

% this method is better than penalty but matix symmetry is lost

%% let's use Direct elimination method (USED MOSTLY)

% for node 1
Fglobal = Fglobal - Kglobal(:,1)*U1

% for node 4
 Fglobal = Fglobal - Kglobal(:,4)*U4

% Now we wil remove rows and columns corresponding to DOF values

Kg = Kglobal([2,3],[2,3])
Fg = Fglobal([2,3])

% value of displacement at node 2 and 3

Udirelim = Kg\Fg

%% as node 1 and 4 are fixed, there will be reaction forces-> R=KU-F

Ufull = zeros(totaldof, 1)

Ufull(1) = U1
Ufull(4) = U4

Ufull([2 3]) = Udirelim

% we will use full matrices before direct elim approach
R = Kglobal * Ufull - Fglobal

