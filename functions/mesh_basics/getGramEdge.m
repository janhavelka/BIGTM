function [EDGES,eval_time] = getGramEdge( EDGES )
tic
% get gram matrix for boundary edges

% allocate GD_c for [3 x 3 x nelements] matrices of integrated shape functions
EDGES.G_c=zeros(4,EDGES.nelements);
for i=1:EDGES.nelements
    % gram matrix - (linear bases on edges)
    EDGES.G_c(:,i)=EDGES.Elements(i,3)*1/6*[2 1 1 2]';
end;

nDOFs=2;
col_mat=repmat(eye(nDOFs),nDOFs,1);
row_mat=kron(eye(nDOFs),ones(nDOFs,1));

EDGES.R_s=row_mat*EDGES.Elements(:,1:2)';
EDGES.C_s=col_mat*EDGES.Elements(:,1:2)';

% EDGES.G=sparse(EDGES.R_s,EDGES.C_s,EDGES.G_c);












% % allocate BD_c for [2 x 3 x nelements] matrices of integrated derivatives of shape funs
% EDGES.B_c=cell(EDGES.nelements,1);
% % allocate GD_c for [3 x 3 x nelements] matrices of integrated shape functions
% EDGES.G_c=cell(EDGES.nelements,1);
% for i=1:EDGES.nelements
%     % get nodes coordinates
%     x1=EDGES.Nodes(EDGES.Elements(i,1),1);        y1=EDGES.Nodes(EDGES.Elements(i,1),2);
%     x2=EDGES.Nodes(EDGES.Elements(i,2),1);        y2=EDGES.Nodes(EDGES.Elements(i,2),2);
% 
%     % integrate derivatives of basis functions (linear bases on edges)
%     EDGES.B_c{i}=[y1-y2 x2-x1]'/EDGES.Elements(i,3);
%     % gram matrix - (linear bases on edges)
%     EDGES.G_c{i}=EDGES.Elements(i,3)*1/6*[2 1 1 2]';
% end;


% time required to evalate function
eval_time=toc;