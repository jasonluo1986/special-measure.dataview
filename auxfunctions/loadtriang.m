function sc = loadtriang(file, col, ch)
% sc = loadtriang(file, col, ch)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


if nargin < 3
    ch = 1;
end

load(file, 'scan');

[col, sc(1)] = dvinsert(file, col, [], ch);
[col, sc(2)] = dvinsert(file, col ,[], ch);
    

dvdisplay(col, sc, 'filename');
dvdisplay(col, sc(1), 'color');
dvdisplay(col, sc(1), 'imax');

%ind = imagedata.collections{col}.images(sc).index;
%rng = imagedata.cache{ind}.range(1) * [-.5, .5] + imagedata.cache{ind}.shift(1);
%dvdisplay(col, sc+1, 'imaxes', 'xlim', rng, 'Fontsize', 6);

if length(scan.loops) > 2
    dvfilter(col, sc, @dvfcutnan);
    dvfilter(col, sc, @mean);
    dvfilter(col, sc, @squeeze);
end
r = dvgetregion(col, sc(1), 1);
dvfilter(col, sc, @imfplanesub, '', r);

dvplot(col, sc);
