function sc = loadT2star3(file, col, frames, pulses, checkpulses)
%sc = loadT2star3(file, col, frames, pulses, checkpulses)
% display data, background and difference.

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global imagedata;

ind = imload(file);

if length(ind) == 1
    col = iminsert(ind, 1, 1, col);
else
    col = immultiinsert(ind, 1, 1, @(varargin)cat(2, varargin{:}));
end

sc = length(imagedata.collections{col}.images);

imcopy(col, [sc sc sc], col);

%ind = imagedata.collections{col}.images(sc).index;

if isempty(frames)
    frames = 1:find(isfinite(imagedata.cache{ind}.scans.forward(end, end, :)), 1, 'last');
end

[imagedata.collections{col}.images(sc+(0:3)).channel] = deal(frames);


if nargin < 5
    checkpulses = [];
end

imfilter(col, sc, @imfT2star3, {[checkpulses(1, :), pulses(1, :)], [checkpulses(2, :), pulses(2, :)]});
imfilter(col, sc+1, @imfT2star, {[checkpulses(1, :), pulses(1, :)], [checkpulses(2, :), pulses(2, :)]});

imdisplay(col, sc + (0:3), 'axis');
imdisplay(col, sc + [0 1], 'yline');
imdisplay(col, sc + (0:3), 'filename');
imdisplay(col, sc + 3, 'title', 'string', 'Reference');
imdisplay(col, sc + 1, 'title', 'string', 'Data - reference');
imdisplay(col, sc + [2 3], 'noim');

if 1
    %dt = [0 0e-3:1e-3:10e-3 12e-3 15e-3:3e-3:21e-3 25e-3:5e-3:50e-3, .06:.01:.1 .12:.02:.2 .23:.03:.5 .55:.05:1]*1e3;
    dt = [0 0e-3:1e-3:20e-3 22e-3:2e-3:30e-3 35e-3:5e-3:50e-3, .06:.01:.1 .12:.02:.2 .23:.03:.5 .55:.05:1]*1e3;
    %dt = [0 0:1:100];
    imdisplay(col, sc + [0 1], 'data', 'XData', [(-size(checkpulses, 2):-1)*.03 * dt(size(pulses, 2)), dt(1:size(pulses, 2))],  'Marker', '.');
else
    imdisplay(col, sc  + [0 1], 'data', 'XData', pulses, 'Marker', '.', 'LineStyle', 'None');
end

imdisplay(col, sc  + [0 1], 'imaxes', 'xlim', [(-size(checkpulses, 2)-1)*.03, 1.05]*dt(size(pulses, 2)));


imdisplay(col, sc+[2 3], 'data', 'XData', [-size(checkpulses, 2), size(pulses, 2)-1], ...
    'YData', frames([1 end]));
%'YData', [1, length(frames)]);
imdisplay(col, sc+[2 3], 'imaxes', 'xlim', [-size(checkpulses, 2), size(pulses, 2)]-.5, ...
    'ylim', [frames(1)-.5, frames(end)+.5], 'ydir', 'reverse');
%'ylim', [0, length(frames)]+.5, 'ydir', 'reverse');

imfilter(col, sc+ 2, @imfT2star2, {[checkpulses(1, :), pulses(1, :)]});
imfilter(col, sc+ 3, @imfT2star2, {[checkpulses(2, :), pulses(2, :)]});
