function setsmdiff(collection, images)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.



imfilter(collection, images);
%imfilter(collection, images, @imfwindow, {[10, Inf;-Inf Inf]})
imfilter(collection, images, @diff, {[], 2})
imdisplay(collection, images, 'axis');
