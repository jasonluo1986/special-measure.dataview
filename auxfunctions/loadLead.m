%function sc = loadLead(file, col)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.

function sc = loadLead(file, col)

load(file, 'data');

[col, sc] = dvinsert(file, col);

n = size(data{1}, 3);

dvdisplay(col, sc, 'filename');

dvfilter(col, sc, @mean);
dvfilter(col, sc, @squeeze);
dvfilter(col, sc, @dvfpermute, 'x', 1:n, 2);

dvplot(col, sc);

