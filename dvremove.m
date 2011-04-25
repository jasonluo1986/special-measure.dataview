function dvremove(collection, dataset)
% imremove(collection, dataset)
% whole collection(s) cleared if imagte not given
% collection can be an array in ths case, otherwise image can be an array

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global dvdata;

if nargin > 1
    indices = true(size(dvdata.collections{collection}.datasets));
    indices(dataset) = false;
    dvdata.collections{collection}.datasets = ...
        dvdata.collections{collection}.datasets(indices);
else
     dvdata.collections(collection) = cell(1, length(collection));
end
    

