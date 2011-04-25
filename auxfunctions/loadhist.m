function sc = loadhist(file, col, frames, channels)
% sc = loadhist(file, col, frames, channels)
% Load histograms, plotting one curve for each group.
% Largely superseded by loadhist2/3

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


if nargin < 3
    frames = [];
end
    
load(file, 'scan', 'data');

nchan = length(strmatch('DAQ', scan.loops(1).getchan));
if nargin < 4 
    channels = 1:nchan;
end


sc = zeros(1, 2 * nchan);
channels = channels + length(data)-nchan;

sz = size(data{channels(1)});

for r = 1:nchan
    [col, sc(2*r-1)] = dvinsert(file, col, [], channels(r));
    dvcopy(col, sc(2*r-1), col);
    sc(2*r) = sc(2*r-1)+1;   
end

if length(sz) == 3
    dvfilter(col, sc(1:2:end), @permute, '', [3 2 1]);
    dvfilter(col, sc(1:2:end), @reshape, '', sz(2)* sz(3), sz(1));
    dvfilter(col, sc(1:2:end), @transpose);
    
    %dvfilter(col, sc(1:2:end), @permute, '', [3 2 1]);
    %dvfilter(col, sc(1:2:end), @reshape, '', sz(2)* sz(3), sz(1));
    %dvfilter(col, sc(1:2:end), @transpose);

end
    
dvfilter(col, sc(1:2:end), @dvfpermute, 'y', (1:sz(1))', 2);

if nargin < 3 || isempty(frames)
    dvfilter(col, sc, @dvfcutnan, 'all');
else
    dvfilter(col, sc, @dvfselect, '', {frames});
    dvfilter(col, sc(1:2:end), @dvfselect, 'y', {frames});
end

dvfilter(col, sc, @dvfpermute, 'x', scan.loops(1).procfn(channels(r)).fn.args{1}, 2);
   

dvdisplay(col, sc(1:2:end), 'axes', 'ydir', 'reverse');
dvdisplay(col, sc(1:2:end), 'ylabel', 'string', 'sweep #');
dvdisplay(col, sc(1:2:end), 'color');

dvdisplay(col, sc(2:2:end), 'xlabel', 'string', 'V_{RF}');

dvfilter(col, sc(2:2:end), @sum, '', 1);
dvfilter(col, sc(2:2:end), @squeeze);
dvdisplay(col, sc(2:2:end), 'data', 'Marker', '.');

dvdisplay(col, sc , 'filename');

dvplot(col, sc);
