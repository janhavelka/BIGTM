function MATERIAL = GTM_updateMaterial(PROBLEM,LOAD,MATERIAL,J)

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


% R=eye(size(J,2));
G=LOAD.R'*LOAD.R;

% G=eye(size(J,2));

PROBLEM.Solver.lambda=max(max((J'*J)));
% a=PROBLEM.Solver.lambda;

% MATERIAL.sigma=MATERIAL.sigma+(J'*J+PROBLEM.Solver.lambda*G)\(J'*(LOAD.M_m(:)-LOAD.M_cm(:))-PROBLEM.Solver.lambda*G*MATERIAL.sigma);
% calculate the conducivity change
% delta_sigma=(J'*J+PROBLEM.Solver.lambda*G)\(J'*(LOAD.M_m(:)-LOAD.M_cm(:))-PROBLEM.Solver.lambda*G*MATERIAL.sigma);
delta_sigma=(J'*J+PROBLEM.Solver.lambda*G)\(J'*(LOAD.M_m(:)-LOAD.M_cm(:))+PROBLEM.Solver.lambda*G*(MATERIAL.sigma_comp(:,1)-MATERIAL.sigma));
% edit the amplitude of change
k=5;
delta_sigma(abs(delta_sigma)>k)=sign(delta_sigma(abs(delta_sigma)>k))*k;
% update thetrue conductivity
MATERIAL.sigma=MATERIAL.sigma+delta_sigma;

% avoid negative conductivities
MATERIAL.sigma(MATERIAL.sigma<=0)=mean(MATERIAL.sigma(MATERIAL.sigma>=0));

% save the history of conductivities
MATERIAL.sigma_comp=[MATERIAL.sigma_comp,MATERIAL.sigma];











