function groupT2star(col, ds)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.



global imagedata;



inds = 1:length(imagedata.collections{col}.images);
for i = ds(2:end);
    inds(inds == i) = [];
end
 
i = find(inds==ds(1));
inds = [inds(1:i-1), ds, inds(i+1:end)];

imagedata.collections{col}.images = imagedata.collections{col}.images(inds);

c = 'rgbcmyk';

ds = ds(1) + (0:length(ds)-1);
rng = nan(1, 2);
for i = 1:length(ds)
    imsetgraphprop(col, ds(i), 'data', 'color', c(mod(i-1, length(c))+1));
    xdata = imsetgraphprop(col, ds(i), 'data', 'XData');
    if ~isempty(xdata);
        rng = [min(rng(1), min(xdata)) , max(rng(2), max(xdata))];
    end
end
imsetgraphprop(col, ds(i), 'imaxes', 'xlim', rng * [1.05 -.05; -.05, 1.05]);

imdisplay(col, ds, 'prevax');
imdisplay(col, ds(1), 'prevax', 0);

imdisplay(col, ds, 'filename', 0);
