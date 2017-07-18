function [LOAD,eval_time] = GTM_getRegular(MESH,PROBLEM,LOAD)

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
% FOR ELEMENTS
nanidx=isnan(MESH.EC');

r=repmat(1:MESH.nelements,3,1);
c=MESH.EC';                 c(nanidx)=r(nanidx);
v=-ones(3,MESH.nelements);  v(nanidx)=0;
LOAD.R=sparse(r,c,v)-sparse(diag(sum(v)));

% FOR NODES
% for i=1:MESH.nnodes
%    LOAD.R=LOAD.R+sparse(i*ones(length(MESH.VN{i}),1),MESH.VN{i},-ones(length(MESH.VN{i}),1),MESH.nelements,MESH.nelements); 
% end
% LOAD.R=LOAD.R+spdiag(sum(LOAD.R));



% get the evaluation time
eval_time=toc;

















