function MATERIAL = GTM_solveProblem(MESH,PROBLEM,LOAD,MDATA)

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


err         = inf;
iter        = 1;
fig_handles = [];

% initialize stats arrays
MATERIAL.Stats.err_measure = NaN*ones(PROBLEM.Solver.NoI,1);
MATERIAL.Stats.err_sigma   = NaN*ones(PROBLEM.Solver.NoI,1);
MATERIAL.Stats.diff_sigma  = NaN*ones(PROBLEM.Solver.NoI,1);

% initial material field
MATERIAL.sigma             = ones(MESH.nelements,1);
MATERIAL.sigma_comp        = ones(MESH.nelements,2);

tic
while err>PROBLEM.Solver.Accuracy && iter<=PROBLEM.Solver.NoI
    % get forward solution
    [LOAD.M_cm,LOAD.M_cf]  = GTM_getForward(MESH,LOAD,MATERIAL.sigma);
    % get Jacobian
    J                      = GTM_getJacobian(MESH,LOAD,MATERIAL);
    % plot results
    fig_handles            = GTM_PlotBasics(MESH,PROBLEM,LOAD,MATERIAL,MDATA,3,fig_handles);
    % update material
    MATERIAL               = GTM_updateMaterial(PROBLEM,LOAD,MATERIAL,J);
    % get errors
    [MATERIAL,err]         = GTM_getErrors(MESH,LOAD,MATERIAL,MDATA,iter);

    iter = iter+1;
end
MATERIAL.Stats.iter        = iter;
MATERIAL.Stats.solve_time  = toc;

if PROBLEM.Video.Record
    close(getappdata(fig_handles{1},'video_file'));
    close(getappdata(fig_handles{3},'video_file'));
    close(getappdata(fig_handles{4},'video_file'));
end


