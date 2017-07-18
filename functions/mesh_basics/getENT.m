function [ MESH,eval_time ] = getENT( MESH )
tic
% Get the transformation "Elements To Nodes" - ETN and its inverse

% create consistet projection matrix "from NodesToElements"
NTE=zeros(MESH.nelements,MESH.nnodes);
% create non-consistent projection matrix "from ElementsToNodes"
ETN=zeros(MESH.nelements,MESH.nnodes);
for i=1:MESH.nelements
    % weights for "to elements" is proportional to number of elements
    NTE(i,MESH.Elements(i,1:3))=1/3;
    % divide weight proportionally to the area of element
    ETN(i,MESH.Elements(i,1:3))=MESH.Elements(i,4);
%         ETN(i,MESH.Elements(i,1:3))=1;
end
ETN=(ETN*diag(1./sum(ETN)))';

MESH.ETN=sparse(ETN);
MESH.NTE=sparse(NTE);


% time required to evalate function
eval_time=toc;