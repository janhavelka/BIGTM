function [J,eval_time] = GTM_getJacobian(MESH,PROBLEM,LOAD,MATERIAL)

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


eval_time=0;
% define delta for conductivity increment
delta_sigma=0.5;

% get current conductivity field and calculate the sensitivity of each
% measurement to each element conductivity
J_s=zeros(numel(LOAD.M_o),MESH.nelements);
% read the current conductivity (for parfor to work properly)
base_sigma=MATERIAL.sigma_comp{end};
for ielem=1:MESH.nelements
    % add a negligible value to i-th element conductivity field
    sigma_d=base_sigma;
    sigma_d(ielem)=sigma_d(ielem)+delta_sigma;
    % get the solution with a slight conductivity change
    [~,M_cd,single_time]=GTM_getForward(MESH,PROBLEM,LOAD,sigma_d);
    % get the evaluation time
    eval_time=eval_time+single_time;
    J_s(:,ielem)=reshape((M_cd-LOAD.M_c)/delta_sigma,[],1);
end



% define delta for capacity increment
delta_cv=10000;

% get current conductivity field and calculate the sensitivity of each
% measurement to each element conductivity
J_c=zeros(numel(LOAD.M_o),MESH.nelements);
% read the current conductivity (for parfor to work properly)
base_cap=MATERIAL.cv_comp{end};
for ielem=1:MESH.nelements
    % add a negligible value to i-th element conductivity field
    cap_d=base_cap;
    cap_d(ielem)=cap_d(ielem)+delta_cv;
    
    LOAD = GTM_getCapacity(MESH,PROBLEM,LOAD,cap_d);
    % get the solution with a slight conductivity change
    [~,M_cd,single_time]=GTM_getForward(MESH,PROBLEM,LOAD,base_sigma);
    % get the evaluation time
    eval_time=eval_time+single_time;
    J_c(:,ielem)=reshape((M_cd-LOAD.M_c)/delta_cv,[],1);
end


J={J_s,J_c};







