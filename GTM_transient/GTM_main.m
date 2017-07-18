
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


% Calculates CHM (Electric Impedance Tomography) inverse problem using FEM

% Initiate the calculation (include folders, clear vars etc)
GTM_Initialize;

% Input_lshape;
Input_lshape_gtm_comparison;
% Input_test;
% Input_l_holes;
% Input_circle_2inclusions;
% Input_simple_wall;

% get real measurements and initial material field
MDATA = GTM_getMeasurement(PROBLEM);

% get the reconstructed field
RDATA = GTM_getReconstruction(MDATA,PROBLEM);

if PROBLEM.General.SaveMode
    save(NameSequence(PROBLEM.General.SaveName,'output',[],'.mat',[]));
end













