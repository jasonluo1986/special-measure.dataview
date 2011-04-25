function setoffset2(collection, ds, inc, off, scl)
% setoffset2(collection, ds, inc, off, scale)
% inc = offset increment, off= overall offset

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


if nargin < 4;
    off = 0;
end

if nargin < 5;
    scl = 1;
end

dvfilter(collection, ds, @oscale, 'del');
for i = 1:length(ds);
    dvfilter(collection, ds(i), @oscale, '', scl, (i-1)*inc+off);
end
return

% Setoffset2 now uses a private scale function so it can stack with setcal.
function d=oscale(d,s,o)
d=scale(d,s,o);
return


