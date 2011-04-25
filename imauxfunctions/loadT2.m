function sc = loadT2(file, col, ndiff, nJ, nevol, offset, frames)
% sc = loadT2(file, col, ndiff, nJ, nevol, offset, frames)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


if nargin < 7
    frames = [];
end

[a, b] = ndgrid(1:ndiff, 0:nJ-1);
p = (a + nevol*ndiff* b);

for i = 0:nevol-1;
    sc(i+1) = loadT2star4(file, col, p(:)+i*ndiff, frames, p(round(ndiff/2):ndiff:end)+i*11);
    
    if nargin >=6
        setoffset(col, sc(i+1)+(1:nJ), offset);
    end
end
