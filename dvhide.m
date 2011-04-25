function dvhide(col)
% dvhide(col)
% hide all datasets forming part of a multiset

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.

global dvdata;

recsets = find(bitand([dvdata.collections{col}.datasets.flags], 128));

%dvdisplay(col, [dvdata.collections{col}.datasets(recsets).file], 'noplot');
    
for i = recsets
    dvdisplay(col, dvdata.collections{col}.datasets(i).file+i, 'noplot');
end
