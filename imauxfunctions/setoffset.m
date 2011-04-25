function setoffset(collection, images, inc, off)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


if nargin < 4;
    off = 0;
end
for i = 1:length(images);
    imfiltargs(collection, images(i), @scale);
    imfilter(collection, images(i), @scale, {1, (i-1)*inc+off});
end

