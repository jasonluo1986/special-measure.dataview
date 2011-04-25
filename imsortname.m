function imsortname(col)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global imagedata;

ind = [imagedata.collections{col}.images.index];
filenames = cell(size(ind));
filenum = zeros(size(ind));

for i = 1:length(ind)
    filenames{i} = imagedata.cache{ind(i)}.filename;
    filenum(i) = sscanf(imagedata.cache{ind(i)}.filename(end-3:end), '%i');
end

%[s, si] = sort(filenames);
[s, si] = sort(filenum);

imagedata.collections{col}.images = imagedata.collections{col}.images(si);
