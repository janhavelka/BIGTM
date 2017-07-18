function LOAD = GTM_newLoad( MESH,PROBLEM,MDATA )

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


% get the boundary data according to boundary conditions defined in input file
[LOAD,eval_time] = GTM_getBoundary(MESH,PROBLEM,struct());

% get regularisation matrix
[LOAD,eval_time] = GTM_getRegular(MESH,PROBLEM,LOAD);

% get augmented matrices
[LOAD,eval_time] = GTM_getAugment(MESH,PROBLEM,LOAD);

% get RHS
[LOAD,eval_time] = GTM_getRHS(MESH,PROBLEM,LOAD);
% 
% % get capacity matrix
% [LOAD,eval_time] = GTM_getCapacity(MESH,PROBLEM,LOAD,ones(MESH.nelements,1));

% identify the actual nodes where one takes measurements
[LOAD,eval_time]=GTM_matchMeasurements(MESH,PROBLEM,LOAD,MDATA);

LOAD.M_o=MDATA.LOAD.M_o;
LOAD.M_ofull=MDATA.LOAD.M_ofull;