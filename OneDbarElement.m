%%% Introduction to FEM %%%


%% A program for 1D bar problem with 3 element and 4 nodes%%

%% 1D bar stepped bar with A1= 0.5 m2, A2= 1 m2, E= 200 Gpa, P= 300KN, and
%% it is fixed from one end at the larger area section. 
%% P is acting in right side at small area element at the middle, leaving 1m
%% both side and large elemnt is of 2 m. Find the nodal displacement of the
%% bar.%%

% {we will try to convert this problem to our spring element nodal
% system.So,we will have 3 spring, and 4 nodal point, being 4th one
% fixed.So U4 is 0. 
% for bar K= AE/L}

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

K1 = (200*1e9*0.5/1.0) * [1 -1; -1 1]

rows = [1 2]
cols = rows;

Kglobal(rows, cols)= Kglobal(rows, cols) + K1

% Element 2
%**********%

K2 = K1

rows = [2 3]
cols = rows;

Kglobal(rows, cols)= Kglobal(rows, cols) + K2

% Element 3
%*********%

K3 = (200*1e9*1.0/2.0) * [1 -1; -1 1]

rows = [3 4]
cols = rows;

Kglobal(rows, cols)= Kglobal(rows, cols) + K3

 

% External forces
Fglobal(2) = 300 * 1000

% Boundary condition
U4 = 0.0;

% Direct elimination method approach
% node 4
Fglobal = Fglobal - Kglobal(:,4) *U4

dof_free = [1 2 3]

Kg = Kglobal(dof_free, dof_free)
Fg = Fglobal(dof_free)

% Solve for the unknown (free) DOFS

Udirelim = Kg\Fg

% Create the full DOFs array
Ufull = zeros(totaldof,1);
Ufull(4) = U4;
Ufull(dof_free) = Udirelim

% calculate reactions

R = Kglobal*Ufull - Fglobal
