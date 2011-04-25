function sc = loadpat(file, col, ctrl)
% sc = loadpat(file, col, ctrl)
% ctrl: x, y, (flags), forces filters applied (see code)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.



[sc, col] = load2D(file, col, 1);

dvdisplay(col, sc, 'imax', 0);
dvdisplay(col, sc, 'colbar', 0);


load(file, 'scan');


if isempty(scan.loops(1).setchan)
    dvdisplay(col, sc, 'xlabel', 'string', 'f (Hz)');
    if nargin < 3 
        dvfilter(col, sc, getfilterX);
    end
elseif nargin < 3 
    dvfilter(col, sc, getfilterY);
end

if nargin >= 3
    if ~isempty(strfind(ctrl, 'x'))
        dvfilter(col, sc, getfilterX);
    end
        
    if ~isempty(strfind(ctrl, 'y'))
        dvfilter(col, sc, getfilterY);
    end
end


dvplot(col, sc);


function f = getfilterX
f = @(d)d-repmat(mean(d, 1), size(d, 1), 1);

function f = getfilterY
f = @(d)d-repmat(mean(d, 2), 1, size(d, 2));
