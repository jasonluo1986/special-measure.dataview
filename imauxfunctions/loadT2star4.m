function sc = loadT2star4(file, col, pulses, frames, refpulses)
%sc = loadT2star4(file, col, pulses, frames, refpulses)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global imagedata;
global awgdata;

ind = imload(file);

if length(ind) == 1
    col = iminsert(ind, 1, 1, col);
else
    col = immultiinsert(ind, 1, 1, @(varargin)cat(2, varargin{:}));
end

sc = length(imagedata.collections{col}.images);


if nargin < 4 || isempty(frames)
    frames = 1:find(isfinite(imagedata.cache{ind}.scans.forward(end, end, :)), 1, 'last');
end

if nargin < 3 || isempty(pulses)
    pulses = 1:size(imagedata.cache{ind}.scans.forward, 1);
end

if nargin < 5 
    refpulses = 1;
end


scan = imagedata.cache{ind}.params.scan;

if isfield(scan, 'data') && isfield(scan.data, 'pulses')
    if max(pulses) > length(scan.data.pulses)
        dt = awgdata.xval(scan.data.pulses(pulses/2)); % hack for comb scan
    else
        dt = awgdata.xval(scan.data.pulses(pulses));
    end
    dt(isnan(dt)) = -1;
else
    dt = 1:length(pulses);
end

brk = [0 find(dt(2:end) < dt(1:end-1))];
brk(end+1) = length(dt);
c = 'rgbcmyk';

ncrv = length(brk)-1;
for i = 1:ncrv
    rng = brk(i)+1:brk(i+1);    
    imcopy(col, sc, col);
    if length(refpulses) < length(pulses)
        imfilter(col, sc+i, @imfT2star, {pulses(rng), refpulses(min(i, end))});
    else
        imfilter(col, sc+i, @imfT2star, {pulses(rng), refpulses(rng)});
    end
    imdisplay(col, sc+i, 'data', 'XData', dt(rng),  'Marker', '.', 'color', c(mod(i-1, 7)+1));    
    imdisplay(col, sc+i, 'imaxes', 'xlim', [1.05, -.05 ;-.05, 1.05]*[min(dt); max(dt)]);

    %plot(dt(rng), m2(rng)-r2(rng)+i*0e-7, ['.-', c(mod(i-1, 7)+1)]);
end
[imagedata.collections{col}.images(sc+(0:ncrv)).channel] = deal(frames);


imdisplay(col, sc + (0:ncrv), 'axis');
imdisplay(col, sc + (1:ncrv), 'yline');
imdisplay(col, sc + (0:ncrv), 'filename');
if ncrv >= 2
    imdisplay(col, sc + (2:ncrv), 'prevax');
end
imdisplay(col, sc, 'noim');


% color plot
imdisplay(col, sc, 'data', 'XData', [0, length(pulses)-1], ...
    'YData', frames);
%'YData', [1, length(frames)]);
imdisplay(col, sc, 'imaxes', 'xlim', [0, length(pulses)]-.5, ...
        'ylim', [frames(1)-.5, frames(end)+.5], 'ydir', 'reverse');
   % 'ylim', [0, length(frames)]+.5, 'ydir', 'reverse');
if 0 && nargin >= 5
    imfilter(col, sc, @imfT2star2, {pulses, refpulses});
else
    imfilter(col, sc, @imfT2star2, {pulses});
end

