function inds = makefits(col, fit, ds, nds,dso)
% function inds = makefits(col, fit, ds, nds)
% col - collection to put fits in
% fit - fit structure as per dvplotfit
% ds, nds; indexes and counts of fits to plot.
% dso; offset for colormap

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global dvdata;

srccol = dvcolind(fit.col);
inds = zeros(1, length(ds));
if ~exist('dso','var')
    dso=0;
end
c = 'rgbcmyk';

for i = 1:length(ds)
    fit.ds = ds(i)+(0:nds(min(i, end))-1);
    fit.name = dvdata.collections{srccol}.datasets(ds(i)).file{1};
    fit.name = regexprep(fit.name,'^(sm_)*','');
    fit.name = regexprep(fit.name,'.mat$','');
    [col, inds(i)] = dvinsert(fit, col, [], [], 'fit');
    dvdisplay(col, inds(i), 'data', 'color', c(mod(dso+i-1, end)+1), 'marker', '.');
    %load(fit.name, 'scan')
    %awgdata.pulsedata().xval(?)
end

dvdisplay(col, inds(end), 'legend', 'interpreter', 'none');

if length(inds) >=2
    dvdisplay(col, inds(2:end), 'prevax');
end
