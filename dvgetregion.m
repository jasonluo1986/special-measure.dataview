function regs = dvgetregion(collection, dataset, n)
% function regs = dvgetregion(collection, dataset, n)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


data = dvplot(collection, dataset);

if nargin >= 3
    points = ginput(2 * n);
else
    points = ginput;
end

npoints = 2 * floor(size(points, 1)/2);
points(npoints+1:end, :) = [];

npix = fliplr(size(data.data));

x = round(interp1(data.x([1, end]), [1, npix(1)], points(:, 1), 'linear', 'extrap'));
if diff(data.y) ~= 0 
    y = round(interp1(data.y([1, end]), [1, npix(2)], points(:, 2), 'linear', 'extrap'));
else
    y = [1 npix(2)];
end
x = max(min(npix(1), x), 1);
y = max(min(npix(2), y), 1);

regs = [sort(reshape(x, 2, npoints/2))', sort(reshape(y, 2, npoints/2))'];
