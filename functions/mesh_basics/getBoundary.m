function Boundary = getBoundary(MESH)

DT=triangulation(MESH.Elements(:,1:3),MESH.Nodes);

% get the free boundary and number of boundary elements (edges)
Boundary.Elements=DT.freeBoundary;










% get number of elements on boundaries
Boundary.nelements=size(Boundary.Elements,1);
% calculate the length of each element on boundary - extend the matrix
Boundary.Elements(:,3)=sum((MESH.Nodes(Boundary.Elements(:,1),:)-MESH.Nodes(Boundary.Elements(:,2),:)).^2,2).^(1/2);









