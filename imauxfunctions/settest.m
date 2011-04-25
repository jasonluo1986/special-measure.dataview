function settest(collection, images)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.



imfilter(3, []); 
imfilter(3, [], @planesubtract, {[200, 1, 311, 40]})
imfilter(3, [], @fliplr);  
imfilter(3, [], @diff, {[], 2}); 
imfilter(3, [], @cumsum, {2});
imfilter(3, [], @fliplr);  

