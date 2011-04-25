function dvclear(datasets)
% dvclear(datasets)
% remove datasets from cache. If no argument is given, multiple copies
% of the same image are removed.

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global dvdata;

if nargin < 1 % check for doubles
    %i = 1;
    for i = 1:length(dvdata.cache)
        if isempty(dvdata.cache{i})
            continue;
        end
        %j = i+1;
        for j = i+1:length(dvdata.cache);
            if ~isempty(dvdata.cache{j}) ...
                    && strcmp(dvdata.cache{i}.filename, dvdata.cache{j}.filename);
                for k = 1:length(dvdata.collections)
                    if ~isempty(dvdata.collections{k})
                        for m = 1:length(dvdata.collections{k}.datasets)
                            if dvdata.collections{k}.datasets(m).index == j
                                dvdata.collections{k}.datasets(m).index = i;
                            end
                        end
                    end
                end
                dvdata.cache{j} = [];
            end
        end
    end
else % remove datasets and references
    for i = datasets
        for k = 1:length(dvdata.collections)
            if ~isempty(dvdata.collections{k})
                l = 1;
                while l <= length(dvdata.collections{k}.datasets)
                    if dvdata.collections{k}.datasets(l).index == i
                        dvdata.collections{k}.datasets = ...
                            dvdata.collections{k}.datasets([1:l-1, l+1:end]);
                    else l = l+1;
                    end
                end
            end
        end
        dvdata.cache{i} = [];    
    end
end        
   
