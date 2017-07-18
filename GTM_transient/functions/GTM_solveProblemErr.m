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



fig_handles     = [];

% original measurements
M_o             = LOAD.M_o(:);
% allocate array for response
RESP            = cell(PROBLEM.Error.N_s,1);

for i=1:PROBLEM.Error.N_s
    tic
    % add errors to measurements
    LOAD.M_o    = M_o+LOAD.Error(:,i);
    
    err         = inf;
    iter        = 1;
    
    % start iteration with following fields
    % conductivity field
    MATERIAL.sigma_comp = {ones(MESH.nelements,1)};
    % volumetric capacity
    MATERIAL.cv_comp    = {1e6.*ones(MESH.nelements,1)};
    
    % initialize stats array
    MATERIAL.Stats.err              = NaN*ones(PROBLEM.Solver.NoI,1);
    MATERIAL.Stats.err_sigma        = NaN*ones(PROBLEM.Solver.NoI,1);
    MATERIAL.Stats.err_capacity     = NaN*ones(PROBLEM.Solver.NoI,1);
    MATERIAL.Stats.diff_sigma       = NaN*ones(PROBLEM.Solver.NoI,1);
    MATERIAL.Stats.diff_capacity    = NaN*ones(PROBLEM.Solver.NoI,1);
    
    while err>PROBLEM.Solver.Accuracy && iter<=PROBLEM.Solver.NoI
        % get the updated capacity matrix
        LOAD                    = GTM_getCapacity(MESH,PROBLEM,LOAD,MATERIAL.cv_comp{iter});
        % get forward solution
        [LOAD.M_cfull,LOAD.M_c] = GTM_getForward(MESH,PROBLEM,LOAD,MATERIAL.sigma_comp{iter});
        % get Jacobian
        J                       = GTM_getJacobian(MESH,PROBLEM,LOAD,MATERIAL);
        %     % plot results
        %     fig_handles=GTM_PlotBasics(MESH,PROBLEM,LOAD,MATERIAL,5,MDATA,fig_handles);
        % update material
        MATERIAL                = GTM_updateMaterial(PROBLEM,LOAD,MATERIAL,J);
        % get errors
        [MATERIAL,err]          = GTM_getErrors(MESH,LOAD,MATERIAL,MDATA,iter);
        
        iter                    = iter+1;
    end
    disp(i)
    RESP{i}.iter                = iter;
    RESP{i}.solve_time          = toc;
    
    RESP{i}.min_err_measure     = min(MATERIAL.Stats.err_measure);
    RESP{i}.min_diff_sigma      = min(MATERIAL.Stats.diff_sigma);
    RESP{i}.min_diff_capacity   = min(MATERIAL.Stats.diff_capacity);
    RESP{i}.min_err_sigma       = min(MATERIAL.Stats.err_sigma);
    RESP{i}.min_err_capacity    = min(MATERIAL.Stats.err_capacity);
    RESP{i}.last_sigma          = cell2mat(MATERIAL.sigma_comp(:,end));
    RESP{i}.last_cv             = cell2mat(MATERIAL.cv_comp(:,end));
end



% if PROBLEM.Video.Record
%     close(getappdata(fig_handles{1},'video_file'));
%     close(getappdata(fig_handles{3},'video_file'));
%     close(getappdata(fig_handles{4},'video_file'));
% end
