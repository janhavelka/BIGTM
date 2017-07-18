function LOAD=GTM_getRHS(MESH,PROBLEM,LOAD)

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


% get the transfer rhs
row=cell2mat(LOAD.Boundary.Elements');
val=cell2mat(LOAD.Boundary.Value');
for i=1:LOAD.Electrodes.nelements
    e_elements=MESH.Boundary.R_s(2:3,LOAD.Electrodes.e_idx(:,i))';
    l_idx = ~any([ismember(row(:,1:2),e_elements,'rows'),ismember(row(:,1:2),fliplr(e_elements),'rows')],2);
    LOAD.RHS_t{i}=full(sparse(row(l_idx,1:2),1,repmat(val(l_idx),1,2)/2,MESH.nnodes,1));
end

% get the electrode transfer rhs
for i=1:LOAD.Electrodes.nelements
    v=repmat(PROBLEM.Electrode.Temp*MESH.Boundary.Elements(LOAD.Electrodes.e_idx(:,i),3)/(2*PROBLEM.Electrode.Im),1,2);
    r=MESH.Boundary.R_s(2:3,LOAD.Electrodes.e_idx(:,i));
    c=1;
%     RHS_e=zeros(MESH.nnodes,1);
%     RHS_e(LOAD.Electrodes.Elements(i,1:2))=PROBLEM.Electrode.Temp*LOAD.Electrodes.Elements(i,3)/(2*PROBLEM.Electrode.Im);
    LOAD.RHS_e{i}=full(sparse(r,c,v,MESH.nnodes,1));
end

























