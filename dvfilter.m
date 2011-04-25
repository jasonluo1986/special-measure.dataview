function dvfilter(collections, datasets, filter, mode, varargin)
% dvfilter(collections, datasets, filter, mode, args)
% filter can be a filter struct or a handle, in which case args are the 
% filter arguments
% mode: chg, del. All others (x, y, all, comb) passed on to filter.

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global dvdata;


if nargin < 1 || isempty(collections)
    collections = 1:length(dvdata.collections);
    collections = collections(~isempty(dvdata.collections(collections)));
end

if nargin < 4
    mode = '';
end

if nargin > 2 && ~isstruct(filter) && ~strcmp(mode, 'del') && ~strcmp(mode, 'chg')
    filter = struct('function', filter, 'args', {varargin}, 'mode',  mode);
end

for collection = collections
    
    if collection > length(dvdata.collections) || isempty(dvdata.collections{collection})
        %fprintf('Collection %d invalid\n', collection);
        continue;
    end
    
    if nargin < 2 || isempty(datasets)
        datasets = 1:length(dvdata.collections{collection}.datasets);
    end
    
    for i = datasets
        switch mode
            case 'del'
                if isempty(filter)
                    if length(dvdata.collections{collection}.datasets(i).file) == 1
                        dvdata.collections{collection}.datasets(i).filter = [];
                    else
                        dvdata.collections{collection}.datasets(i).filter ...
                            = dvdata.collections{collection}.datasets(i).filter(end);
                    end
                elseif isnumeric(filter)
                    dvdata.collections{collection}.datasets(i).filter(filter) = [];
                else
                    for j = 1:length(dvdata.collections{collection}.datasets(i).filter)
                        if strcmp(func2str(dvdata.collections{collection}.datasets(i).filter(j).function),...
                                func2str(filter))
                            dvdata.collections{collection}.datasets(i).filter(j) = [];
                        end
                    end
                end
                
            case 'chg'                
                if isnumeric(filter)
                    dvdata.collections{collection}.datasets(i).filter(filter).args = varargin;
                else
                    for j = 1:length(dvdata.collections{collection}.datasets(i).filter)
                        if strcmp(func2str(dvdata.collections{collection}.datasets(i).filter(j).function),...
                                func2str(filter))
                            dvdata.collections{collection}.datasets(i).filter(j).args = varargin;
                        end
                    end
                end
                
            otherwise
                
                if ~isstruct(dvdata.collections{collection}.datasets(i).filter)
                        dvdata.collections{collection}.datasets(i).filter = filter;
                else
                    if length(dvdata.collections{collection}.datasets(i).file) == 1
                        dvdata.collections{collection}.datasets(i).filter = ...
                            [dvdata.collections{collection}.datasets(i).filter, filter];
                    else % multiimage, inser before displayfunction
                        dvdata.collections{collection}.datasets(i).filter = ...
                            [dvdata.collections{collection}.datasets(i).filter(1:end-1), filter, ...
                            dvdata.collections{collection}.datasets(i).filter(end)];
                    end
                end
        end
    end
end
