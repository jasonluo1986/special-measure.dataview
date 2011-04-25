function sc = loadT2star2(file, col, pulses, frames, refpulses, checkpulses)
%sc = loadT2star(file, col, pulses, frames, refpulses, checkpulses)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global imagedata;

ind = imload(file);

if length(ind) == 1
    col = iminsert(ind, 1, 1, col);
else
    col = immultiinsert(ind, 1, 1, @(varargin)cat(2, varargin{:}));
end

sc = length(imagedata.collections{col}.images);

imcopy(col, sc, col);


%ind = imagedata.collections{col}.images(sc).index;

if nargin < 4 || isempty(frames)
    frames = 1:find(isfinite(imagedata.cache{ind}.scans.forward(end, end, :)), 1, 'last');
end

if isempty(pulses)
    pulses = 1:size(imagedata.cache{ind}.scans.forward, 1);
end

imagedata.collections{col}.images(sc).channel = frames;
imagedata.collections{col}.images(sc+1).channel = frames;

if nargin <6
    checkpulses = [];
end

if nargin >=5    
     imfilter(col, sc, @imfT2star, {[checkpulses, pulses], refpulses});
else
    imfilter(col, sc, @imfT2star, {[checkpulses, pulses]});
end

imdisplay(col, sc+[0 1], 'axis');
imdisplay(col, sc, 'yline');
imdisplay(col, sc + [0 1], 'filename');
imdisplay(col, sc + 1, 'noim');

if length(pulses)> 5 || ~isempty(checkpulses)
    %dt = [0 0e-3:1e-3:10e-3 12e-3 15e-3:3e-3:21e-3 25e-3:5e-3:50e-3, .06:.01:.1 .12:.02:.2 .23:.03:.5 .55:.05:1]*1e3;
    %dt = [0 0e-3:1e-3:20e-3 22e-3:2e-3:30e-3 35e-3:5e-3:50e-3, .06:.01:.1 .12:.02:.2 .23:.03:.5 .55:.05:1]*1e3;
    %dt = [0 0e-3:1e-3:20e-3 22e-3:2e-3:30e-3];
  dt = [0 0e-3:1e-3:30e-3 35e-3:5e-3:50e-3, .06:.01:.1 .12:.02:.2 .23:.03:.5 .55:.05:1]*1e3;
    %dt = repmat(dt, 1, 3); % add another 0 to in front of dt for ref pulse
    %dt = [0 0:1:100];
    
    imdisplay(col, sc, 'data', 'XData', [(-length(checkpulses):-1)*.03 * dt(length(pulses)), dt(1:length(pulses))],  'Marker', '.');
else
    imdisplay(col, sc, 'data', 'XData', pulses, 'Marker', '.', 'LineStyle', 'None');
end

imdisplay(col, sc, 'imaxes', 'xlim', [(-length(checkpulses)-1)*.03, 1.05]*dt(length(pulses)));

imdisplay(col, sc+1, 'data', 'XData', [-length(checkpulses), length(pulses)-1], ...
    'YData', [1, length(frames)]);
imdisplay(col, sc+1, 'imaxes', 'xlim', [-length(checkpulses), length(pulses)]-.5, ...
    'ylim', [0, length(frames)]+.5, 'ydir', 'reverse');

imfilter(col, sc+1, @imfT2star2, {[checkpulses, pulses]});
