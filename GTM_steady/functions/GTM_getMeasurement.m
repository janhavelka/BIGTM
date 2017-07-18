function MDATA = GTM_getMeasurement(PROBLEM)

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


% Edit MESH variables if needed (precompute necessary variables if they are missing)
MESH = load(fullfile('mesh',PROBLEM.General.MeshName),'-mat');
MESH = MeshBasics( MESH );

% get MATERIAL information (gen. true material, etc)
MATERIAL = GTM_getMaterial( MESH,PROBLEM );

% get LOAD (electrode positions, regularisation matrix, etc)
LOAD = GTM_getLoad( MESH,PROBLEM );

% get the model response
[M_m,M_f]=GTM_getForward(MESH,LOAD,MATERIAL.sigma_true);

% Simulation/Measurement Data
MDATA.MESH = MESH;
MDATA.MATERIAL = MATERIAL;
MDATA.LOAD = LOAD.Electrodes;
MDATA.LOAD.M_m=M_m;
MDATA.LOAD.M_f=M_f;














