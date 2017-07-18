function [M_cm,M_cf]=GTM_getForward(MESH,LOAD,sigma)

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


RESP=zeros(MESH.nnodes,LOAD.Electrodes.nelements);
K_u=sparse(MESH.R_s,MESH.C_s,MESH.B_c.*sigma(:,ones(1,9))');
for i=1:LOAD.Electrodes.nelements
    RESP(:,i)=(K_u+LOAD.K_t{i}+LOAD.K_e{i})\(LOAD.RHS_e{i}+LOAD.RHS_t{i});
end
% separate the measurements for electrode voltages and the rest nodal voltages
M_cm=RESP(LOAD.Electrodes.m_nodes);
M_cf=RESP;

