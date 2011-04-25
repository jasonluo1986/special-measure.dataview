function graphobj = dvgraphprop(col, ds, ind)
%value = dvgraphobj(col, ds, ind);
%if only col and im are given, indices and types of graph objects are given
%if ind is given, all its properties are listed

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global dvdata;

if nargin < 2 || isempty(ds)
    ds = 1:length(dvdata.collections{col}.datasets);
end

switch nargin 
    case 2
        if nargout > 0
            graphobj = {dvdata.collections{col}.datasets(ds).graphobjs};      
        else
            for j = 1:length(ds)
                graphobj = dvdata.collections{col}.datasets(ds(j)).graphobjs;
                fprintf('Graphobjects of dataset %d in collection %d\n----------------------------------------\n',...
                    ds(j), col);
                for i = 1:length(graphobj)
                    if ~isempty(graphobj(i).type)
                        fprintf('%3d  %s\n', i, graphobj(i).type);
                    end
                end
            end
        end
    case 3
        for j = 1:length(ds)            
            if ischar(ind)
                ind2 = find(strcmp({dvdata.collections{col}.datasets(ds(j)).graphobjs.type}, ind));
            else
                ind2 = ind;
            end
            graphobj(j, :) = dvdata.collections{col}.datasets(ds(j)).graphobjs(ind2);
            if nargout == 0
                for i = 1:size(graphobj, 2)
                    fprintf('Properties of %s (index %d) in dataset %d, collection %d:\n%s\n',...
                        graphobj(j, i).type, ind2(i), ds(j), col,...
                        '----------------------------------------------------------------');
                    disp(graphobj(j, i).args);
                end
            end
        end
end
