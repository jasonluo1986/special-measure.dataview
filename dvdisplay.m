function graph = dvdisplay(collections, datasets, parameter, varargin )
% graph = dvdisplay(collections, datasets, parameter, varargin )
%
% if parameter is a string (see below), the operation is done on all
% datasets in collections, with some expansion rules ([] = all)
% returns index of graphobject in last plot if an object is created, 0
% otherwise
% if paraemters is a graph object index, the collections and datasets must be scalars, 
% specifying one particular object whose properties are manipulated.
% parameter being an index no varagin empty deletes an object!
% possible parameter strings:
% flags: 'colbar', 'noax', 'scalebar', 'noplot', 'filename', 'color', 'yline', 'recurse', ...
%    , 'imax', 'prevax'
% objects: line, text, curve, scaleline, scalelabel, title, colaxes, axes, data, xlabel, ylabel, 
% Run with no arguments for a list of flags.

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.

global dvdata;

% could use config data here
flags = {'colbar', 'noax', 'scalebar', 'noplot', 'filename', 'color', 'yline', 'recurse', 'flag8', 'flag9', ...
    'flag10', 'imax', 'prevax'};
% flag9 seems to mean 'title'

if (nargin == 0)
   for i=1:length(flags)
       fprintf('%-10s: %d\n',flags{i},2^(i-1));
   end
   return;
end
graph = 0;

if isempty(collections)
    collections = 1:length(dvdata.collections);
    %     collecitons = collections(~isempty(dvdata.collections(collections)));
end

if isempty(varargin) || (isnumeric(varargin{1}) && any(varargin{1} ~= 0))
    setflags = 1; 
    clearflags = 0;
else
    setflags = 0; 
    clearflags = 1;    
end
         

        
objs =  {'line', 'text', 'curve', 'scaleline', 'scalelabel', 'title', 'colaxes', 'axes', 'data', 'xlabel', 'ylabel', 'conf', 'legend'};


flagvalue = 2.^(find(strcmp(flags, parameter), 1)-1);
if isempty(flagvalue)
    flagvalue = 0;
end

setflags = flagvalue * setflags;
clearflags = flagvalue * clearflags;

newgraph = find(strcmp(objs, parameter), 1);

for collection = collections    
    if collection > length(dvdata.collections) || isempty(dvdata.collections{collection})
        %fprintf('Collection %d invalid\n', collection);
        continue;
    end
    
    if nargin < 2 || isempty(datasets)
        datasets2 = 1:length(dvdata.collections{collection}.datasets);
    else
        datasets2 = datasets;
    end
    
    for i = datasets2
        
        dvdata.collections{collection}.datasets(i).flags = ...
            bitand(bitor(dvdata.collections{collection}.datasets(i).flags, setflags),...
            bitxor(clearflags, 2^16-1));

        graphobjs = dvdata.collections{collection}.datasets(i).graphobjs;

        if ~isempty(newgraph) % valid object
            if newgraph <= 3 && ~isempty(varargin)
                graph = find(strcmp({graphobjs.type}, ''), 1);
            else
                graph = find(strcmp({graphobjs.type}, parameter));
            end
            if isempty(varargin)
               %if strcmp(parameter, '')
                   graphobjs(graph) = [];
               %else
               %    [graphobjs(graph).type] = deal('');
               %    [graphobjs(graph).args] = deal({});
               %end
            else
                if isempty(graph)
                    graph = length(graphobjs)+1;
                end
                graphobjs(graph(1)).type = parameter;
                graphobjs(graph(1)).args = varargin;
            end
        elseif isnumeric(parameter)
            if isempty(varargin)
                graphobjs(parameter) = [];
            else
                graphobjs(graph).args = varargin;
            end
        end
        dvdata.collections{collection}.datasets(i).graphobjs = graphobjs;
    end
end
