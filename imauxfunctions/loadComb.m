function sc = loadComb(files, col, pulses, frames)
%sc = loadT2star4(file, col, pulses, frames, refpulses)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global imagedata;
%global awgdata;



if ischar(files)
    files = cellstr(files);
end


for i = 1:length(files)
    if iscell(files)
        file = files{i};
    else
        file = sprintf('sm_comb_%d', files(i));
    end
    
    ind = imload(file);
    
    if nargin < 4 || isempty(frames)
        frames = 1:find(isfinite(imagedata.cache{ind}.scans.forward(end, end, :)), 1, 'last');
    end

    if nargin < 3 || isempty(pulses)
        pulses = 1:size(imagedata.cache{ind}.scans.forward, 1)/2;
    end

    sc = loadT2star4(file, col, pulses*2, frames);
    imremove(col, sc+1);

    iminsert(ind, 1, 1, col, [], frames);

    %setpardisp(col, [sc sc+1], 1:4);
    imdisplay(col, sc+1, 'filename');
    imdisplay(col, sc+1, 'axis');
    imdisplay(col, sc+1, 'noim');


    ind = imagedata.collections{col}.images(sc).index;
    rng = imagedata.cache{ind}.range(1) * [-.5, .5] + imagedata.cache{ind}.shift(1);

    imfilter(col, sc+1, @imfCombFun);

    %r = imgetregion(col, sc+1, 1);
    r = [round([.7, .9]*size(imagedata.cache{ind}.scans.forward, 2)) 1, length(frames)];
    imfilter(col, sc+1, @imfdejump2, {r});
    imfilter(col, sc+1, @imfplanesub, {r});
    %imdisplay(col, sc, 'colscale', [-.3e-6, 1.5e-6]);

    imdisplay(col, sc+1, 'data', 'YData', frames);
    imdisplay(col, sc+1, 'imaxes',  'ylim', [frames(1)-.5, frames(end)+.5], 'ydir', 'reverse');
    
        
%     imdisplay(col, sc+1, 'data', 'YData', sort(imagedata.cache{ind}.params.scan.loops(3).rng([1, end])));
%     if diff(imagedata.cache{ind}.params.scan.loops(3).rng([1, end])) > 0
%         imdisplay(col, sc+1, 'imaxes',  'ylim', imagedata.cache{ind}.params.scan.loops(3).rng([1, end]), 'ydir', 'reverse');
%     else
%         imdisplay(col, sc+1, 'imaxes',  'ylim', imagedata.cache{ind}.params.scan.loops(3).rng([end, 1]));
%     end
    %r = imgetregion(col, sc+1, 1);
    implot(col, [sc sc+1]);


end
