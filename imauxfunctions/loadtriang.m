function sc = loadtriang(file, col)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global imagedata;


col = iminsert(file, 1, 1, col);
iminsert(file, 1, 1, col);
sc = length(imagedata.collections{col}.images)-1;

setpardisp(col, [sc sc+1], 4:7);
imdisplay(col, sc+1, 'xline');
imdisplay(col, sc+1, 'axis');
ind = imagedata.collections{col}.images(sc).index;
rng = imagedata.cache{ind}.range(1) * [-.5, .5] + imagedata.cache{ind}.shift(1);
imdisplay(col, sc+1, 'imaxes', 'xlim', rng, 'Fontsize', 6);

r = imgetregion(col, sc, 1);
imfilter(col, [sc, sc+1], @imfplanesub, {r});

%r = imgetregion(col, sc+1, 1);

implot(col, [sc sc+1]);
