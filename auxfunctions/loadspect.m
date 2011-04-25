function sc = loadspect(file, col, ctrl)
% sc = loadspect(file, col, ctrl)
% ctrl: amp, lin

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

dt = (1+(sz(1)>1))./scan.data.samprate;
%dt = sz(1)./(3 * scan.data.samprate);
freq = (2:sz(2)-1)./(2 * sz(2) * dt);

if strfind(ctrl, 'amp')
    scl = 4; 
else
    scl = dt*sz(2)*64/3; % changed from 32/3 on 03/31/10
    % factor 64: 8 (for window) * 2^2 (for nsamples = 2 * sz(2)) * 2 for integrating over +ve freq only
end


dvfilter(col, sc, @dvfpermute, 'x', freq, 2);
dvfilter(col, sc, @dvfselect, '', {3:sz(2), ':'});
dvfilter(col, sc, @scale, '',  scl);


yr = [.7*scl*min(min(data{ch}(:, 3:end))), 1.3*scl*max(max(data{ch}(:, 3:end)))];

if ~isempty(strfind(ctrl, 'amp')) || isempty(strfind(ctrl, 'lin'))
    dvfilter(col, sc, @sqrt, '');
    yr = sqrt(yr);
end
   
if strfind(ctrl, 'lin')
    dvdisplay(col, sc, 'axes', 'xscale', 'log', 'xlim', [.9*freq(1), 1.1*freq(end)], ...
        'ylim', [min(0, yr(1)), yr(2)]);    
else
    dvdisplay(col, sc, 'axes', 'xscale', 'log', 'yscale', 'log', 'xlim', [.9*freq(1), 1.1*freq(end)], ...
        'ylim', yr);
end

if strfind(ctrl, 'amp')
    dvdisplay(col, sc, 'ylabel', 'string', 'amplitude');
elseif strfind(ctrl, 'lin')
    dvdisplay(col, sc, 'ylabel', 'string', 'S (V^2/Hz)');
else
    dvdisplay(col, sc, 'ylabel', 'string', 'S^{1/2} (V/Hz^{1/2})');
end

    
    
dvdisplay(col, sc, 'filename');
dvdisplay(col, sc, 'xlabel', 'string', 'f (Hz)');



dvplot(col, sc);

