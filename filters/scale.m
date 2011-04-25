function data = scale(data, factor, offset, xrng, yrng)
% function data = scale(data, factor, offset, xrng, yrng)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.

if nargin < 3
    offset = 0;
end

if nargin < 4
    xrng = 1:size(data, 2);
    yrng = 1:size(data, 1);
end

data(yrng, xrng) = data(yrng, xrng) * factor + offset;
