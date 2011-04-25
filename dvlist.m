function dvlist(collection, indices)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global dvdata;


if nargin < 1 || isempty(collection)
    collection = 1:length(dvdata.collections);
end

if length(collection)~=1 % display collections    
    for i = collection
        if isempty(dvdata.collections{i})
            fprintf('%d  (empty)\n', i);
            continue;
        end
        
        if isfield(dvdata.collections{i}, 'name');
            fprintf('%d  %s (%d datasets)\n',  i, dvdata.collections{i}.name, ...
                length(dvdata.collections{i}.datasets));
        else
            fprintf('%d  (%d images)\n',  i, length(dvdata.collections{i}.datasets));
        end
    end       
else 
    if isfield(dvdata.collections{collection}, 'name');
        fprintf('Datasets in collection "%s":\n', dvdata.collections{collection}.name);
    else
        fprintf('Datasets in collection %d:\n', collection);
    end
    fprintf('coll.ind cache.ind name\n-----------------------------------------\n'); 
    
    if nargin < 2 || isempty(indices)
        indices = 1:length(dvdata.collections{collection}.datasets);
    end

    for i = indices
        if ~isstruct(dvdata.collections{collection}.datasets(i).file) && length(dvdata.collections{collection}.datasets(i).file) > 1
            fprintf('%3d  multiset, %d scans\n',  i,...
                length(dvdata.collections{collection}.datasets(i).file));
 
            if length(indices) == 1 % only one image listed, show multiimage details
                for j = 1:length(dvdata.collections{collection}.datasets(i).file)
                    file = getname(collection, j);
                    if iscell(dvdata.collections{collection}.datasets(i).file)
                        fprintf('%3d  %s\n', i, file)
                    else
                        fprintf('%3d  %3d  %s\n', i, dvdata.collections{collection}.datasets(i).file, file);
                    end
                end
            end
        else
            file = getname(collection, i);
            if nargin >= 2 || i == 1 || i == indices(end) || ...
                    ~strcmp(file, getname(collection, i-1)) || ~strcmp(file, getname(collection, i+1))
                if iscell(dvdata.collections{collection}.datasets(i).file) || isstruct(dvdata.collections{collection}.datasets(i).file)
                    fprintf('%3d  %s\n', i, file)
                else
                    fprintf('%3d  %3d  %s\n', i, dvdata.collections{collection}.datasets(i).file, file);
                end
            else
                if(~bitand(dvdata.collections{collection}.datasets(i).flags,4096))
                  fprintf('(%3d)',i);
                else
                  fprintf('.');
                end
            end
        end
    end
end
    
function file = getname(col, ind)
global dvdata;
file = dvdata.collections{col}.datasets(ind).file;
    
if ~isfield(dvdata.collections{col}.datasets, 'type') || isempty(dvdata.collections{col}.datasets(ind).type)
    if isnumeric(file)
        switch length(file)
            case 0
                file = 'empty';
            case 1
                file = dvdata.cache{file}.filename;
            otherwise;
                file = 'multiset';
        end
    else
        file = file{1};
    end
else
    switch dvdata.collections{col}.datasets(ind).type
        case 'fit'
           file = ['fit: ', dvdata.collections{col}.datasets(ind).file.name];
           
        otherwise
            file = dvdata.collections{col}.datasets(ind).type;    
    end
end


%     fprintf('Cached files:\nIndex Name (# of scans)\n--------------------------\n');
%         
%     if nargin < 2 || isempty(indices)
%         indices = 1:length(dvdata.cache);
%     end
%     for i = indices
%         if ~isempty(dvdata.cache{i})            
%             fprintf('%3d   %s\n',  i, dvdata.cache{i}.filename);
%         end
%     end    
