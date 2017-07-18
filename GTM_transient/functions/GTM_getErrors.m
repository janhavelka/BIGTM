function [MATERIAL,err]=GTM_getErrors(MESH,LOAD,MATERIAL,MDATA,iter)

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


% calc the difference of measurement and the change of material parameter
err_measure     = norm(reshape(LOAD.M_c,[],1)-reshape(LOAD.M_o,[],1),'fro')/norm(LOAD.M_o,'fro');

% error on sigma field
err_sigma       = norm(MDATA.MATERIAL.sigma_true_fine-MATERIAL.sigma_comp{end},'fro')/norm(MDATA.MATERIAL.sigma_true_fine,'fro');
% error on capacity field
err_capacity    = norm(MDATA.MATERIAL.cv_true_fine-MATERIAL.cv_comp{end},'fro')/norm(MDATA.MATERIAL.cv_true_fine,'fro');

% difference on sigma field
diff_sigma      = norm(MATERIAL.sigma_comp{end}-MATERIAL.sigma_comp{end-1},'fro')/norm(MATERIAL.sigma_comp{end},'fro');
% difference on capacity field
diff_capacity   = norm(MATERIAL.cv_comp{end}-MATERIAL.cv_comp{end-1},'fro')/norm(MATERIAL.cv_comp{end},'fro');

% overall errors
err_material    = (err_sigma>err_capacity)*err_sigma+(err_sigma<err_capacity)*err_capacity;
% pick the higher of errors
err             = (err_measure>err_material)*err_measure+(err_measure<err_material)*err_material;

% write info
MATERIAL.Stats.err_measure(iter)    = err_measure;
MATERIAL.Stats.diff_capacity(iter)  = diff_capacity;
MATERIAL.Stats.diff_sigma(iter)     = diff_sigma;
MATERIAL.Stats.err_capacity(iter)   = err_capacity;
MATERIAL.Stats.err_sigma(iter)      = err_sigma;






