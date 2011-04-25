% Creates a line plot of a gate sweep
% input(file name, colection, S-D bias through the dot), If bias is given
% plot is conductance (in untis of G/G_0) vs gate voltage.  If no bias is
% given the y-axis will display lockin current

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.

function sc = loadgate(file, col, vbias)

global dvdata;


col = dvinsert(file, col);
sc = length(dvdata.collections{col}.datasets);

%setpardisp(col, [sc sc+1], 4:7);
%dvdisplay(col, sc+1, 'xline');

%dvdisplay(col, sc+1, 'imaxes', 'xlim', rng, 'Fontsize', 6);

%r = imgetregion(col, sc+1, 1);
load(file, 'scan');
dvdisplay(col, sc, 'filename');
dvdisplay(col, sc, 'xlabel', 'string', scan.loops.setchan);

if nargin >= 3
    dvfilter(col, sc, @times, '', 25.8e3/vbias);
    dvdisplay(col, sc, 'ylabel', 'string', 'G/G_0');

else
    dvdisplay(col, sc, 'ylabel', 'string', 'Lockin Current');
end

dvplot(col, sc);
