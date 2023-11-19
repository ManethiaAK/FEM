%%% 1 D Heat Condunction problem in FEM %%%

%% Here we have a heat problem setup with bars, 1st and 3rd bar are insulated with T1= 150°C and T4= 10°C and both are 0.03 m in lenght.
%% Middle section is made of brick with 0.1m length. aplha 1 = 0.07 W/(m K), alpha 2 = 0.7 W((m k). Area A is same throughout 1 m2. We have to 
%% determine nodal temperature T2 and T3. (alpha is thermal conductivity)


% number of elements
nelem = 3

% number of nodes
nnode = 4

% number of degree of freedom per nodes
ndof = 1

% total number of dof for the problem
 totaldof = nnode * ndof

% our global stiffness matrix
Kglobal = zeros(totaldof, totaldof)

% initialise global force vector
Fglobal = zeros(totaldof, 1)

%% Matrix assembly

% Element 1
%***********%
% Local stiffness matrix for element 1
K1 = (0.07*1.0/0.03) * [1 -1; -1 1]

rows = [1 2]
cols = rows;

Kglobal(rows, cols)= Kglobal(rows, cols) + K1

% Element 2
%**********%
% Local stiffness matrix for element 2
K2 = (0.7*1.0/0.1) * [1 -1; -1 1]

rows = [2 3]
cols = rows;

Kglobal(rows, cols)= Kglobal(rows, cols) + K2

% Element 3
%*********%
% Local stiffness matrix for element 3
K3 = K1;

rows = [3 4]
cols = rows;

Kglobal(rows, cols)= Kglobal(rows, cols) + K3


% Boundary conditions
% Convert the temperature in kelvin
U1 = 150 + 273;
U4 = 10 + 273;

% Direct elimination approach
% node 1
Fglobal = Fglobal - Kglobal(:,1)*U1

% Node 4
Fglobal = Fglobal - Kglobal(:,4)*U4

dof_free = [2,3]

Kg = Kglobal(dof_free, dof_free)
Fg = Fglobal(dof_free)


Udirelim = Kg\Fg

% Convert back to celcius
Udirelim = Udirelim - 273

 