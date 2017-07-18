function LOAD = GTM_getBoundary(MESH,PROBLEM,LOAD)
% NEED TO FIX THE DOUBLE CHECK OF BOUNDARY

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


% number of distinct boundaries
LOAD.Boundary.N_b = size(PROBLEM.LoadDef.BC,1);

% extract boundary node coords
nc=MESH.Nodes(MESH.Boundary.Elements(:,1),:);
% identify the boundary nodes belonging to specific boundary condition
for i=1:LOAD.Boundary.N_b
    % get logical array of nodes on boundary
%     [~,node_map]=inpolygon(nc(:,1),nc(:,2),PROBLEM.LoadDef.BC{i,1}(:,1),PROBLEM.LoadDef.BC{i,1}(:,2));
    [node_map]=inpoly(nc,PROBLEM.LoadDef.BC{i,1});
    % get the real node numbers
    LOAD.Boundary.Nodes{i}=MESH.Boundary.Elements(node_map,1);
    LOAD.Boundary.Elements{i}=MESH.Boundary.Elements(node_map,:);
    % cut off the overlapping elements (results into valid idxs - vidx)
    vidx = all(ismember(MESH.Boundary.Elements(node_map,1:2),MESH.Boundary.Elements(node_map,1)),2);
    LOAD.Boundary.Elements{i}=LOAD.Boundary.Elements{i}(vidx,:);
    
    % (element length)*(transfer coefficient)*(outside temperature)
    LOAD.Boundary.Value{i}=LOAD.Boundary.Elements{i}(:,3)*PROBLEM.LoadDef.BC{i,3}*PROBLEM.LoadDef.BC{i,4};

    LOAD.Boundary.t_idx{i} = all(ismember(MESH.Boundary.R_s(2:3,:)',LOAD.Boundary.Nodes{i}'),2);
end






