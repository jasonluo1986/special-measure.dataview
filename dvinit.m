function dvinit
% dvinit
% initialise dvdata

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


clear global dvdata;

global dvdata;


dvdata.cache = cell(0);
dvdata.collections = cell(0);

%warning('off', 'MATLAB:warn_r14_stucture_assignment');
