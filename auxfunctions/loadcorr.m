function sc = loadcorr(file, col)
% sc = loadcorr(file, col)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global dvdata;


load(file, 'scan', 'data');

sz = size(data{1});


col = dvinsert(file, col);
sc = length(dvdata.collections{col}.datasets);

dvfilter(col, sc, @dvfcutnan);
dvfilter(col, sc, @diff, '', [], 2);
dvfilter(col, sc, @permute, '', [1 3 2]);
dvfilter(col, sc, @times, '', -1);


dvfilter(col, sc, @dvfpermute, 'x', (-(sz(3)-1)/2:(sz(3)-1)/2), 2);
%dvfilter(col, sc, @dvfpermute, 'y', (1:sz(1))', 2);

%dvcopy(col, sc, col);
%dvdisplay(col, sc, 'color');
%dvdisplay(col, sc, 'axes', 'ydir', 'reverse');
%dvdisplay(col, sc, 'ylabel', 'string', 'trace #');

dvfilter(col, sc, @mean);

dvdisplay(col, sc+(0), 'filename');
dvdisplay(col, sc, 'xlabel', 'string', '\Deltat');


dvplot(col, sc+(0));

