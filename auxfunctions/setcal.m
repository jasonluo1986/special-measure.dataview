function setcal(col, ds, hds, t1)
% setcal(col, ds, hds, t1)
% Normalize data according to single shot histograms, using user 
% supplied t1 for right (triplet) peak. t1 is the ratio of the 
% the measurement time to the relevant T1 time to (default = 1e-3).

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


%global dvdata;

if nargin < 4
    t1 = 1e-3;
end

dvdisplay(col, hds, 'curve');

[fitfn, initfn] = getfn(t1);
dvfit(col, hds,  'plinit plfit', initfn, fitfn, [1 1 1 1 0 0 1]);

fp = dvfit(col, hds, 'getp');

mv = ((1-exp(-abs(fp(5:6))))./abs(fp(5:6))-.5).*[-1 1]./fp(2) + fp(1);

dvfilter(col, ds, @scale, 'del');
dvfilter(col, ds, @scale, '', 1/diff(mv), -mv(1)/diff(mv));

dvplot(col, [ds hds]);

end


function [fitfn, initfn] = getfn(t1)

distfn = @(a, x) exp(-a(1)) * exp(-(x-1).^2./(2* a(2)^2))./(sqrt(2 * pi) * a(2)) + ...
     a(1)/2 * exp(a(1)/2 * (a(1) * a(2)^2 - 2 * x)) .* ...
     (erf((1 + a(1) * a(2)^2 - x)./(sqrt(2) * a(2))) + erf((-a(1) * a(2)^2 + x)./(sqrt(2) * a(2))));
% parameters: [t_meas/T1, rms amp noise/peak spacing]
 
fitfn = @(a, x) a(3) * distfn(abs(a([5 7])), .5-(x-a(1)).*a(2)) + a(4) * distfn(abs(a([6 7])), .5+(x-a(1)).*a(2));
%parameters: [ center between peaks, 1/spacing, coeff left peak, coeff right peak, t_m/T1,left, t_m/T1,right, rms amp noise/peak spacing]
% sum(coefficients) = 1 corresponds to a PDF for unity peak spacing.
% If fitting raw histograms, # samples = sum(fp(:, 3:4), 2) ./(fp(:, 2) * diff(d.x(1:2)));

initfn.fn = @(x, y)[sum(x.*y)/sum(y), 125, max(y), max(y), 1e-3, t1, .2];
initfn.args = {};
%fifn.vals = [nan(1, 4), -10, 0];

end
