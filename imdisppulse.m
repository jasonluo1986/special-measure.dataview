function go = imdisppulse(col, dataset, pulsetab, scale, offset)
% imdisppulse(col, dataset, pulsetab, scale, offset);
% add pulse to graphobjects.

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.



if isstruct(pulsetab)
    pulsetab = pulsetab.pulsetab;
elseif length(pulsetab) == 1
    pulsetab = awggetpulseinf(pulsetab);
    pulsetab = pulsetab.pulsetab;
end

if length(scale) == 1;
    scale = [scale, scale];
end
    
go = imdisplay(col, dataset, 'line', 'Xdata',  pulsetab(2, :) * scale(1) + offset(1), ...
    'YData', pulsetab(3, :) * scale(2) + offset(2), 'Color', 'k', 'Marker', '.', ...
    'LineStyle', '-');
