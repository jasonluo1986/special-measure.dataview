function [data, x, y] = dvfcutnan(data, x, y)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


s.type = '()';
for i = 2:ndims(data)
    s.subs{i} = size(data, i);
end
s.subs{1} = ':';
lastind = find(~isnan(subsref(data, s)), 1, 'last');
s.subs{1} = 1:lastind;
s.subs(2:end) = {':'};
data = subsref(data, s);

if nargin > 1 
    if ndims(data) == 2
        y = y(1:lastind);
    end
end 
        
