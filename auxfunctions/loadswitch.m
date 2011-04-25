% Load a file, making some effort to make switches stand out.
% opts is one of: (post)
% sc = loadswitch(file, col, ch, opts, smoothing)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.

function sc = loadflat(file, col, ch, opts, smoothing)
global dvdata;
if ~exist('col','var') || isempty(col)
    col=length(dvdata.collections);
end
if ~exist('file','var') || isempty(file)
   [file path] = uigetfile('sm*.mat');
   file = [path file];   
end
if ~exist('smoothing','var')
   smoothing=3; 
end
if nargin < 3
    ch = 1;
end

if nargin < 4
    opts='';
end

load(file, 'scan', 'data');

[col, sc(1)] = dvinsert(file, col, [], ch);
if(~isempty(strfind(opts,'post')))
  [col, sc(2)] = dvinsert(file, col ,[], ch);
end  

dvdisplay(col, sc, 'filename');
dvdisplay(col, sc, 'color');
dvdisplay(col, sc, 'imax');

%ind = imagedata.collections{col}.images(sc).index;
%rng = imagedata.cache{ind}.range(1) * [-.5, .5] + imagedata.cache{ind}.shift(1);
%dvdisplay(col, sc+1, 'imaxes', 'xlim', rng, 'Fontsize', 6);

if length(scan.loops) > 2
    dvfilter(col, sc, '@dvfcutnan');
    dvfilter(col, sc, '@mean');
    dvfilter(col, sc, '@squeeze');
end
dvfilter(col, sc(1), @filter,'add',smoothing);
dvfilter(col, sc, @gradnorm);
if(~isempty(strfind(opts,'post')))
  dvfilter(col, sc(2), @filter,'add',smoothing);
end

mask=find(isnan(data{ch}));
data{ch}(mask)=0;


d=gradnorm(filter(data{ch},smoothing));
d=sort(d(:));
% drop 5% of data.
cull=0.01;
dvdisplay(col,sc(1),'axes','CLim',[d(floor(end*cull)) d(ceil(end*(1-cull)))]);

if(~isempty(strfind(opts,'post')))
  d=filter(gradnorm(data{ch}),smoothing);
  d=sort(d(:));
  % drop 5% of data.
  cull=0.01;
  dvdisplay(col,sc(2),'axes','CLim',[d(floor(end*cull)) d(ceil(end*(1-cull)))]);
end


dvplot(col, sc);
end
function out=filter(data, sigma) 
  if (~exist('sigma','var'))
      sigma=3;
  end
  %fprintf('Sigma is %g\n',sigma);  
  wid=sigma;
  ks=min(5,floor(sigma*3/2)*2+1);  
  kw=floor(ks/2);
  kc=ceil(ks/2);
  [x y]=meshgrid(-kw:kw,-kw:kw);
  kernel=exp(-(x.*x+y.*y)/(2*wid*wid));
  kernel=kernel / sum(kernel(:));
  out=filter2(kernel,data);
end
function out=gradnorm(data)
  [gx,gy]=gradient(data);
  out=sqrt(gx.^2 + gy.^2);
end

