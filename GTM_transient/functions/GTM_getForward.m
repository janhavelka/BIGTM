function [U,M,eval_time]=GTM_getForward(MESH,PROBLEM,LOAD,sigma)

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
% get the stiffness matrix
K_u = getStiffness(MESH,sigma);
K_t = LOAD.K_t;
% Get the capacity matrix
C = LOAD.C;
% get the global indexes of dirichlet nodes
g_idx=LOAD.Boundary.Dirichlet.idx;

% get the time settings
dT=PROBLEM.TimeSettings.dT;
Tau=PROBLEM.TimeSettings.Tau;

% get the dirichlet rhs
LOAD.RHS_d = -(K_u+LOAD.K_t)*LOAD.RESP_d;
% predefine the solution matrix
U=zeros(MESH.nnodes,PROBLEM.TimeSettings.nT+1);
% fill the solution with dirichlet values
U(~g_idx,:)=LOAD.RESP_d(~g_idx,:);

% get the solution
if ~PROBLEM.TimeSettings.isStationary
    for iT=2:PROBLEM.TimeSettings.nT+1
        U(g_idx,iT) = ( C(g_idx,g_idx) + dT*Tau*(K_u(g_idx,g_idx)+K_t(g_idx,g_idx) )  ) \ ...
            ( ( C(g_idx,g_idx) - (1-Tau)*dT*(K_u(g_idx,g_idx)+K_t(g_idx,g_idx)) )*U(g_idx,iT-1) + ...
            dT*( (1-Tau)*LOAD.RHS_d(g_idx,iT-1) + Tau*LOAD.RHS_d(g_idx,iT) ) + ...
            dT*( (1-Tau)*LOAD.RHS_f(g_idx,iT-1) + Tau*LOAD.RHS_f(g_idx,iT) ) + ...
            dT*( (1-Tau)*LOAD.RHS_t(g_idx,iT-1) + Tau*LOAD.RHS_t(g_idx,iT) ) ) ;
    end
else
    for iT=2:PROBLEM.TimeSettings.nT+1
        U(g_idx,iT) = ( K_u(g_idx,g_idx)+K_t(g_idx,g_idx) ) \ (...
            LOAD.RHS_d(g_idx,iT)  + ...
            LOAD.RHS_f(g_idx,iT)  + ...
            LOAD.RHS_t(g_idx,iT)  ) ;
    end
end

% select just some boundary values (actual Measurements)
M=U(LOAD.m_nodes,24:end);

% time required to evalate function
eval_time=toc;





