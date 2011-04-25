function dvplotpulse(col, dataset, pulse, scale, offset, disp)
% dvplotpulse(col, dataset, pulsetab, scale, offset, disp)
% plot pulse on top of a dataset. Permanent if disp == 'disp' given.

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


if length(scale) == 1;
    scale = [scale, scale];
end


if isstruct(pulse) && isfield(pulse, 'pulses') % convert from group
    pulse = pulse.pulses(1);
end
    
if isstruct(pulse) && strcmp(pulse.format, 'wf')
    pulsetab = pulse.data.wf;
else
    pulse = plstotab(pulse);
    pulsetab = pulse.data.pulsetab(2:3, :);
end

if nargin < 6 || isempty(strfind(disp, 'over'))
    dvplot(col, dataset);
end

hold on;

plot(pulsetab(1, :) * scale(1) + offset(1), pulsetab(2, :) * scale(2) + offset(2), '.-k');
hold off;

if nargin >= 6 && ~isempty(strfind(disp, 'disp'))
    dvdisplay(col, dataset, 'line', 'Xdata',  pulsetab(2, :) * scale(1) + offset(1), ...
        'YData', pulsetab(3, :) * scale(2) + offset(2), 'Color', 'k', 'Marker', '.', ...
        'LineStyle', '-');
end
