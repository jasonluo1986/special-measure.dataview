function fp = dvfit(col, ds, ctrl, beta0, model, mask, rng)
%dvfit(col, ds, ctrl, beta0, model, mask, rng)
% ctrl: getp returns values, otherwise passed on to fitwrap.

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


if strfind(ctrl, 'getp')
   fits = dvgraphprop(col, ds, 'curve');
   fits = [fits.args];
   fits = [fits{:}];
   fp = vertcat(fits.params);
   return
end

if nargin < 6 %|| isempty(mask)
    mask = [];%true(size(beta0));
end

if nargin < 7
    rng = [];
end

d = dvplot(col, ds, []);
for i = 1:length(ds)
    if nargin < 4
        fit = dvgraphprop(col, ds(i), 'curve');
        fit = fit.args{1};
        model = fit.fn;
        beta0 = fit.startparams;
        mask = fit.mask;
        rng = fit.rng;
        dvdisplay(col, ds(i), 'curve');
    end
    if isempty(rng)
        fit.params = fitwrap(ctrl, d(i).x, d(i).data, beta0, model, mask);
    else
        if rng(2) == inf;
            rng = rng(1):length(d(i).x);
        end
        fit.params = fitwrap(ctrl, repmat(d(i).x(rng), size(d(i).data, 1), 1), d(i).data(:, rng), beta0, model, mask);
        % at some point, was transposing x(rng) here. No sure if removing is universal.
    end
    if(~isempty(strfind(ctrl,'pause')))
        pause;
    end
    fit.fn = model;
    fit.mask = mask;
    fit.startparams = beta0;
    fit.rng = rng;
    
    dvdisplay(col, ds(i), 'curve', fit);
end
