function sc = loadcorr2(file, col, frames)
% sc = loadcorr2(file, col)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global dvdata;
global awgdata;

load(file, 'scan');%, 'data');

%sz = size(data{1});



dt = awgdata.xval([scan.data.pulsegroups.pulses]);
%xc = [dt dt+18 dt+36, dt+70];
xc = [dt dt+8 dt+22];

col = dvinsert(file, col);
sc = length(dvdata.collections{col}.datasets);



if nargin < 3 || isempty(frames)
    dvfilter(col, sc, @dvfcutnan);
else
    dvfilter(col, sc, @dvfselect, '', {frames});
end

dvfilter(col, sc, @mean);
dvfilter(col, sc, @permute, '', [2 3 1]);

ntim = length(dt);
npls = scan.loops(end-1).procfn.fn.args{2};

nshift = scan.loops(end-1).npoints/ntim;

dvcopy(col, sc + zeros(1, 3*nshift-1), col);

for i = 0:nshift-1
    dvfilter(col, sc+i, @dvfselect, '', { 1:npls+2, (1:ntim) + i*ntim});
    dvfilter(col, sc+nshift+i, @dvfselect, '', {1:2*npls+4, (1:ntim) + i*ntim});
    
    dvfilter(col, sc+2*nshift+i, @dvfselect, '', {[1:npls+2, 2*npls+4+(1:2*npls)], (1:ntim) + i*ntim});
end

% mean, ref subtracted
dvfilter(col, sc+(0:nshift-1), @mtimes, '', [eye(npls+1); -ones(1, npls+1)]);

% variances
dvfilter(col, sc + (nshift:2*nshift-1), @power, '', [2*ones(ntim, npls+2), ones(ntim, npls+2)])
dvfilter(col, sc + (nshift:2*nshift-1), @mtimes, '', [-eye(npls+2); eye(npls+2)])

dvfilter(col, sc+(0:2*nshift-1), @dvfpermute, 'x', dt, 2);

% correlations
dvfilter(col, sc+(2*nshift:3*nshift-1), @abs);
dvfilter(col, sc+(2*nshift:3*nshift-1), @log);
dvfilter(col, sc+(2*nshift:3*nshift-1), @mtimes, '', [ones(1, npls), zeros(1, 3*npls); ...
                                                      zeros(1, 2* npls), ones(1, npls), zeros(1, npls);...
                                                      eye(2*npls), [eye(npls), zeros(npls); zeros(npls, 2*npls)];...
                                                      zeros(npls, 3*npls), eye(npls)]);
dvfilter(col, sc+(2*nshift:3*nshift-1), @exp);
dvfilter(col, sc+(2*nshift:3*nshift-1), @mtimes, '', [[-eye(npls); eye(npls); zeros(2*npls, npls)], ...
                                                       [zeros(2*npls, npls); -eye(npls); eye(npls)]]);
dvfilter(col, sc+(2*nshift:3*nshift-1), @reshape, '', [npls*ntim, 2])


dvfilter(col, sc+(2*nshift:3*nshift-1), @dvfpermute, 'x', xc, 2);


%c1 = d(di, 13:16)-d(di, 3:6).*d(di, [1 1 1 1]);


dvdisplay(col, sc + (0:3*nshift-1), 'filename');
dvdisplay(col, sc + (0:3*nshift-1), 'xlabel', 'string', '\Deltat');

dvdisplay(col, sc + (0:3*nshift-1), 'prevax');
dvdisplay(col, sc + (0:2)*nshift, 'prevax', 0);

dvplot(col, sc+(0:3*nshift-1));

