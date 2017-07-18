function RDATA = GTM_getReconstructionErr(MDATA,PROBLEM)

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
MESH = load(fullfile('mesh',PROBLEM.General.MeshName_comp),'-mat');
MESH = MeshBasics( MESH );

% get LOAD (electrode positions, regularisation matrix, etc)
LOAD = GTM_newLoad( MESH,PROBLEM,MDATA );

% match two meshes, i.e. interpolate the results
MESH = getMeshInterpolation(MESH,MDATA.MESH);



% artificially add conductivity field
sigma_fun = @(x,y) 1/15.*(abs((5+3*x.^2+2*y-y.*x-5*sin(x/0.075).*y+2*cos(y/0.1).*x*5))+5);
% true_mat=@(x,y) 0.*x+1;
MDATA.MATERIAL.sigma_true_fine = sigma_fun(MESH.Elements(:,5),MESH.Elements(:,6));

rho_fun = @(x,y) 5.*(50.*x.^3+100.*x.^2+150.*y.^2-100.*y.*x+100.*y)+500+300.*cos(x.*y*2*pi*5)-300.*sin(x*2*pi*3);
rho=rho_fun(MESH.Elements(:,5),MESH.Elements(:,6));
c=850;
MDATA.MATERIAL.cv_true_fine=c(ones(MESH.nelements,1)).*rho;



% get errors
LOAD = GTM_getMeasurementErrors(MESH,PROBLEM,LOAD);

% Plot the measurements scheme
GTM_PlotBasics(MESH,PROBLEM,LOAD,[],[],-2,[]);

% solve the problem
RESP = GTM_solveProblemErr(MESH,PROBLEM,LOAD,MDATA);

% Simulation/Measurement Data
RDATA.MESH = MESH;
RDATA.RESP = RESP;
RDATA.LOAD = LOAD;