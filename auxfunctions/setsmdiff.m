function setsmdiff(col, ds)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.



%imfilter(collection, images);
dvfilter(col, ds, @diff, '', [], 2);
dvdisplay(col, ds, 'colbar', [], 0);
dvplot(col, ds);

%imdisplay(collection, images, 'axis');
