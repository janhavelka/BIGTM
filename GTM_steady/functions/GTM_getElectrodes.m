function LOAD=GTM_getElectrodes(MESH,PROBLEM)
% Get the number, positions, plot of electrodes

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



% number of Electrode nodes (i.e. electrode edges +1)
NE_nodes=PROBLEM.Electrode.N_edges+1;

% theoretical maximum of electrodes for given boundary (no overlaps, i.e. +1 free node)
% (elements on edge = nodes on edge)
NE_max=floor(MESH.Boundary.nelements/(NE_nodes+1));

% limit the number of possible electrodes
LOAD.Electrodes.N_e = PROBLEM.Electrode.N_e;
if PROBLEM.Electrode.N_e>NE_max    
    LOAD.Electrodes.N_e=NE_max;
    disp(['The maximum possible number of electrodes (' num2str(NE_max) ') for given domain was exceeded'])    
end

% determine the free Node Gap (NG) (number of free nodes between elecrodes)
% take lesser gap because of periodicity of boundary
% (total number of nodes - nodes occupied by electrodes)/(number of electrodes=number of gaps with periodicity)
NG=floor((MESH.Boundary.nelements-LOAD.Electrodes.N_e*(NE_nodes))/LOAD.Electrodes.N_e);

% create idx array identifying electrode nodes
idx=repmat([1:NE_nodes]',1,LOAD.Electrodes.N_e)+repmat([0:(LOAD.Electrodes.N_e-1)]*(NE_nodes+NG),NE_nodes,1);

% node indexes (electrode node indexes in columns)
node_idx=reshape(MESH.Boundary.Elements(idx,1),NE_nodes,[]);

% delete electrode elements on chosen edges (loop over defined edges)
idx_e=false(numel(node_idx),1);
for i=1:length(PROBLEM.Electrode.delete_electrodes)
    idx_se=inpoly([MESH.Nodes(node_idx,1),MESH.Nodes(node_idx,2)],PROBLEM.Electrode.delete_electrodes{i});
    idx_e(idx_se)=true;
end
% if any electrode crosses/touch the "delete_electrodes" region - delete
% given electrode
idx_e=any(reshape(idx_e,NE_nodes,[]));
node_idx(:,idx_e)=[];

% umìle pøidat
node_idx=[83 87 95 101 109;
    599 598 597 596 595;
    100 110 117 126 133]';

% number of electrodes
LOAD.Electrodes.nelements=size(node_idx,2);

% get the measurement nodes
LOAD.Electrodes.m_nodes=~full(sparse(node_idx,repmat(1:size(node_idx,2),size(node_idx,1),1),true,MESH.nnodes,LOAD.Electrodes.nelements));
% get just the boundary nodes to participate (delete the interior nodes)
LOAD.Electrodes.m_nodes(MESH.int_nodes,:)=false;

% delete measurement nodes on chosen edges (loop over defined edges)
for i=1:length(PROBLEM.Electrode.delete_measurements)
    idx_m=inpoly(MESH.Nodes,PROBLEM.Electrode.delete_measurements{i});
    LOAD.Electrodes.m_nodes(idx_m,:)=false;
end

% save electrode points
LOAD.Electrodes.e_points = cell(LOAD.Electrodes.nelements,1);
for i=1:LOAD.Electrodes.nelements
    LOAD.Electrodes.e_points{i}=MESH.Nodes(node_idx(:,i),:); %[MESH.Nodes(LOAD.Electrodes.Elements(i,1),:);MESH.Nodes(LOAD.Electrodes.Elements(i,2),:)];
end
% save measurement points
LOAD.Electrodes.m_points = cell(LOAD.Electrodes.nelements,1);
for i=1:LOAD.Electrodes.nelements
    LOAD.Electrodes.m_points{i}=MESH.Nodes(LOAD.Electrodes.m_nodes(:,i),:);
end

nc=MESH.Nodes(MESH.Boundary.Elements(:,1),:);
LOAD.Electrodes.e_idx=false(MESH.Boundary.nelements,LOAD.Electrodes.nelements);
for i=1:LOAD.Electrodes.nelements
    % get logical array of (electrode) nodes on boundary
    node_map=inpoly(nc,LOAD.Electrodes.e_points{i});
    LOAD.Boundary.Nodes{i}=MESH.Boundary.Elements(node_map,1);
    % Node indexes (in boundary nodes) of electrodes for each active electrode
    LOAD.Electrodes.e_idx(:,i) = all(ismember(MESH.Boundary.R_s(2:3,:)',LOAD.Boundary.Nodes{i}'),2);
end


% Plot the electrode scheme
GTM_PlotBasics(MESH,PROBLEM,LOAD,[],[],-3)
































% % delete electrode elements on chosen edges (loop over defined edges)
% idx_e=false(size(LOAD.Electrodes.Elements,1),1);
% for i=1:length(PROBLEM.Electrode.delete_electrodes)
%     idx_se=inpoly([MESH.Nodes((LOAD.Electrodes.Elements(:,1)),1),MESH.Nodes((LOAD.Electrodes.Elements(:,1)),2)],PROBLEM.Electrode.delete_electrodes{i});
%     idx_e(idx_se)=true;
% end
% LOAD.Electrodes.Elements(idx_e,:)=[];
% % number of electrodes
% LOAD.Electrodes.nelements=size(LOAD.Electrodes.Elements,1);
% 
% % get the measurement nodes
% LOAD.Electrodes.m_nodes=~full(sparse(LOAD.Electrodes.Elements(:,1:2),repmat(1:LOAD.Electrodes.nelements,2,1)',true,MESH.nnodes,LOAD.Electrodes.nelements));
% % get just the boundary nodes to participate (delete the interior nodes)
% LOAD.Electrodes.m_nodes(MESH.int_nodes,:)=false;
% 
% % delete measurement nodes on chosen edges (loop over defined edges)
% for i=1:length(PROBLEM.Electrode.delete_measurements)
%     idx_m=inpoly(MESH.Nodes,PROBLEM.Electrode.delete_measurements{i});
%     LOAD.Electrodes.m_nodes(idx_m,:)=false;
% end
% 
% % save electrode points
% LOAD.Electrodes.e_points = cell(LOAD.Electrodes.nelements,1);
% for i=1:LOAD.Electrodes.nelements
%     LOAD.Electrodes.e_points{i}=[MESH.Nodes(LOAD.Electrodes.Elements(i,1),:);MESH.Nodes(LOAD.Electrodes.Elements(i,2),:)];
% end
% % save measurement points
% LOAD.Electrodes.m_points = cell(LOAD.Electrodes.nelements,1);
% for i=1:LOAD.Electrodes.nelements
%     LOAD.Electrodes.m_points{i}=MESH.Nodes(LOAD.Electrodes.m_nodes(:,i),:);
% end
% 
% % Plot the electrode scheme
% GTM_PlotBasics(MESH,PROBLEM,LOAD,[],[],-2)










