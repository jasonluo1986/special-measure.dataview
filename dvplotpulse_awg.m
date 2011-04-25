function dvplotpulse(col, dataset, pulsetab, scale, offset, disp)
% dvplotpulse(col, dataset, pulsetab, scale, offset, disp)
% plot pulse on top of a dataset. Permanent if disp == 'disp' given.

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
    
dvplot(col, dataset);

hold on;
plot(pulsetab(2, :) * scale(1) + offset(1), pulsetab(3, :) * scale(2) + offset(2), '.-k');
hold off;

if nargin >= 6 && ~isempty(strfind(disp, 'disp'))
    go = dvdisplay(col, dataset, 'line', 'Xdata',  pulsetab(2, :) * scale(1) + offset(1), ...
        'YData', pulsetab(3, :) * scale(2) + offset(2), 'Color', 'k', 'Marker', '.', ...
        'LineStyle', '-');
end
