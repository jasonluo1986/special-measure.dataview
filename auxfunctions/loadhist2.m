function sc = loadhist2(file, col, frames, channels)
% sc = loadhist2(file, col, frames, channels)
% Loads hist including mean of all group histograms, which is used by setcal. 
% loadhist does the same without the mean.

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.

if nargin < 3
    frames = [];
end
    
load(file, 'scan', 'data');

nchan = length(strmatch('DAQ', scan.loops(1).getchan));
if nargin < 4 
    channels = 1:nchan;
end

useSmp = strcmp(func2str(scan.loops(1).procfn(1).fn(end).fn), 'smpSnglShot'); 

sc = zeros(1, 3 * nchan);
if useSmp 
    channels = channels + nchan;
else
    channels = channels + length(data)-nchan;
end
sz = size(data{channels(1)});

for r = 1:nchan
    [col, sc(3*r-2)] = dvinsert(file, col, [], channels(r));
    dvcopy(col, sc(3*r-2) +[0 0], col);
    sc(3*r+(-1:0)) = sc(3*r-2)+(1:2);   
end

if length(sz) == 3
    dvfilter(col, sc(1:3:end), @permute, '', [3 2 1]);
    dvfilter(col, sc(1:3:end), @reshape, '', sz(2)* sz(3), sz(1));
    dvfilter(col, sc(1:3:end), @transpose);
    
    %dvfilter(col, sc(1:2:end), @permute, '', [3 2 1]);
    %dvfilter(col, sc(1:2:end), @reshape, '', sz(2)* sz(3), sz(1));
    %dvfilter(col, sc(1:2:end), @transpose);

end
    
dvfilter(col, sc(1:3:end), @dvfpermute, 'y', (1:sz(1))', 2);

if nargin < 3 || isempty(frames)
    dvfilter(col, sc(1), @dvfcutnan, 'all');
    dvfilter(col, sc([2:3:end 3:3:end]), @dvfcutnan, '');
else
    dvfilter(col, sc, @dvfselect, '', {frames});
    dvfilter(col, sc(1:3:end), @dvfselect, 'y', {frames});
end

if useSmp
    dvfilter(col, sc, @dvfpermute, 'x', ...
        mean(scan.loops(1).procfn(1).fn(2).args{1}.datadef(2).par{1}([1:end-1, 2:end])), 2)
else
    dvfilter(col, sc, @dvfpermute, 'x', scan.loops(1).procfn(channels(r)).fn.args{1}, 2);
end

dvdisplay(col, sc(1:3:end), 'axes', 'ydir', 'reverse');
dvdisplay(col, sc(1:3:end), 'ylabel', 'string', 'sweep #');
dvdisplay(col, sc(1:3:end), 'color');

dvdisplay(col, sc(3:3:end), 'xlabel', 'string', 'V_{RF}');

dvfilter(col, sc([2:3:end, 3:3:end]), @sum, '', 1);
dvfilter(col, sc([2:3:end, 3:3:end]), @squeeze);
dvfilter(col, sc(3:3:end), @mean);
%dvdisplay(col, sc(2:3:end), 'data', 'Marker', '.');
dvdisplay(col, sc(3:3:end), 'data', 'Marker', '.', 'color', 'k');

dvdisplay(col, sc([1:3:end, 3:3:end]) , 'filename');
dvdisplay(col, sc(3:3:end) , 'prevax');

dvplot(col, sc);
