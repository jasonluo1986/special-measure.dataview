function sc = loadhist3(file, col, frames, channels)
% sc = loadhist3(file, col, frames, channels)
% Loads hist including mean of all group histograms, which is used by setcal. 
% loadhist does the same without the mean. loadhist2 and does not support data processed
% by smpSnglshot.

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


if nargin < 3
    frames = [];
end
    
load(file, 'scan', 'data');

if nargin < 4 
    channels = 1:nchan;
end

nchan = length(strmatch('DAQ', scan.loops(1).getchan));


useSmp = strcmp(func2str(scan.loops(1).procfn(1).fn(end).fn), 'smpSnglShot'); 

if useSmp 
    channels = channels + nchan;
else
    channels = channels + length(data)-nchan;
end
sz = size(data{channels(1)});

nds = length(sz);

sc = zeros(1, nds * length(channels));
for r = 1:length(channels)
    [col, sc(nds*(r-1)+1)] = dvinsert(file, col, [], channels(r));
    dvcopy(col, repmat(sc(nds*(r-1)+1), 1, nds-1), col);
    sc(nds*(r-1)+2:nds*r) = sc(nds*(r-1)+1)+(1:nds-1);   
end

if length(sz) == 3
    dvfilter(col, sc(1:nds:end), @permute, '', [3 2 1]);
    dvfilter(col, sc(1:nds:end), @reshape, '', sz(2)* sz(3), sz(1));
    dvfilter(col, sc(1:nds:end), @transpose);    
end
    
dvfilter(col, sc(1:nds:end), @dvfpermute, 'y', (1:sz(1))', 2);

if nargin < 3 || isempty(frames)
    dvfilter(col, sc(1), @dvfcutnan, 'all');
    for i = 2:nds
        dvfilter(col, sc(i:nds:end), @dvfcutnan, '');
    end
else
    dvfilter(col, sc, @dvfselect, '', {frames});
    dvfilter(col, sc(1:nds:end), @dvfselect, 'y', {frames});
end

if useSmp
    dvfilter(col, sc, @dvfpermute, 'x', ...
        mean(scan.loops(1).procfn(1).fn(2).args{1}.datadef(2).par{1}([1:end-1; 2:end])), 2)
else
    dvfilter(col, sc, @dvfpermute, 'x', scan.loops(1).procfn(channels(r)).fn.args{1}, 2);
end

dvdisplay(col, sc(1:nds:end), 'axes', 'ydir', 'reverse');
dvdisplay(col, sc(1:nds:end), 'ylabel', 'string', 'sweep #');
dvdisplay(col, sc(1:nds:end), 'color');

dvdisplay(col, sc(nds:nds:end), 'xlabel', 'string', 'V_{RF}');

for i = 2:nds
    dvfilter(col, sc(i:nds:end), @sum, '', 1);
    dvfilter(col, sc(i:nds:end), @squeeze);
end

if nds >= 3
    dvfilter(col, sc(3:nds:end), @mean);
    dvdisplay(col, sc(3:nds:end) , 'prevax');
end

dvdisplay(col, sc(nds:3:end), 'data', 'Marker', '.', 'color', 'k');
dvdisplay(col, sc([1:nds:end, nds:nds:end]) , 'filename');

dvplot(col, sc);
