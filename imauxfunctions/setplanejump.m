function setplanejump(collection, images)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.



fprintf('Define plane subtraction region\n');
rp = imgetregion(collection, images(1), 1);

fprintf('Define dejump regions\n');
rd = imgetregion(collection, images(1), 2);

fprintf('Define median subtraction region\n');
rm = imgetregion(collection, images(1), 1);

imfilter(collection, images); 
if ~isempty(rp)
    imfilter(collection, images, @imfplanesub, {rp});
end

if ~isempty(rd)
    imfilter(collection, images, @imfdejump2, {rd});
end

if ~isempty(rm)
    imfilter(collection, images, @imfmediansub, {rm});
end

