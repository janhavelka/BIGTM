function RESP = GTM_solveProblemErr(MESH,PROBLEM,LOAD,MDATA)

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


fig_handles  = [];
% original measurements
M_m          = LOAD.M_m;
% allocate array for response
RESP         = cell(PROBLEM.Error.N_s,1);

for i=1:PROBLEM.Error.N_s
    tic
    % add error to measurements
    LOAD.M_m = M_m+LOAD.Error(:,i);    
    err      = inf;
    iter     = 1;
    
    MATERIAL.Stats.err_measure = NaN*ones(PROBLEM.Solver.NoI,1);
    MATERIAL.Stats.err_sigma   = NaN*ones(PROBLEM.Solver.NoI,1);
    MATERIAL.Stats.diff_sigma  = NaN*ones(PROBLEM.Solver.NoI,1);
    
    % initial material field
    MATERIAL.sigma             = ones(MESH.nelements,1);
    MATERIAL.sigma_comp        = ones(MESH.nelements,1);
    
    while err>PROBLEM.Solver.Accuracy && iter<=PROBLEM.Solver.NoI
        % get forward solution
        [LOAD.M_cm,LOAD.M_cf]  = GTM_getForward(MESH,LOAD,MATERIAL.sigma);
        % get Jacobian
        J                      = GTM_getJacobian(MESH,LOAD,MATERIAL);
%         % plot results
%         fig_handles=GTM_PlotBasics(MESH,PROBLEM,LOAD,MATERIAL,MDATA,3,fig_handles);
        % update material
        MATERIAL               = GTM_updateMaterial(PROBLEM,LOAD,MATERIAL,J);
        % get errors
        [MATERIAL,err]         = GTM_getErrors(MESH,LOAD,MATERIAL,MDATA,iter);
        
        iter                   = iter+1;
    end
    % write results
    disp(i)
    RESP{i}.iter               = iter;
    RESP{i}.solve_time         = toc;
    RESP{i}.min_err_measure    = min(MATERIAL.Stats.err_measure);
    RESP{i}.min_diff_sigma     = min(MATERIAL.Stats.diff_sigma);
    RESP{i}.min_err_sigma      = min(MATERIAL.Stats.err_sigma);    
    RESP{i}.last_sigma         = MATERIAL.sigma_comp(:,end);
end

% if PROBLEM.Video.Record
%     close(getappdata(fig_handles{1},'video_file'));
%     close(getappdata(fig_handles{3},'video_file'));
%     close(getappdata(fig_handles{4},'video_file'));
% end
