function sc = loadgate2(file, col, cal, xlab)
%sc = loadgate2(file, col, cal, xlab)
% Creates a line plot of a gate sweep
% If cal is given, plot is conductance (in untis of G/G_0) vs gate voltage. 
% cal = [V_bias x Rsense, R_series];
% Otherwise, no transformation is performed

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global dvdata;


col = dvinsert(file, col);
sc = length(dvdata.collections{col}.datasets);

dvdisplay(col, sc, 'filename');

if nargin < 4
    load(file, 'scan');
    dvdisplay(col, sc, 'xlabel', 'string', scan.loops.setchan);
else
    dvdisplay(col, sc, 'xlabel', 'string', xlab);
end
    
G0 = 7.75e-5;

if nargin >= 3 && ~isempty(cal)
    
    %I = Vsense/Rsense
    % R = Vbias/I - Rseries = Vbias * Rsens /Vsense - Rseries
    % G/G0 = ((Vsense/(Rsens*vbias * G0))^-1 - Rseries * G0)^-1
    dvfilter(col, sc, @times, '', 1/(cal(1) * G0));
    if length(cal) >=2    
        dvfilter(col, sc, @power, '', -1);
        dvfilter(col, sc, @minus, '', cal(2)*G0);
        dvfilter(col, sc, @power, '', -1);       
    end    
    dvdisplay(col, sc, 'ylabel', 'string', 'G/G_0');

else
    dvdisplay(col, sc, 'ylabel', 'string', 'Lockin voltage');
end

dvplot(col, sc);
