function sc = loadplsgrp2(file, col, frames, infrep,channel)
% sc = loadplsgrp2(file, col, frames, infrep)
% refpulses not tested

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global dvdata;
global awgdata;


if nargin < 3
    frames = [];
end

if nargin < 4 
    infrep = false;
end

load(file, 'scan', 'data');
if(~exist('channel','var') || isempty(channel))
    channel=1:length(data);
end

for r=channel
    if(strcmp(scan.loops(1).getchan(r),'Time'))
        continue;
    end
    sz = size(data{r});
    
    % hack to remove buffer pulses
    for i=1:length(scan.data.pulsegroups)
        if scan.data.pulsegroups(i).npulse == 2 * scan.data.pulsegroups(1).npulse
            scan.data.pulsegroups(i).pulses(1:2:end) = [];
        end
    end
    
    if isfield(scan.data, 'pulsegroups') && length([scan.data.pulsegroups.pulses]) > 1 && ~infrep
        tmp=[scan.data.pulsegroups.pulses];
        dt = awgdata.xval(tmp(1,:));                
        dt(isnan(dt)) = -1;        
    else
        dt = repmat(1:sz(end), 1, infrep);
    end
    
    col = dvinsert(file, col,[],r);
    sc = length(dvdata.collections{col}.datasets);
    
    if length(sz) == 3
        dvfilter(col, sc, @permute, '', [3 2 1]);
        dvfilter(col, sc, @reshape, '', sz(2)* sz(3), sz(1));
        dvfilter(col, sc, @transpose);
    end
    
    dvfilter(col, sc, @dvfpermute, 'y', (1:sz(1))', 2);
    
    if nargin < 3 || isempty(frames)
        dvfilter(col, sc, @dvfcutnan, 'all');
    else
        dvfilter(col, sc, @dvfselect, '', {frames});
        dvfilter(col, sc, @dvfselect, 'y', {frames});
    end
    
    
    npls = length(dt);
    if length(sz) == 3
        nshift = max(1, sz(2)/length(scan.data.pulsegroups));
    else
        nshift = 1;
    end
    
    if nshift > 1
        if 0&& nargin >=3 && ~isempty(refgrp)
            mask = true(1, npls*nshift);
            mask((1:npls) + (refgrp-1)*npls) = 0;
            offset(2) = offset(2) - offset(1) * length(scan.data.pulsegroups);
            data = data(:, mask) - repmat(data(:, ~mask), 1, nshift-1) + ...
                repmat(reshape(repmat(offset(2)*(0:nshift-2 ), npls, 1), 1, npls*(nshift-1)), size(data, 1), 1);
            dt = repmat(dt, 1, nshift-1);
        else
            dt = repmat(dt, 1, nshift);
        end
    end
    
    brk = [0 find(dt(2:end) < dt(1:end-1))];
    brk(end+1) = length(dt);
    c = 'rgbcmyk';
    
    ncrv = length(brk)-1;
    
    for i = 1:ncrv
        rng = brk(i)+1:brk(i+1);
        
        dvcopy(col, sc, col);
        dvfilter(col, sc+i, @dvfselect, '', {rng, ':'});
        dvfilter(col, sc+i, @mean, '', 1);
        
        dvfilter(col, sc+i, @dvfpermute, 'x', dt(rng), 2);
        %dvfilter(col, sc+i, @(x)dt, 'x');
        
        dvdisplay(col, sc+i, 'data', 'Marker', '.', 'color', c(mod(i-1, end)+1));
        %dvdisplay(col, sc+i, 'imaxes', 'xlim', [1.05, -.05 ;-.05, 1.05]*[min(dt); max(dt)]);
        
    end
    
    %[dvdata.collections{col}.datasets(sc+(2:ncrv)).nfigs] = deal(0);
    if ncrv > 1
        dvdisplay(col, sc + (2:ncrv), 'prevax');
    end
    
    dvdisplay(col, sc, 'color');
    
    
    dvdisplay(col, sc + (0:ncrv), 'filename');
    dvdisplay(col, sc + (1:ncrv), 'xlabel', 'string', 'x_{pls}');
    
    dvdisplay(col, sc, 'axes', 'ydir', 'reverse');
    dvdisplay(col, sc, 'ylabel', 'string', 'sweep #');
    
    dvplot(col, sc+(0:ncrv));
    
    sc = sc + (0:ncrv);
end
