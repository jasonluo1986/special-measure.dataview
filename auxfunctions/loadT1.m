function sc = loadT1(file, col, bg, frames, ctrl)
%  sc = loadT1(file, col, bg, ctrl)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.

global dvdata;
global awgdata;

if nargin < 5
    ctrl = '';
end

if nargin < 3
    bg = 0;
end

load(file, 'data', 'scan');

%data = data{1};
sz = size(data{1});
if length(sz) == 3
    sz = [sz(1:2), 1, sz(3)];
end

if strfind(ctrl, 'norep')
    nrep = 1;
else
    nrep = sum([scan.data.pulsegroups.seqind] == scan.data.pulsegroups(1).seqind);
end
ngrp = length(scan.data.pulsegroups)/nrep;

tau = awgdata.xval([scan.data.pulsegroups(1:ngrp).pulses]); 
tau = tau(1:scan.loops(1).npoints);
% assuming repeating sequence of groups

%sz2 = [sz(1)* sz(2)/ngrp, sz(3)*ngrp, sz(4)];

nshift = sz(2)/(ngrp*nrep);


col = dvinsert(file, col);
sc = length(dvdata.collections{col}.datasets);

dvcopy(col, repmat(sc, 1, 1+nshift), col);

% data matrix indices: outer rep, (shift(slow) * inner rep * grp(fast)), pls, time
% mean, permute ->  (shift *  inner rep * grp), outer rep, pls
% reshape ->  grp, inner rep,  shift, outer rep, pls 
% permute ->  inner rep,  outer rep, pls, grp, shift 
dvfilter(col, sc+(0:1), @mean, '', 4);
dvfilter(col, sc+(0:1), @permute, '', [2 1 3]);
dvfilter(col, sc+(0:1), @reshape, '', [ngrp, nrep, nshift, sz([1 3])]);
dvfilter(col, sc+(0:1), @permute, '', [2 4 5 1 3]);

%   for color plot: reshape ->  rep, grp * pls * shift
dvfilter(col, sc, @reshape, '', [nrep*sz(1), ngrp*sz(3)* nshift]);
dvfilter(col, sc, @dvfpermute, 'y', (1:nrep*sz(1))', 2);
dvfilter(col, sc, @dvfpermute, 'x', [1 ngrp*sz(3)* nshift]', 2);
if nargin < 4 || isempty(frames)
    dvfilter(col, sc, @dvfcutnan, 'all');
else
    dvfilter(col, sc, @dvfselect, '', {frames});
    dvfilter(col, sc, @dvfselect, 'y', {frames});
end

% for line plots: reshape ->  rep,  pls, grp,  shift
% mean, permute -> 
% mean, permute -> pls, grp, shift
% reshape: pls * grp, shift
dvfilter(col, sc+1, @reshape, '', [nrep*sz(1), ngrp*sz(3),  nshift]);
if nargin < 4 || isempty(frames)
    dvfilter(col, sc+1, @dvfcutnan);
else
    dvfilter(col, sc+1, @dvfselect, '', {frames});
end
dvfilter(col, sc+1, @mean, '', 1);
dvfilter(col, sc+1, @permute, '', [3 2 1]);
dvfilter(col, sc+1, @dvfpermute, 'x', tau', 2);


% time dependence
% data matrix indices: outer rep, (shift(slow) * inner rep * grp(fast)), pls, time
% permute ->  (shift *  inner rep * grp), outer rep, pls, time
% reshape ->  grp, inner rep,  shift, outer rep, pls, time, 
% permute ->  inner rep,  outer rep, pls, grp, time, shift 
% reshape ->  rep, grp * pls, time, shift

dvfilter(col, sc+1+(1:nshift), @permute, '', [2 1 3 4]);
dvfilter(col, sc+1+(1:nshift), @reshape, '', [ngrp, nrep, nshift, sz([1 3 4])]);

for i = 1:nshift
    if bg == 0 || i == bg
        dvfilter(col, sc+1+i, @dvfselect, '', {':', ':', ':', i, ':', ':'});
    else
        dvfilter(col, sc+1+i, @dvfselect, '', {':', ':', ':', [bg i], ':', ':'});
        dvfilter(col, sc+1+i, @diff, '', [], 3);
    end
end

dvfilter(col, sc+1+(1:nshift), @permute, '', [2 4 5 1 6 3]);
dvfilter(col, sc+1+(1:nshift), @reshape, '', nrep*sz(1), ngrp*sz(3), sz(4));

if nargin < 4 || isempty(frames)
    dvfilter(col, sc+1+(1:nshift), @dvfcutnan);
else
    dvfilter(col, sc+1+(1:nshift), @dvfselect, '', {frames});
end

dvfilter(col, sc+1+(1:nshift), @mean, '', 1);
dvfilter(col, sc+1+(1:nshift), @permute, '', [2 3 1]);

% dvfilter(col, sc+1+(1:nshift), @permute, '', [2 4 5 1 6 3]);
% dvfilter(col, sc+1+(1:nshift), @reshape, '', nrep*sz(1), ngrp*sz(3), sz(4), nshift);
% dvfilter(col, sc+1+(1:nshift), @mean, '', 1);
% dvfilter(col, sc+1+(1:nshift), @permute, '', [2 3 4 1]);


if isfield(scan.data, 'samprate')
    x = (1:sz(4))/scan.data.samprate * 1e6;
else
    x = linspace(0, 10, sz(4));
end
dvfilter(col, sc+1+(1:nshift), @dvfpermute, 'x', x', 2);




dvdisplay(col, sc, 'color');
dvdisplay(col, sc+1, 'data', 'Marker', '.');


dvdisplay(col, sc+(0:nshift+1), 'filename');
dvdisplay(col, sc+1+(1:nshift), 'xlabel', 'string', 't (\mus)');
dvdisplay(col, sc+1, 'xlabel', 'string', 'x_{pls}');

dvdisplay(col, sc, 'axes', 'ydir', 'reverse');
dvdisplay(col, sc, 'ylabel', 'string', 'sweep #');

dvplot(col, sc+(0:nshift+1));


