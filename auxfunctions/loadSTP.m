function [sc, col] = loadSTP(file, col, ch)
% sc = load2D(file, col, ch, xyscale, zscale)
% Creates a line plot of an STP peak.

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.

if(~exist('ch','var'))
    ch=[];
end

global dvdata;

[col, sc] = dvinsert(file, col, [], ch);
dvdisplay(col, sc, 'filename');
dvfilter(col, sc, @(x) 1:100,'y');
dvdisplay(col,sc,'yline');
dvfilter(col, sc, @(x)mean(x,1));
dvplot(col, sc);
%sc = sc(1);
