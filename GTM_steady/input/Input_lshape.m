


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
% mesh file for reality simulation
PROBLEM.General.MeshName = 'l_shape_real';
% mesh file for reconstruction/computation
PROBLEM.General.MeshName_comp = 'l_shape_comp';
% Name of output file
PROBLEM.General.SaveName = 'l_shape';
% SaveMode
PROBLEM.General.SaveMode = 1;
% keep statistics about solver etc 
PROBLEM.General.Stats    = 1;
% presentation mode (no title in figures)
PROBLEM.General.PresentMode    = 1;

%% Video setup
PROBLEM.Video.Record=false;
PROBLEM.Video.Quality=100;
PROBLEM.Video.FrameRate=2;

%% Solver setup
% Accuracy of iterative solver (stop iterating if err is below accuracy)
PROBLEM.Solver.Accuracy = 1e-3;
% Maximum iteration steps of solver (stop iteration if iter exeeds NoI)
PROBLEM.Solver.NoI      = 20;
% Regularisation coefficient
% PROBLEM.Solver.lambda   = 1e-10;

%% Loading type
% number of electrodes
PROBLEM.Electrode.N_e  = 6;
% number of FE element edges per electrode
PROBLEM.Electrode.N_edges  = 6;
% Flux on electrode
PROBLEM.Electrode.Temp = 10.0;
% Electrode impedance
PROBLEM.Electrode.Im = 0.01;

%% MEASUREMENT ERROR
% sensor error [mean,standard deviation]
PROBLEM.Error.vars = [0,0.25/3];
% distribution type ('normal' or 'lognormal')
PROBLEM.Error.type = 'normal';
% sampling method 'lhs' or 'montecarlo'
PROBLEM.Error.sampling = 'lhs';
% number of samples
PROBLEM.Error.N_s = 1e4;

% % delete electrodes on sides
% PROBLEM.Electrode.delete_electrodes={[0.0 1.0;0.0 0.6];...
%                                      [0.6 0.0;1.0 0.0]};
PROBLEM.Electrode.delete_electrodes={[0.00 0.99; -0.1 -0.1;0.99 0.0;0.9 0.9]};
% PROBLEM.Electrode.delete_electrodes={};

% PROBLEM.Electrode.delete_measurements={[0.0 0.99;0.0 0.61];...
%                                      [0.61 0.0;0.99 0.0]};
PROBLEM.Electrode.delete_measurements={[0.00 0.99; -0.1 -0.1;0.99 0.0;0.9 0.9]};
% % omit measurements on sides
% PROBLEM.Electrode.delete_measurements={[0.0 0.99;0.0 0.61];...
%                                      [0.61 0.0;0.99 0.0];
%                                      % single sensor on inner left bnd
%                                      [0.00 0.6;0.3 0.6];
%                                      [0.40 0.6;0.6 0.6];
%                                      % single sensor on outer left boundary
% %                                      [0.20 1.0;1.0 1.0];
%                                      [0.10 1.0;1.0 1.0]};
% PROBLEM.Electrode.delete_measurements={[0.025 0.025; 0.025 1.025;1.025 1.025;1.025 0.025]};
% PROBLEM.Electrode.delete_measurements={};

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
PROBLEM.LoadDef.BC = {[0.0 0.6;0.6 0.6],'transfer',30,1e1;... inner left boundary
                      [0.6 0.6;0.6 0.0],'transfer',30,1e1;... inner right boundary
                      [1.0 0.0;1.0 1.0],'transfer',15,1e1;... outer right boundary
                      [1.0 1.0;0.0 1.0],'transfer',15,1e1};% outer left boundary

% %% Mesh setup
% MESH = load(fullfile('mesh',PROBLEM.General.MeshName),'-mat');



