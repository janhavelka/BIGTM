


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
PROBLEM.General.MeshName = 'simple_1x1_899e';
% Name of output file
PROBLEM.General.SaveName = NameSequence('results_simple_fine','output',[],'.mat',[]);
% SaveMode
PROBLEM.General.SaveMode = 1;
% keep statistics about solver etc 
PROBLEM.General.Stats   = 1;


%% Solver setup
% Accuracy of iterative solver (stop iterating if err is below accuracy)
PROBLEM.Solver.Accuracy = 1e-6;
% Maximum iteration steps of solver (stop iteration if iter exeeds NoI)
PROBLEM.Solver.NoI      = 10;
% Regularisation coefficient
PROBLEM.Solver.lambda   = 1e-12;

%% Loading type
% number of electrodes
PROBLEM.Electrode.N_e = 20;
% Current flow through each electrode (mA)
PROBLEM.Electrode.C   = 1;
% Impedance for each electrode
PROBLEM.Electrode.Zi  = 1;

% Current Injection Method (CIM):
% 'adj' for adjacent method
% 'neigh' for neighbouring method --not working--
PROBLEM.Electrode.CIM = 'adj';
% Load type (prescribing in each set of electrodes):
% 'Dirichlet' (prescribing pressure/temperature/voltage) --not working--
% 'Neumann' (prescribing water flux/temp flux/current)
% 'Mixed' --not working--
PROBLEM.LoadType   = 'neumann';

%% Material parameter setup
% PROBLEM.




%% Mesh setup
MESH                       = load(fullfile('mesh',PROBLEM.General.MeshName),'-mat');