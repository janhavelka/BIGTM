function [LOAD,eval_time]=GTM_getMeasurementBoundary(MESH,PROBLEM,LOAD)

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

% get the measurement nodes
LOAD.m_nodes=true(MESH.nnodes,1);
% get just the boundary nodes to participate (delete the interior nodes)
LOAD.m_nodes(MESH.int_nodes)=false;

% delete measurement nodes on chosen edges (loop over defined edges)
for i=1:length(PROBLEM.Measurements.delete_measurements)
    [~,idx_m]=inpoly(MESH.Nodes,PROBLEM.Measurements.delete_measurements{i});
    LOAD.m_nodes(idx_m,:)=false;
end

LOAD.m_coords=MESH.Nodes(LOAD.m_nodes,:);

% get the evaluation time
eval_time=toc;






