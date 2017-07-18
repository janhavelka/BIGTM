function [MATERIAL,eval_time] = GTM_updateMaterial(PROBLEM,LOAD,MATERIAL,J)

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
% get the regularisation matrix
G=LOAD.R'*LOAD.R;
% G=eye(size(J,2));



% a=max(diag(J{1}'*J{1}))*min(diag(J{1}'*J{1}));
% b=max(diag(J{2}'*J{2}))*min(diag(J{2}'*J{2}));


PROBLEM.Solver.lambda_s=max(max(J{1}'*J{1}))/2;
PROBLEM.Solver.lambda_c=max(max(J{2}'*J{2}))/2;

%% conductivity update
% calculate the conducivity change
delta_sigma=(J{1}'*J{1}+PROBLEM.Solver.lambda_s*G)\(J{1}'*(LOAD.M_o(:)-LOAD.M_c(:))-PROBLEM.Solver.lambda_s*G*(-MATERIAL.sigma_comp{1}+MATERIAL.sigma_comp{end}));
% delta_sigma=delta_sigma/2;
% edit the amplitude of change
% k=0.3;
k=0.5;
delta_sigma(abs(delta_sigma)>k)=sign(delta_sigma(abs(delta_sigma)>k))*k;

% update the true conductivity
sigma = MATERIAL.sigma_comp{end}+delta_sigma;
% avoid negative conductivities
sigma(sigma<=0)=mean(sigma(sigma>=0));

% save the history of conductivities
MATERIAL.sigma_comp{end+1}=sigma;


%% Capacity update
% calculate the capacity change
delta_cv=(J{2}'*J{2}+PROBLEM.Solver.lambda_c*G)\(J{2}'*(LOAD.M_o(:)-LOAD.M_c(:))-PROBLEM.Solver.lambda_c*G*(-MATERIAL.cv_comp{1}+MATERIAL.cv_comp{end}));
% delta_cv=delta_cv/2;
% edit the amplitude of change
k=1e5;
delta_cv(abs(delta_cv)>k)=sign(delta_cv(abs(delta_cv)>k))*k;

% update the true capacity
cv = MATERIAL.cv_comp{end}+delta_cv/2;
% avoid negative capacity
cv(cv<=0)=mean(cv(cv>=0));

% save the history of conductivities
MATERIAL.cv_comp{end+1}=cv;











% get the evaluation time
eval_time=toc;







