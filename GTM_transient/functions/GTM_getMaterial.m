function [MATERIAL,eval_time] = GTM_getMaterial(MESH,PROBLEM)

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
% define a material conductivity, capacity and density

% variable in all directions
sigma_fun = @(x,y) 1/15.*(abs((5+3*x.^2+2*y-y.*x-5*sin(x/0.075).*y+2*cos(y/0.1).*x*5))+5);
% true_mat=@(x,y) 0.*x+1;
MATERIAL.sigma = sigma_fun(MESH.Elements(:,5),MESH.Elements(:,6));
% rho=2200;
% MATERIAL.rho=rho(ones(MESH.nelements,1));
rho_fun = @(x,y) 5.*(50.*x.^3+100.*x.^2+150.*y.^2-100.*y.*x+100.*y)+500+300.*cos(x.*y*2*pi*5)-300.*sin(x*2*pi*3);
MATERIAL.rho=rho_fun(MESH.Elements(:,5),MESH.Elements(:,6));
c=850;
MATERIAL.c=c(ones(MESH.nelements,1));

% % normal distribution in X
% sigma=0.15/1.5;
% mu=0.15;
% magnitude=10;
% true_mat=@(x,y) magnitude.*exp(-(x-mu).^2/(2*sigma^2));
% MATERIAL.sigma=true_mat(MESH.Elements(:,5),MESH.Elements(:,6));

% % normal distribution in Y
% sigma=0.5/1.5;
% mu=0.5;
% magnitude=10;
% true_mat=@(x,y) magnitude.*exp(-(y-mu).^2/(2*sigma^2));
% MATERIAL.sigma=true_mat(MESH.Elements(:,5),MESH.Elements(:,6));

% sigma_nodes=zeros(MESH.nnodes,1);
% idx=(MESH.Nodes(:,1)>0.6 & MESH.Nodes(:,1)<0.8) & (MESH.Nodes(:,2)>0.6 & MESH.Nodes(:,2)<0.8);
% sigma_nodes(idx)=20;
% sigma_nodes(~idx)=10;
% MATERIAL.sigma=MESH.NTE*sigma_nodes;


% time required to evalate function
eval_time=toc;


















