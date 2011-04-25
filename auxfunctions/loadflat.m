% Load a file, making some effort to flatten the median gradient.
% opts is one of: (noline)
% sc = loadtriang(file, col, ch, opts)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.

function sc = loadflat(file, col, ch, opts)
global dvdata;
if ~exist('col','var')
    col=length(dvdata.collections);
end
if ~exist('file','var') || isempty(file)
   [file path] = uigetfile('sm*.mat');
   file = [path file];   
end
if nargin < 3
    ch = 1;
end

if nargin < 4
    opts='';
end

load(file, 'scan', 'data');

[col, sc(1)] = dvinsert(file, col, [], ch);
if(isempty(strfind(opts,'noline')))
  [col, sc(2)] = dvinsert(file, col ,[], ch);
end  

dvdisplay(col, sc, 'filename');
dvdisplay(col, sc(1), 'color');
dvdisplay(col, sc(1), 'imax');

%ind = imagedata.collections{col}.images(sc).index;
%rng = imagedata.cache{ind}.range(1) * [-.5, .5] + imagedata.cache{ind}.shift(1);
%dvdisplay(col, sc+1, 'imaxes', 'xlim', rng, 'Fontsize', 6);

if length(scan.loops) > 2
    dvfilter(col, sc, '@dvfcutnan');
    dvfilter(col, sc, '@mean');
    dvfilter(col, sc, '@squeeze');
end
mask=find(isnan(data{ch}));
data{ch}(mask)=0;
[gx,gy] = gradient(data{ch});
sm=2;
for l=1:size(gx,1)
    gx(l,:)=smooth(gx(l,:),3);
end
for l=1:size(gy,2)
    gy(:,l)=smooth(gy(:,l),3);
end
coeff(1)=median(gx(cull(gx)));
coeff(2)=median(gy(cull(gy)));
coeff(3)=mean(data{ch}(:));

dvfilter(col, sc, @planesub,'', coeff);

dvplot(col, sc);
end

% coeff are c(1)*x+c(2)+c(3)
% x,y are in pixels!
function out=planesub(data,coeff)
  [mx,my]=meshgrid(1:size(data,2),1:size(data,1));
  out=data-mx*coeff(1)-my*coeff(2)-coeff(3);
end

function se=cull(data)
  m = median(data(:));  
  s = median(abs(data(:)-m));
  se = find(abs(data(:)-m) < 2*s);
  m = mean(data(se));  
  se = find(abs(data(:)-m) < 2*s);
end
