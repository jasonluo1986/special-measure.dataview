function [x, y, legstr] = dvplotfit(fits, fignum)
%[x, y] = dvplotfit(fits)
% fits: struct (array?) with fields:
% collection (name or index)
% ds: dataset indices
% params: parameter array appended to fit parameters
% x: index to x val or trafofn to compute x from fit parameters
% y: same for y

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.



% loop over fits, load file if string given.
if nargin < 2
    if nargout == 0
        fignum = 501;
        figure(501);
        clf(501);
        hold on;
    else
        fignum = [];
    end
end

c = 'rgbcmyk';
x = cell(1,length(fits));
y = x;

if ~isfield(fits, 'params')
    fits(1).params = [];
end

if ~isfield(fits, 'x')
    fits(1).x = [];
end

for j = 1:length(fits)
    fit = fits(j);
    
    col = dvcolind(fit.col);
    
    
    fp = dvfit(col, fit.ds, 'getp');
    if(size(fp,1) > size(fit.params,1))
        size(fp)
        size(fit.params)
        error(sprintf('Size mismatch on fp and fit.params: %d ~= %d\n', ...
            size(fp,1),size(fit.params,1)));
    elseif (size(fp,1) < size(fit.params,1))
        fprintf('Size mismatch on fp and fit.params: %d ~= %d\n', ...
            size(fp,1),size(fit.params,1));
    end
    fp = [fp , fit.params(1:size(fp,1),:)];
    
    if isempty(fit.x)
        x{j} = 1:length(fit.ds);
    elseif isnumeric(fit.x)
        x{j} = fp(:, fit.x)';
    elseif ischar(fit.x)
        fpf=str2func(fit.x);
        x{j} = fpf(fp)';
    else
        x{j} = fit.x(fp)';
    end
    
    flag = isnumeric(fit.y); % matlab acts up if making query directly
    if flag
        y{j} = fp(:, fit.y)';
    else
        if(isstr(fit.y)) % Allows late evaluation of trafofns.
            fit.y=eval(fit.y);
        end
        y{j} = fit.y(fp)';
    end
    
end

c = num2cell(c(mod(0:length(fits)-1,end)+1));
if ~isempty(fignum)
    po = [x;y;c];
    plot(po{:});
end

if nargout >= 3
    legstr = {fits.name};
end
