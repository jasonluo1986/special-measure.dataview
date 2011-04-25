% function data = dvfselect(data, index)
% filter arguments; cell array of indices?

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.

function data = dvfselect(data, index)

ndim = ndims(data);
s.type = '()';
if iscell(index)
    nind = length(index);
    s.subs(nind:-1:1) = index;
else
    nind = size(index, 1);
    for i = 1:nind
        s.subs{nind+1-i} = index(i, 1):index(i, min(2, end));
    end
end
s.subs(nind+1:ndim) = {':'};
data = subsref(data, s);
