function sc = loadplsgrp(file, col, frames, pulses, refpulses)
% sc = loadplsgrp(file, col, frames, pulses, refpulses)
% refpulses not tested

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global imagedata;
global awgdata;

if ischar(file)
    ind = imload(file);
else
    ind = file;
end

col = iminsert(ind, 1, 1, col);
sc = length(imagedata.collections{col}.images);


if nargin < 3
    frames = [];
end

sz = size(imagedata.cache{ind}.scans(1).forward);

scan = imagedata.cache{ind}.params.scan;

if nargin < 4
    pulses = [];
end

if length(sz) == 3    
    %data = reshape(permute(data, [3 2 1]), size(data, 2) * size(data, 3), size(data, 1))';
    %data =  mean(mean(data(pulse, cut:end, :), 3), 2);

    if isempty(frames)
        frames = 1:find(isfinite(imagedata.cache{ind}.scans(1).forward(end, end, :)), 1, 'last');
    end
    imagedata.collections{col}.images(sc).channel = frames;
    imfilter(col, sc, @permute, {[2 1 3]});

    if length(scan.data.pulsegroups) ~= sz(1)
        imfilter(col, sc, @reshape, {sz(2), sz(1) * length(frames)});
    else
        imfilter(col, sc, @reshape, {sz(1) * sz(2), length(frames)});
    end
    
    imfilter(col, sc, @transpose, {});

    if ~isempty(pulses)
        s.subs = {':', pulses};
        s.type = '()';
        imfilter(col, sc, @subsref, {s});
    end

else
    lastframe = find(~isfinite(imagedata.cache{ind}.scans(1).forward(:, end)), 1);    
    % set frames if given or not all valid
    if  ~isempty(frames) || ~isempty(lastframe)
        if isempty(frames)
            frames = 1:lastframe-1;
        end
        s.type = '()';
        if isempty(pulses)
            s.subs = {frames, ':'};
        else
            s.subs = {frames, pulses};
        end
        imfilter(col, sc, @subsref, {s});
    else
        frames = 1:sz(1);
    end

end
    
if isempty(pulses)
    pulses = 1:sum([scan.data.pulsegroups.npulse]);
end

if nargin < 5 
    refpulses = 1;
end


dt = awgdata.xval([scan.data.pulsegroups.pulses]);
dt(isnan(dt)) = -1;

if 0%%length(dt) == 2 * sz(2);
    dt = dt(2:2:end);
end
if 0%length(pulses) == 2 * sz(2);
    pulses = pulses(2:2:end)/2;
end

if length(pulses) >  3 * prod(sz(2:end));
    pulses = pulses(1:3:3*sz(2));
end

dt = dt(pulses);

brk = [0 find(dt(2:end) < dt(1:end-1))];
brk(end+1) = length(dt);
c = 'rgbcmyk';


ncrv = length(brk)-1;
for i = 1:ncrv
    rng = brk(i)+1:brk(i+1);    
    
    imcopy(col, sc, col);
    
    if length(refpulses) < length(pulses)
        imfilter(col, sc+i, @imfT2star, {rng, refpulses(min(i, end))});
    else
        imfilter(col, sc+i, @imfT2star, {rng, refpulses(rng)});
    end
    imdisplay(col, sc+i, 'data', 'XData', dt(rng),  'Marker', '.', 'color', c(mod(i-1, 7)+1));    
    imdisplay(col, sc+i, 'imaxes', 'xlim', [1.05, -.05 ;-.05, 1.05]*[min(dt); max(dt)]);

    %plot(dt(rng), m2(rng)-r2(rng)+i*0e-7, ['.-', c(mod(i-1, 7)+1)]);
end
%[imagedata.collections{col}.images(sc+(0:ncrv)).channel] = deal(frames);


imdisplay(col, sc + (0:ncrv), 'axis');
imdisplay(col, sc + (1:ncrv), 'yline');
imdisplay(col, sc + (0:ncrv), 'filename');
imdisplay(col, sc + (1:ncrv), 'xlabel', 'string', '\tau_S (ns)');

if ncrv >= 2
    imdisplay(col, sc + (2:ncrv), 'prevax');
end
imdisplay(col, sc, 'noim');

if length(scan.data.pulsegroups) ~= sz(1) && length(sz)==3
    frames = [1 frames(end) * sz(1)];
end
% color plot
imdisplay(col, sc, 'data', 'XData', [0, length(pulses)-1], ...
    'YData', frames);
%'YData', [1, length(frames)]);
imdisplay(col, sc, 'imaxes', 'xlim', [0, length(pulses)]-.5, ...
        'ylim', [frames(1)-.5, frames(end)+.5], 'ydir', 'reverse');
imdisplay(col, sc, 'ylabel', 'string', 'sweep #');
