function [LOAD,eval_time]=GTM_getAugment(MESH,PROBLEM,LOAD)

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
% NEED TO FIX DIFFERENT TRANSFER CODENUMBERS FOR EACH LOADING
% NEED TO FIX WRONG STIFFNESS MATRIX FOR ELECTRODES (OVERLAPS)

r_t=cell(1,LOAD.Boundary.Transfer.N_b);
c_t=cell(1,LOAD.Boundary.Transfer.N_b);
v_t=cell(1,LOAD.Boundary.Transfer.N_b);
for i=1:LOAD.Boundary.Transfer.N_b-2
    r_t{i}=MESH.Boundary.R_s(:,LOAD.Boundary.Transfer.idx{i});
    c_t{i}=MESH.Boundary.C_s(:,LOAD.Boundary.Transfer.idx{i});
    v_t{i}=MESH.Boundary.G_c(:,LOAD.Boundary.Transfer.idx{i})*PROBLEM.LoadDef.BC{i,4};
end
LOAD.K_t=sparse(cell2mat(r_t),cell2mat(c_t),cell2mat(v_t),MESH.nnodes,MESH.nnodes);




% get the evaluation time
eval_time=toc;

