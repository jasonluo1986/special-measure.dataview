function sc = loadT1cal(file, col, frames, channels)
% sc = loadT1cal(file, col, frames, channels)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


if nargin < 3
    frames = [];
end
    
load(file, 'scan', 'data');

nchan = length(strmatch('DAQ', scan.loops(1).getchan));
if nargin < 4 
    channels = 1:nchan;
end

channels = channels + 2*nchan;
nds = 3;

sz = size(data{channels(1)});

sc = zeros(1, nds * nchan);
for r = 1:nchan
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

dvfilter(col, sc, @dvfpermute, 'x', (1:sz(3))*(1e6./scan.configfn.args{3}(2)), 2);

dvdisplay(col, sc(1:nds:end), 'axes', 'ydir', 'reverse');
dvdisplay(col, sc(1:nds:end), 'ylabel', 'string', 'sweep #');
dvdisplay(col, sc(1:nds:end), 'color');

dvdisplay(col, sc(nds:nds:end), 'xlabel', 'string', 't (\mus)');

for i = 2:nds
    dvfilter(col, sc(i:nds:end), @mean, '', 1);
    dvfilter(col, sc(i:nds:end), @squeeze);
end

%     dvfilter(col, sc(nds:nds:end), @transpose);
%     dvfilter(col, sc(nds:nds:end), @mtimes, '', [1 0 -1 0; 0 1 0 -1; 1 -1 0 0; 0 0 1 -1]');
%     dvfilter(col, sc(nds:nds:end), @transpose);

dvdisplay(col, sc([1:nds:end, nds:nds:end]) , 'filename');

dvplot(col, sc);

