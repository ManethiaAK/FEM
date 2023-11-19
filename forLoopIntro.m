%% for loop for stiffness assembly for large number of element
%% we will replace the matrix assembly block with for loop element
 
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

springconstant_array = [100.0, 200.0, 100.0];
elem_dof_conn = [1 2; 2 3; 3 4]; % update this array as per the number of element

%% Matrix assembly

for elnum= 1:nelem
    % calculate the element stiffness matrix


    springconstant = springconstant_array(elnum);
    Klocal = springconstant*[1 -1;-1 1];

    % get element to global DOF connectivity
    indsForAssembly = elem_dof_conn(elnum, :);

    % assemble the contributions from local to global

    Kglobal(indsForAssembly, indsForAssembly) = Kglobal(indsForAssembly, indsForAssembly) + Klocal;

end    


% External forces
Fglobal(2) = 300 * 1000

% Boundary condition
U4 = 0.0;
U1= 0.0;
% Direct elimination method approach
Fglobal = Fglobal - Kglobal(:,1) *U1
Fglobal = Fglobal - Kglobal(:,4) *U4

dof_free = [2 3]

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
