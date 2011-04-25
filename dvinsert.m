function [collection, position] = dvinsert(file, collection, position, channel, type)
% collection = dvinsert(file, collection, position, channel)
%
% file can be a filename or index to cache
% collection = 0 (defaults) gives a new collection, position to end
% channel default = 1
% return value is index of collection

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global dvdata;


if nargin < 2 || collection == 0% new collection
    collection = 1;
    while collection <= length(dvdata.collections) && ~isempty(dvdata.collections{collection}); 
        collection = collection + 1; 
    end;

    % initialise
    dvdata.collections{collection}.datasets = [];
    dvdata.collections{collection}.figsize = [2, 2];
    %dvdata.collections{collection}.font = 12;
else
    if collection > length(dvdata.collections) || isempty(dvdata.collections{collection})
        fprintf('Collection %d invalid\n', collection);
        return;
    end
end

if nargin < 3 || isempty(position)% inser at end
    position = length(dvdata.collections{collection}.datasets) + 1;
end

%for index = indices % could build in some loop.

if ischar(file)
    ds.file = {file};
else
    ds.file = file;
end
%ds.index = index;
ds.filter = []; 
%ds.colscale = []; %autoscale
ds.flags = 0;
%ds.xyscale = [];
%ds.datascale = [];
ds.graphobjs =  struct('type', {}, 'args', {});
%ds.nfigs = 1;
if nargin < 4 || isempty(channel)
    ds.channel = 1;
else
    ds.channel = channel;
end

if nargin >=5 
    ds.type = type;
    if ~isfield(dvdata.collections{collection}.datasets, 'type') ...
            && ~isempty(dvdata.collections{collection}.datasets)
        [dvdata.collections{collection}.datasets.type] = deal('');
    end
elseif isfield(dvdata.collections{collection}.datasets, 'type') 
    ds.type = '';    
end


dvdata.collections{collection}.datasets = ...
    [dvdata.collections{collection}.datasets(1:position - 1), ds, ...
    dvdata.collections{collection}.datasets(position:end)];

dvdata.collections{collection}.lastplot = position+(0:length(ds));
%position = position + 1;
%end

