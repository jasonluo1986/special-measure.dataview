function [sc, col] = load2D(file, col, ch, xyscale, zscale)
% sc = load2D(file, col, ch, xyscale, zscale)
% Creates a line plot of 1-d data set
% xscale and yscale get multiplied by the x and y data

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global dvdata;


load(file, 'scan');

if nargin < 3 || isempty(ch)
    if any(cellfun(@iscell, {scan.loops.getchan})) % some channel given as cell array
        ch = 1:length([scan.loops.getchan]);
    else
        ch = 1:size(strvcat(scan.loops.getchan), 1);
    end
end

sc = zeros(size(ch));
for i = 1:length(ch)
    [col, sc(i)] = dvinsert(file, col, [], ch(i));
end

%sc = length(dvdata.collections{col}.datasets) + (-length(ch)+1:0);


dvdisplay(col, sc, 'filename');

if nargin >= 5 && ~isempty(xyscale)
    dvfilter(col, sc, @times, 'x', xyscale(1));
    dvfilter(col, sc, @times, 'y', xyscale(2));
end

if length(scan.loops) >=2
    if ~isempty(scan.loops(1).setchan)
        if ~ iscell(scan.loops(1).setchan)
            scan.loops(1).setchan = {scan.loops(1).setchan};
        end
        dvdisplay(col, sc, 'xlabel', 'string', [scan.loops(1).setchan{:}]);
    end

    if ~isempty(scan.loops(2).setchan)
        if ~ iscell(scan.loops(2).setchan)
            scan.loops(2).setchan = {scan.loops(2).setchan};
        end
        dvdisplay(col, sc, 'ylabel', 'string', [scan.loops(2).setchan{:}]);
    end
end
    
if length(scan.loops) > 2
    dvfilter(col, sc, @dvfcutnan);
    dvfilter(col, sc, @mean);
    dvfilter(col, sc, @squeeze);
end


if nargin >= 5
    dvfilter(col, sc, @times, '', zscale);
end

dvdisplay(col, sc, 'color');
dvdisplay(col, sc, 'colbar');
dvdisplay(col, sc, 'imax');
%dvdisplay(col, sc, 'title', 'string', scan.loops(2).getchan(1));

dvplot(col, sc);

%sc = sc(1);
