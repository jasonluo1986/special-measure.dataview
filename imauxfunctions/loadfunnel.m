function sc = loadfunnel(file, col, scan)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global imagedata;

if nargin < 3
    scan = 1;
end
    
if scan == 0;
    scan = 1;
    ch = 0;
else
    ch = 1;
end

col = iminsert(file, 1, ch, col, [], scan);
iminsert(file, 1, ch, col, [], scan);
sc = length(imagedata.collections{col}.images)-1;

%setpardisp(col, [sc sc+1], 1:4);
imdisplay(col, sc+[0 1], 'filename');
imdisplay(col, sc+1, 'xline');
imdisplay(col, sc+[0 1], 'axis');
imdisplay(col, sc, 'noim');


ind = imagedata.collections{col}.images(sc).index;
rng = abs(imagedata.cache{ind}.range(1)) * [-.5, .5] + imagedata.cache{ind}.shift(1);
%imdisplay(col, sc+1, 'imaxes', 'xlim', rng, 'Fontsize', 6, 'ylim', [-.3, 1.5]*1e-3);
imdisplay(col, sc+1, 'imaxes', 'xlim', rng, 'Fontsize', 6);

r = imgetregion(col, sc, 1);
imfilter(col, [sc, sc+1], @imfdejump2, {r});
imfilter(col, [sc, sc+1], @imfplanesub, {r});
%imdisplay(col, sc, 'colscale', [-.3, 1.5]*1e-3);

%r = imgetregion(col, sc+1, 1);

implot(col, [sc sc+1]);
