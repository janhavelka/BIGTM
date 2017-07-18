function J = CHM_getJacobian2(MESH,LOAD,MATERIAL)



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




% get current conductivity field and calculate the sensitivity of each
% measurement to each element conductivity
J=zeros(nnz(LOAD.Electrodes.m_nodes),MESH.nelements);
for ielem=1:MESH.nelements
    % add a negligible value to i-th element conductivity field
    sigma_d=MATERIAL.sigma;
    sigma_d(ielem)=sigma_d(ielem)+delta_sigma;
    % setup global stiffness matrix
    new_resp=zeros(MESH.nnodes,LOAD.Electrodes.nelements);
    K_u=sparse(MESH.R_s,MESH.C_s,MESH.B_c.*sigma_d(:,ones(1,9))');
    for i=1:LOAD.Electrodes.nelements
        new_resp(:,i)=(K_u+LOAD.K_t{i}+LOAD.K_e{i})\(LOAD.RHS_e{i}+LOAD.RHS_t{i});
    end
    J(:,ielem)=reshape((new_resp(LOAD.Electrodes.m_nodes)-ref_resp)/delta_sigma,[],1);
end














