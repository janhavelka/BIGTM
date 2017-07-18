function LOAD=GTM_getAugment(MESH,PROBLEM,LOAD)
% NEED TO FIX DIFFERENT TRANSFER CODENUMBERS FOR EACH LOADING
% NEED TO FIX WRONG STIFFNESS MATRIX FOR ELECTRODES (OVERLAPS)

% get the full matrix \int_{\diff\Omega} 1/z*\phi_i\phi_j d\Omega

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


% get the transfer stiffness matrix for electrodes
for i=1:LOAD.Electrodes.nelements
    % codenumbers for electrodes for real FEM mesh
    e_idx = any([ismember(MESH.Boundary.R_s(2:3,:)',LOAD.Electrodes.Elements(i,1:2),'rows'),ismember(MESH.Boundary.R_s(2:3,:)',fliplr(LOAD.Electrodes.Elements(i,1:2)),'rows')],2);
    LOAD.K_e{i}=sparse(MESH.Boundary.R_s(:,e_idx),MESH.Boundary.C_s(:,e_idx),MESH.Boundary.G_c(:,e_idx)/PROBLEM.Electrode.Im,MESH.nnodes,MESH.nnodes);
end

% get the transfer stiffness matrix for environmental factors
r_t=cell(1,LOAD.Boundary.N_b);
c_t=cell(1,LOAD.Boundary.N_b);
v_t=cell(1,LOAD.Boundary.N_b);
for i=1:LOAD.Boundary.N_b
    r_t{i}=MESH.Boundary.R_s(:,LOAD.Boundary.t_idx{i});
    c_t{i}=MESH.Boundary.C_s(:,LOAD.Boundary.t_idx{i});
    v_t{i}=MESH.Boundary.G_c(:,LOAD.Boundary.t_idx{i})*PROBLEM.LoadDef.BC{i,4};
end
r=cell2mat(r_t);
c=cell2mat(c_t);
v=cell2mat(v_t);
% delete the environmental factors underneath the electrodes
for i=1:LOAD.Electrodes.nelements
    % find particular electrode element on a boundary
    e_idx=~any([ismember(c(1:2,:)',LOAD.Electrodes.Elements(i,1:2),'rows'),ismember(c(1:2,:)',fliplr(LOAD.Electrodes.Elements(i,1:2)),'rows')],2);
    r_te=r(:,e_idx);
    c_te=c(:,e_idx);
    v_te=v(:,e_idx);
    LOAD.K_t{i}=sparse(r_te,c_te,v_te,MESH.nnodes,MESH.nnodes);
end