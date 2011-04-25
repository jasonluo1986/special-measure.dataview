function sc = loadphase(file, col)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global imagedata;


col = iminsert(file, 1, 1, col);
iminsert(file, 1, 1, col);
sc = length(imagedata.collections{col}.images)-1;

imdisplay(col, sc+1, 'xline');
imdisplay(col, sc, 'noim');
imdisplay(col, sc+(0:1), 'axis');
imdisplay(col, sc+(0:1), 'filename');

implot(col, [sc sc+1]);
