function sc = loadT1incomplete(col, file)
% anaT1(file, n)
% n: number of reps in same place. Only needed for early data files.

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global dvdata;
global awgdata;

load(file, 'data', 'scan');


data = data{1};
sz = size(data);


if isfield(scan, 'data') && isfield(scan.data, 'pulsegroups')
    ngrp = length(scan.data.pulsegroups);
    tau = awgdata.xval([scan.data.pulsegroups.pulses]);
else % not sure this makes sense
    ngrp = 1;
    tau = 1:sz(3);
end

sz2 = [sz(1)* sz(2)/ngrp, sz(3)*ngrp, sz(4)];

nshift = ??. Store in data, get from trafofn, or add a loop, or add to loops group




col = dvinsert(file, col);
sc = length(dvdata.collections{col}.datasets);


dvfilter(col, sc, @permute, '', [2 1 3 4]);
dvfilter(col, sc, @reshape, '', [ngrp, sz(2)/ngrp, sz([1 3 4])]);
dvfilter(col, sc, @permute, '', [2 3 4 1 5]);
dvfilter(col, sc, @reshape, '', sz2);

% data matrix indices: outer rep, inner rep(slow) * grp(fast), pls, time
% permute -> inner rep(slow) * grp(fast), outer rep, pls, time
% reshape -> grp, inner rep, outer rep, pls, time
% permute -> inner rep, outer rep, pls grp, time
% reshape -> rep, grp * pls, time

% change last reshape to separate mshifts.
% somehopw subtract bg.

dvcopy(col, [sc, sc], col);

dvfilter(col, sc+(0:1), @reshape, '', ??);
dvfilter(col, sc+(0:1), @diff, '', [], ?);

dvfilter(col, sc+(0:1), @mean, '', 1);
dvfilter(col, sc+(0:1), @permute, '', [3 2 1]);



dvfilter(col, sc+1, @mean, '', 1);

x = (1:sz2(3))/scan.data.samprate * 1e6;
mask = logical(mod(floor((0:sz2(1)-1)./abs(n)), 2));
y = permute(mean(data(~mask, :, :), 1), [ 3 2 1]);
ref = permute(mean(data(mask, :, :), 1), [ 3 2 1]);

mask2 = x>1;
y2  = mean(data(~mask, :, mask2), 3);
ref2  = mean(data(mask, :, mask2), 3);

figure(45);
if n < 0
    subplot(221)
    plot(x, y+3e-3, x, ref);

    subplot(222)
    plot(tau, mean(y, 1), tau, mean(ref, 1));

    subplot(223)
    imagesc(y2)
else
    subplot(221)
    plot(x, y-ref);
    
    subplot(222)
    plot(tau, mean(y-ref, 1));
    
    subplot(223)
    imagesc(y2-ref2)
end
