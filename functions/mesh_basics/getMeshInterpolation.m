function MESH_fine = getMeshInterpolation(MESH_fine,MESH_coarse)
% get the interpolation for elements and nodes between two meshes in a form
% of transpormation matrices
% In order to maintain all the data, the interpolation should be done in a
% way that coarse mesh will be projected into fine mesh.

%% FOR NODES
DT_n=triangulation(MESH_fine.Elements(:,1:3),MESH_fine.Nodes);

% triangles corresponding to coarse mesh nodes
ti = pointLocation(DT_n,MESH_coarse.Nodes(:,1:2));
% triangle nodes
ti_nodes=MESH_fine.Elements(ti,1:3);

dX=reshape(MESH_fine.Nodes(ti_nodes,1),MESH_coarse.nnodes,[])-repmat(MESH_coarse.Nodes(:,1),1,3);
dY=reshape(MESH_fine.Nodes(ti_nodes,2),MESH_coarse.nnodes,[])-repmat(MESH_coarse.Nodes(:,2),1,3);

% inverse distance between points
d=1./((dX.^2+dY.^2).^(1/2));
% normalized distance
nd=d./repmat(sum(d,2),1,3);
% replace NaNs with ones
nd(isnan(nd))=1;

MESH_fine.NTN=sparse(repmat([1:MESH_coarse.nnodes]',1,3),ti_nodes,nd,MESH_coarse.nnodes,MESH_fine.nnodes);

%% FOR ELEMENTS
DT_e=delaunayTriangulation(MESH_fine.Elements(:,5:6));

% triangles corresponding to coarse mesh nodes
ei = pointLocation(DT_e,MESH_coarse.Elements(:,5:6));
% triangle nodes
ei_nodes=DT_e.ConnectivityList(ei,1:3);

dX=reshape(MESH_fine.Elements(ei_nodes,5),MESH_coarse.nelements,[])-repmat(MESH_coarse.Elements(:,5),1,3);
dY=reshape(MESH_fine.Elements(ei_nodes,6),MESH_coarse.nelements,[])-repmat(MESH_coarse.Elements(:,6),1,3);

% inverse distance between points
d=1./((dX.^2+dY.^2).^(1/2));
% normalized distance
nd=d./repmat(sum(d,2),1,3);
% replace NaNs with ones
nd(isnan(nd))=1;

MESH_fine.ETE=sparse(repmat([1:MESH_coarse.nelements]',1,3),ei_nodes,nd,MESH_coarse.nelements,MESH_fine.nelements);









