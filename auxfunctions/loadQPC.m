function sc = loadQPC(file, col, ch, opts)
% sc = loadQPC(file, col, ch)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


load(file, 'scan');

if ~exist('opts','var')
    opts='';
end

if nargin < 3 || isempty(ch)
    ch = 1:length([scan.loops.getchan]);
end

for i = 1:length(ch)
    [col, sc(i)] = dvinsert(file, col, [], ch(i));
end

if(~isempty(strfind(opts,'mean')))
    dvfilter(col,sc,@mean,2);
end
if(~isempty(strfind(opts,'center')))
    dvfilter(col,sc,@(x) x-mean(x));
end
dvdisplay(col, sc, 'filename');


if ~isempty(scan.loops(1).setchan)
    if ~ iscell(scan.loops(1).setchan)
        scan.loops(1).setchan = {scan.loops(1).setchan};
    end
    dvdisplay(col, sc, 'xlabel', 'string', [scan.loops(1).setchan{:}]);
end

dvplot(col, sc);

