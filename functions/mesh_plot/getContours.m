function [ XX,YY,ZZ ] = getContours( MESH, zz )
%GETCONTOURS Summary of this function goes here
%   Detailed explanation goes here

xx=linspace(min(MESH.Nodes(:,1)),max(MESH.Nodes(:,1)),50);
yy=linspace(min(MESH.Nodes(:,2)),max(MESH.Nodes(:,2)),50);
[XX,YY]=meshgrid(xx,yy);
ZZ=griddata(MESH.Nodes(:,1),MESH.Nodes(:,2),zz,XX,YY);

% idx=~inpoly([XX(:),YY(:)],[Nodes(Boundary.Elements(:,1:2),1),Nodes(Boundary.Elements(:,1:2),2)]);
idx=~inpolygon(XX,YY,MESH.Nodes(MESH.Boundary.Elements(:,1:2),1),MESH.Nodes(MESH.Boundary.Elements(:,1:2),2));
ZZ(idx)=NaN;

end

