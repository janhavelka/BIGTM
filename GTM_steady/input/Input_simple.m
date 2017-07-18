


% Jan Havelka (jnhavelka@gmail.com)
% Copyright 2016, Czech Technical University in Prague
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.


%% General setup
PROBLEM.General.MeshName   = 'simple_1x05_64e.mat';
% Name of output file
PROBLEM.General.SaveName   = NameSequence('results_simple','output',[],'.mat',1);
% SaveMode
PROBLEM.General.SaveMode   = 1;
% keep statistics about solver etc 
PROBLEM.General.Stats    = 1;

%% Solver setup
% Accuracy of iterative solver (stop iterating if err is below accuracy)
PROBLEM.Solver.Accuracy = 1e-6;
% Maximum iteration steps of solver (stop iteration if iter exeeds NoI)
PROBLEM.Solver.NoI      = 10;
% Regularisation coefficient
PROBLEM.Solver.lambda   = 1e-12;

%% Loading type
% number of electrodes
PROBLEM.Electrode.N_e  = 30;
% Temperature on electrode
PROBLEM.Electrode.Temp = 0.0;
% Electrode impedance
PROBLEM.Electrode.Im = 100.5;

%% Load definition
% definition of boundary conditions
% [N x 4] cell array of N boundary conditions
% BC{i,1} - [x1 y1;x2 y2] coordinates "from-to" where the BC apply
% BC{i,2} - BC type 'transfer'/'dirichlet'/'neumann'/'robin'
% BC{i,3} - prescribed value of BC. For each type:
%         - 'transfer' - defines a T0 in eq.: q=alpha*(T-T0)
%         - 'dirichlet' - sets the value of potential
%         - 'neumann' - sets the value of fluxes in [flux/m] - is then multiplied by length of element edge
% BC{i,4} - sets the additional information for each BC. For dirichlet/neumann leave the entry empty, i.e. [], 
%           for 'transfer' it defines the transfer coefficient alpha
% The hierarchy is following: 'dirichlet' - 'neumann' - 'transfer', i.e. dirichlet overrides neumann etc.
PROBLEM.LoadDef.BC = {[0.0 0.0;0.0 1.0],'transfer',30,0.1;... left boundary
                      [1.0 1.0;1.0 0.0],'transfer',-5,0.1};% right boundary

%% Mesh setup
MESH = load(fullfile('mesh',PROBLEM.General.MeshName),'-mat');