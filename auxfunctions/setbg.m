function setbg(col, datasets, bg, ctrl, pos, varargin)
% setbg(ctrl, col, datasets, bg, ctrl, pos, varargin)
% ctrl: mean, pulses - still ignored. Also passed to filter function.
% 

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.

global dvdata;

if nargin < 4
    ctrl = '';
end
if nargin < 5
    pos = length(dvdata.collections{col}.datasets)+1;
end

for i = 1:length(datasets)
    dvinsert([datasets(i), bg(min(i, end))]-(pos+i-1), col, pos+i-1);
    %dvinsert([datasets(i), bg(min(i, end))], col, pos+i-1);
    dvdata.collections{col}.datasets(pos+i-1).graphobjs = ...
    dvdata.collections{col}.datasets(datasets(i)).graphobjs; 
    dvdata.collections{col}.datasets(pos+i-1).flags = ...
    dvdata.collections{col}.datasets(datasets(i)).flags; 
end
dvdisplay(col, pos+(0:i-1), 'recurse');
if  i > 1
    dvdisplay(col, pos+(1:i-1), 'prevax');
end
dvfilter(col, pos+(0:i-1), @dvfbg1, 'comb', ctrl);


