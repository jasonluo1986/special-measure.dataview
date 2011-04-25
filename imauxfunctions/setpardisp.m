function setpardisp(col, scans, dispch)
% setpardisp(col, scans, dispch)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global imagedata;

for i = 1:length(scans)
    ind = imagedata.collections{col}.images(scans(i)).index;
    params = imagedata.cache{ind}.params;
    chanvals = [params.configch(dispch); num2cell(params.configvals(dispch))];

    str = strvcat(imagedata.cache{ind}.filename, sprintf('%s = %.3g, ', chanvals{:}));
    imdisplay(col, scans(i), 'title', 'String', str, 'fontsize', 6);
end
imdisplay(col, scans, 'filename');
imdisplay(col, scans, 'axis');
imdisplay(col, scans, 'imaxes', 'fontsize', 6);
