function sc = loadspect3(file, col, ctrl, res)
% sc = loadspect3(file, col, ctrl, res)
%load long time traces taken by lockin, no procfn in these scans
%res is the resistance through the QPC
%possible cntl values: 'log' plots on loglog scale
%VV plots as volts^2/Hz
%AU plots in arbitrary units without scale
%blank control defaults to volts/root(Hz)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global dvdata;

if nargin <= 3
    ctrl = '';
end

load(file, 'scan', 'data');

col = dvinsert(file, col, []);
sc = length(dvdata.collections{col}.datasets);

Tmeas = scan.loops(1).npoints*scan.loops(1).ramptime*scan.loops(2).npoints;
win = window(@hann, 8000);

if strfind(ctrl, 'AU')
    scl = 1;
elseif strfind(ctrl, 'VV');
    scl = res^2*Tmeas;
else 
    scl = res*Tmeas;
end
npts = length(spectrogram(reshape(data{1}',1,scan.loops(1).npoints*scan.loops(2).npoints),win));


dvfilter(col, sc, @reshape,'', 1, size(data{1},1)*size(data{1},2)); %concatinate all interations of the data
dvfilter(col, sc, @spectrogram, '', win);
dvfilter(col, sc, @abs);
if ~isempty(ctrl)
    dvfilter(col, sc, @power, '',2);
end
dvfilter(col, sc, @mean, '', 2);
dvfilter(col, sc, @scale, '',  scl);

%npts = length(spectrogram(reshape(data{1}',1,scan.loops(1).npoints*scan.loops(2).npoints),win));
Fmax = .5/abs(scan.loops(1).ramptime); %2 sample in nyquist freq
freqs = linspace(0,Fmax,npts);

dvfilter(col, sc, @dvfpermute, 'x', freqs, 2);

if strfind(ctrl, 'log')
    dvdisplay(col, sc, 'axes', 'xscale', 'log', 'yscale', 'log', 'xlim', [.9*freqs(1), 1.1*freqs(end)]);
else
    dvdisplay(col, sc, 'axes', 'xscale', 'log', 'xlim', [.9*freqs(1), 1.1*freqs(end)]);
end

if strfind(ctrl, 'AU')
    dvdisplay(col, sc, 'ylabel', 'string', 'amplitude (AU)');
elseif strfind(ctrl, 'VV')
    dvdisplay(col, sc, 'ylabel', 'string', 'S (V^2/Hz)');
else
    dvdisplay(col, sc, 'ylabel', 'string', 'S^{1/2} (V/Hz^{1/2})');
end

    
dvdisplay(col, sc, 'filename');
dvdisplay(col, sc, 'xlabel', 'string', 'f (Hz)');

dvplot(col, sc);
end
