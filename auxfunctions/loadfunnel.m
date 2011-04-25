function sc = loadfunnel(file, col)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global awgdata;

[sc, col] = load2D(file, col, 1);

dvdisplay(col, sc, 'imax', 0);
dvdisplay(col, sc, 'colbar', 0);
dvfilter(col, sc, @medianlinesubtract, '', 2)

load(file, 'scan');

if isfield(scan.data, 'pulsegroups') && length([scan.data.pulsegroups.pulses]) > 1 
    x = awgdata.xval([scan.data.pulsegroups.pulses]);
    x(1) = 2 * x(2) - x(3); 
    dvfilter(col, sc, @dvfpermute, 'x', x, 2);
    dvdisplay(col, sc, 'xlabel', 'string', '\epsilon-\epsilon_M (\muV)');

else
    dvdisplay(col, sc, 'xlabel', 'string', 'pulse');
end

if length(scan.loops) == 1
    dvfilter(col, sc, @dvfpermute, 'y', scan.loops(1).rng, 2);
end
    
dvdisplay(col, sc, 'ylabel', 'string', 'B (T)');

dvplot(col, sc);
