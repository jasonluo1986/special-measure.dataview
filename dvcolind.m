function col = dvcolind(name)
% col = dvcolind(name)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.

global dvdata;

if ~ischar(name)
    col = name;
    if col > length(dvdata.collections) || isempty(dvdata.collections{col})
        error('Collection %d empty.', col)
    end
    return;
end

col = nan;
for i = 1:length(dvdata.collections)
    if isfield(dvdata.collections{i}, 'name')  && strcmp(dvdata.collections{i}.name, name)
        col = i;
        break
    end
end

if isnan(col)
    error('Collection %s not found.', name);
end
