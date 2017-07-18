function LOAD = GTM_getMeasurementErrors(MESH,PROBLEM,LOAD)

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



% number of measurement nodes
n_nodes = numel(LOAD.M_o);

% mean vector
mu_vect=ones(sum(n_nodes),1).*PROBLEM.Error.vars(1);
% sigma vector
sigma_vect=ones(sum(n_nodes),1).*PROBLEM.Error.vars(2);

% get Error Matrix (EM)
if strncmpi(PROBLEM.Error.sampling,'montecarlo',6)
    EM=mvnrnd(mu_vect,diag(sigma_vect.^2),PROBLEM.Error.N_s);
elseif strncmpi(PROBLEM.Error.sampling,'lhs',3)
    EM=lhsnorm(mu_vect,diag(sigma_vect.^2),PROBLEM.Error.N_s);
end

% Measurement errors
% LOAD.Error=mat2cell(EM',n_nodes',PROBLEM.Error.N_s);
LOAD.Error=EM';

















% % number of measurement nodes
% n_nodes = sum(LOAD.Electrodes.m_nodes);
% % number of thermocouples
% n_therm = LOAD.Electrodes.N_e;
% 
% 
% % mean vector
% mu_vect=[ones(n_therm,1).*PROBLEM.Error.Electrode.vars_t(1);...
%     ones(n_therm,1).*PROBLEM.Error.Electrode.vars_r(1);...
%     ones(sum(n_nodes),1).*PROBLEM.Error.Measurement.vars(1)];
% % sigma vector
% sigma_vect=[ones(n_therm,1).*PROBLEM.Error.Electrode.vars_t(2);...
%     ones(n_therm,1).*PROBLEM.Error.Electrode.vars_r(2);...
%     ones(sum(n_nodes),1).*PROBLEM.Error.Measurement.vars(2)];
% 
% % get Error Matrix (EM)
% if strncmpi(PROBLEM.Error.Method,'montecarlo',6)
%     EM=mvnrnd(mu_vect,diag(sigma_vect.^2),PROBLEM.Error.N_s);
% elseif strncmpi(PROBLEM.Error.Method,'lhs',3)
%     EM=lhsnorm(mu_vect,diag(sigma_vect.^2),PROBLEM.Error.N_s);
% end
% 
% Error_samples=mat2cell(EM',[n_therm;n_therm;n_nodes'],PROBLEM.Error.N_s);
% 
% % electrode errors
% LOAD.Error.electrodes = Error_samples(1:2);
% % LOAD.Error.resistances = Error_samples{2};
% % measurement errors
% LOAD.Error.measure = Error_samples(3:(2+length(n_nodes)));
% % environmental errors
% LOAD.Error.environment = Error_samples((2+length(n_nodes)):end);
% 
% 
% 
