
function [LOAD,eval_time] = GTM_getCapacity(MESH,PROBLEM,LOAD,c_v)

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

tic

LOAD.C=sparse(MESH.R_s,MESH.C_s,MESH.G_c.*c_v(:,ones(1,9))');

if strncmpi(PROBLEM.TimeSettings.Capacity,'diagonal',4)
    LOAD.C=diag(sum(LOAD.C,2));
end





% get the evaluation time
eval_time=toc;
