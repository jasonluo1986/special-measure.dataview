function setdiffint(collection, images)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.



imfilter(collection, images); 
%imfilter(collection, images, @planesubtract, {[200, 1, 311, 40]})
imfilter(collection, images, @fliplr);  
imfilter(collection, images, @diff, {[], 2}); 
imfilter(collection, images, @medianlinesubtract, {2}); 
imfilter(collection, images, @cumsum, {2});
imfilter(collection, images, @fliplr);  

