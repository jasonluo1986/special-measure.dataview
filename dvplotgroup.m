function dvplotgroup(col, dataset, group, numbers, scale, offset, disp)
% dvplotpulse(col, dataset, group, numbers, scale, offset, disp)
% plot pulse on top of a dataset. Permanent if disp == 'disp' given.

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


pd=plsmakegrp(group);
if(~exist('numbers','var') || isnan(numbers(1)))
    numbers=1:length(pd.pulses);
end
   
if length(scale) == 1;
    scale = [scale, scale];
end
    
dvplot(col, dataset);
colors='rgbcmyk';
hold on;
for i=numbers
  wf=pd.pulses(i).data.wf;
  plot(wf(1, :) * scale(1) + offset(1), wf(2, :) * scale(2) + offset(2), ['.-' colors(mod(i,length(colors))+1)] );
end
hold off;

if exist('disp','var') && ~isempty(strfind(disp, 'disp'))
    go = dvdisplay(col, dataset, 'line', 'Xdata',  pulsetab(2, :) * scale(1) + offset(1), ...
        'YData', pulsetab(3, :) * scale(2) + offset(2), 'Color', 'k', 'Marker', '.', ...
        'LineStyle', '-');
end
