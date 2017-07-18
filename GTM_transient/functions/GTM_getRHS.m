function [LOAD,eval_time]=GTM_getRHS(MESH,PROBLEM,LOAD)

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
% each column of RHS vector represents a different time step
iT=1:PROBLEM.TimeSettings.nT+1;
nT=PROBLEM.TimeSettings.nT+1;

% predefine the arrays
LOAD.RHS_t=zeros(MESH.nnodes,nT);
LOAD.RHS_d=zeros(MESH.nnodes,nT);
LOAD.RHS_f=zeros(MESH.nnodes,nT);
LOAD.RESP_d=zeros(MESH.nnodes,nT);

% get the transfer rhs
if LOAD.Boundary.Transfer.N_b>0
    r_t=cell2mat(LOAD.Boundary.Transfer.Elements');
    r_t=[repmat(r_t(:,1),1,nT),repmat(r_t(:,2),1,nT)];
    v_t=repmat(cell2mat(LOAD.Boundary.Transfer.Value'),1,2);
    LOAD.RHS_t=full(sparse(r_t,repmat(iT,size(r_t,1),2),v_t/2,MESH.nnodes,nT));
end

% get the flux rhs
if LOAD.Boundary.Flux.N_b>0
    r_f=cell2mat(LOAD.Boundary.Flux.Elements');
    r_f=[repmat(r_f(:,1),1,nT),repmat(r_f(:,2),1,nT)];
    v_f=repmat(cell2mat(LOAD.Boundary.Flux.Value'),1,2);
    LOAD.RHS_f=full(sparse(r_f,repmat(iT,size(r_f,1),2),v_f/2,MESH.nnodes,nT));
end

% get the "dirichlet rhs"
if LOAD.Boundary.Dirichlet.N_b>0
    r_d=repmat(cell2mat(LOAD.Boundary.Dirichlet.Nodes'),1,nT);
    v_d=cell2mat(LOAD.Boundary.Dirichlet.Value');
    % Dirichlet part of the system response
    LOAD.RESP_d = full(sparse(r_d,repmat(iT,size(r_d,1),1),v_d,MESH.nnodes,nT));
    LOAD.Boundary.Dirichlet.idx=~logical(full(sparse(r_d(:,1),1,1,MESH.nnodes,1)));
else
    LOAD.Boundary.Dirichlet.idx=true(MESH.nnodes,1);
end






% get the evaluation time
eval_time=toc;


















