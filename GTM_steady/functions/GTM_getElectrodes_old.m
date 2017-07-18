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


% limit the number of possible electrodes
if PROBLEM.Electrode.N_e>MESH.Boundary.nelements/2
    LOAD.Electrodes.N_e=round(MESH.Boundary.nelements/2);
    disp(['The maximum possible number of electrodes (' num2str(round(MESH.Boundary.nelements/2)) ') was exceeded'])
else
    LOAD.Electrodes.N_e=PROBLEM.Electrode.N_e;
end
% pick the edges (the actual electrodes) to fit the number of wanted number of electrodes the best
LOAD.Electrodes.Elements=MESH.Boundary.Elements(1:round(MESH.Boundary.nelements/LOAD.Electrodes.N_e):end,:);




% delete electrode elements on chosen edges (loop over defined edges)
idx_e=false(size(LOAD.Electrodes.Elements,1),1);
for i=1:length(PROBLEM.Electrode.delete_electrodes)
    idx_se=inpoly([MESH.Nodes((LOAD.Electrodes.Elements(:,1)),1),MESH.Nodes((LOAD.Electrodes.Elements(:,1)),2)],PROBLEM.Electrode.delete_electrodes{i});
    idx_e(idx_se)=true;
end
LOAD.Electrodes.Elements(idx_e,:)=[];
% number of electrodes
LOAD.Electrodes.nelements=size(LOAD.Electrodes.Elements,1);

% get the measurement nodes
LOAD.Electrodes.m_nodes=~full(sparse(LOAD.Electrodes.Elements(:,1:2),repmat(1:LOAD.Electrodes.nelements,2,1)',true,MESH.nnodes,LOAD.Electrodes.nelements));
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
    LOAD.Electrodes.e_points{i}=[MESH.Nodes(LOAD.Electrodes.Elements(i,1),:);MESH.Nodes(LOAD.Electrodes.Elements(i,2),:)];
end
% save measurement points
LOAD.Electrodes.m_points = cell(LOAD.Electrodes.nelements,1);
for i=1:LOAD.Electrodes.nelements
    LOAD.Electrodes.m_points{i}=MESH.Nodes(LOAD.Electrodes.m_nodes(:,i),:);
end

% Plot the electrode scheme
GTM_PlotBasics(MESH,PROBLEM,LOAD,[],[],-2)

































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










