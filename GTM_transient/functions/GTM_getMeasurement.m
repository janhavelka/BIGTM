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
LOAD = GTM_getLoad( MESH,PROBLEM,MATERIAL );

% Plot the measurements scheme
eval_time=GTM_PlotBasics(MESH,PROBLEM,LOAD,[],[],-2,[]);

% Calculate the true measurements
[LOAD.M_ofull,LOAD.M_o,eval_time]=GTM_getForward(MESH,PROBLEM,LOAD,MATERIAL.sigma);

% Simulation/Measurement Data
MDATA.MESH = MESH;
MDATA.MATERIAL = MATERIAL;
MDATA.LOAD = LOAD;




















