function dvclose(collection, figs)
% dvclose(collection, figs)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global dvdata;

if nargin < 2
    figs = 1:sum(bitand([dvdata.collections{collection}.datasets.flags], 4096+8)==0)...
        / prod(dvdata.collections{collection}.figsize);
end

for i = figs
    if ishandle(5899 + collection*100 + i)
        close(5899 + collection*100 + i);
    end
end

