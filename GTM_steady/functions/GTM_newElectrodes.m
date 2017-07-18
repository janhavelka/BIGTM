function LOAD=GTM_newElectrodes(MESH,PROBLEM,MDATA)
% Get the number, positions, plot of electrodes
% (boundary elements comes out in an ordered series)

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


% red the number of electrodes from the real settings
LOAD.Electrodes.nelements=MDATA.LOAD.nelements;

nc=MESH.Nodes(MESH.Boundary.Elements(:,1),:);
LOAD.Electrodes.e_idx=false(size(MESH.Boundary.Elements,1),LOAD.Electrodes.nelements);
LOAD.Electrodes.m_nodes=false(MESH.nnodes,LOAD.Electrodes.nelements);
for i=1:LOAD.Electrodes.nelements
    % get logical array of (electrode) nodes on boundary
    node_map=inpoly(nc,MDATA.LOAD.e_points{i});
    LOAD.Boundary.Nodes{i}=MESH.Boundary.Elements(node_map,1);
    % Node indexes (in boundary nodes) of electrodes for each active electrode
    LOAD.Electrodes.e_idx(:,i) = all(ismember(MESH.Boundary.R_s(2:3,:)',LOAD.Boundary.Nodes{i}'),2);
    % get indexe of measured nodes w.r.t. new mesh
    [~,d]=dsearchn(MDATA.LOAD.m_points{i},MESH.Nodes);
    % get the measurement nodes
    LOAD.Electrodes.m_nodes(:,i)=d<1e-3;
end

% Plot the electrode scheme
GTM_PlotBasics(MESH,PROBLEM,LOAD,[],[],-3);



























