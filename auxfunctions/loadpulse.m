function [sc, col] = loadpulse(file, col)
% [sc, col] = loadpulse(file, col)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


load(file, 'scan', 'data');

sr = scan.configfn.args{3}(2);
sz = size(data{1});

[col, sc(1)] = dvinsert(file, col);
[col, sc(2)] = dvinsert(file, col);


dvdisplay(col, sc, 'filename');


dvdisplay(col, sc(1), 'color');
dvdisplay(col, sc(1), 'colbar');
dvfilter(col, sc(1), @dvfpermute, 'x', 1e6 * (1:sz(2))'./sr, 2);    

dvfilter(col, sc(2), @dvfpermute, 'x', 1e6 * (1:sz(2))'./sr, 2);    
dvfilter(col, sc(2), @mean, '', 1);    
dvdisplay(col, sc(2), 'xline');


dvdisplay(col, sc, 'xlabel', 'string', 't (\mus)');

dvplot(col, sc);

%sc = sc(1);
