function sc = loaddbl(file, col)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global imagedata;


col = iminsert(file, 1, 1:2, col);
sc = length(imagedata.collections{col}.images)-1;

imdisplay(col, sc+1, 'colbar');
setpardisp(col, [sc sc+1], 4:7);

r = imgetregion(col, sc, 1);
imfilter(col, sc, @imfplanesub, {r});

d = implot(col, sc);
%r = imgetregion(col, sc+1, 1);
r = find(any(isnan(d.data), 2), 1);
if ~ isempty(r)
    r = [1, size(d.data, 2), 1, r-1];
    imfilter(col, sc+1, @imfmediansub, {r});
else
    imfilter(col, sc+1, @imfmediansub);
end


implot(col, sc+1);
