function sc = loadlineplot(file, col, xscale, yscale)
% sc = loadlineplot(file, col, xscale, yscale)
% Creates a line plot of 1-d data set
% xscale and yscale get multiplied by the x and y data

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global dvdata;


col = dvinsert(file, col);
sc = length(dvdata.collections{col}.datasets);

load(file, 'scan');
dvdisplay(col, sc, 'filename');

if exist('xscale', 'var')
    dvfilter(col, sc, @times, 'x', xscale);
end

if ~isempty(scan.loops(1).setchan)
    if ~ iscell(scan.loops(1).setchan)
        scan.loops(1).setchan = {scan.loops(1).setchan};
    end
    dvdisplay(col, sc, 'xlabel', 'string', [scan.loops(1).setchan{:}]);
end

if exist('yscale', 'var')
    dvfilter(col, sc, @times, '', yscale);
end
yl='Y';
for l=length(scan.loops):-1:1
    if(~isempty(scan.loops(l).getchan))
      yl = scan.loops(l).getchan(1);
    end
end
  dvdisplay(col, sc, 'ylabel', 'string', yl);
  


dvplot(col, sc);
