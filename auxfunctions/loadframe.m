function sc = loadframe(file, col, frames, ch)
%sc = loadframe(file, col, frames, ch)
% load some frames of scan repated in last (third?) loop

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.



load(file, 'scan');

if nargin < 4 || isempty(ch)
    ch = 1;
end

if nargin < 3 || isempty(frames)
    frames = 1:scan.loops(3).npoints;
end

sc = zeros(size(frames));
for i = 1:length(frames)
    [col, sc(i)] = dvinsert(file, col, [], ch);
    dvfilter(col, sc(i), @dvfselect, '', i);
end

dvfilter(col, sc, @squeeze);
%dvfilter(col, sc, @diff, '', [], 2);
dvdisplay(col, sc, 'color');
dvdisplay(col, sc, 'imax');

dvdisplay(col, sc, 'filename');


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


dvplot(col, sc);

