function sc = loadspect2(file, col, ctrl, ind)
% sc = loadspect2(file, col, ctrl, ind)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global dvdata;

if nargin < 3
    ctrl = '';
end

load(file, 'scan', 'data');

ch = length(scan.loops.procfn);
sz = size(data{ch});

col = dvinsert(file, col, [], ch);
sc = length(dvdata.collections{col}.datasets);

%dt = (1+(sz(1)>1))./scan.data.samprate;
dt = sz(1)./(3 * scan.data.samprate);
freq = (2:sz(2)-1)./(2 * sz(2) * dt);

if strfind(ctrl, 'amp')
    scl = 4; 
else
    scl = dt*sz(2)*64/3; % changed from 32/3 on 03/31/10
    % factor 32: 8 (for window) * 2^2 (for nsamples = 2 * sz(2)) * 2 for integrating over +ve freq only
end

if nargin < 4
    ind = 1:sz(1)/3;
end

dvfilter(col, sc, @dvfpermute, 'x', freq, 2);
dvfilter(col, sc, @dvfselect, '', {3:sz(2), ind});
dvfilter(col, sc, @scale, '',  scl);

yr = [.7*scl*min(min(data{ch}(:, 3:end))), 1.3*scl*max(max(data{ch}(:, 3:end)))];

if 0 %&& ~isempty(strfind(ctrl, 'amp')) || isempty(strfind(ctrl, 'lin'))
    dvfilter(col, sc, @sqrt, '');
    yr = sqrt(yr);
end
   
dvcopy(col, [sc sc], col);
dvfilter(col, sc+1, @dvfselect, 'chg', {3:sz(2), ind+sz(1)/3});
dvfilter(col, sc+2, @dvfselect, 'chg', {3:sz(2), ind+sz(1)*2/3});

if strfind(ctrl, 'log')
    dvdisplay(col, sc, 'axes', 'xscale', 'log', 'yscale', 'log', 'xlim', [.9*freq(1), 1.1*freq(end)], ...
        'ylim', yr);
else
    dvdisplay(col, sc, 'axes', 'xscale', 'log', 'xlim', [.9*freq(1), 1.1*freq(end)], ...
        'ylim', [min(0, yr(1)), yr(2)]);
end

if strfind(ctrl, 'amp')
    dvdisplay(col, sc, 'ylabel', 'string', 'amplitude');
elseif 1 %strfind(ctrl, 'lin')
    dvdisplay(col, sc, 'ylabel', 'string', 'S (V^2/Hz)');
else
    dvdisplay(col, sc, 'ylabel', 'string', 'S^{1/2} (V/Hz^{1/2})');
end

    
dvdisplay(col, sc, 'filename');
dvdisplay(col, sc, 'xlabel', 'string', 'f (Hz)');

dvdisplay(col, sc+(1:2), 'prevax');

if strfind(ctrl, 'diff')
    dvcopy(col, sc, col);
    coeff  = [eye(length(ind)); -2*eye(length(ind))];
    coeff(ind==1, :) = coeff(ind==1, :)+1;
    dvfilter(col, sc+3, @dvfselect, 'chg', {3:sz(2), [ind ind+sz(1)/3]});

    dvfilter(col, sc+3, @transpose);
    dvfilter(col, sc+3, @mtimes, '', coeff);
    dvfilter(col, sc+3, @transpose);

    dvdisplay(col, sc+3, 'prevax');
    dvplot(col, sc+(0:3));

else
    dvplot(col, sc+(0:2));
end
