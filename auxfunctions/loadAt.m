% function sc = loadAt(col, subdir, run, opts)
% Load a single at run.
% opts can contain:
%   diff:  Differentiate rather than triangle
%   flat:  flat rather than triangle
%
% loadAt(0,'tune_100410',1:87,'flat');

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.

function sc = loadAt(col, subdir, runs, opts)
global dvdata;
exptime=10;
count=0;

if(col == 0)
    % copied from dvinsert
    col = 1;
    while col <= length(dvdata.collections) && ~isempty(dvdata.collections{col});
        col = col + 1;
    end;
    
    % initialise
    dvdata.collections{col}.datasets = [];
    dvdata.collections{col}.figsize = [2, 2];
end

dvdata.collections{col}.name=sprintf('tune_%s_',subdir);

for run=runs
    fprintf('Processing %d\n',run);
    if(~exist('opts')) opts=''; end
    
    if(~isempty(strfind(opts,'diff')))
        p2dfunc=@loaddiff;
    elseif(~isempty(strfind(opts,'flat')))
        p2dfunc=@loadflat;
    elseif(~isempty(strfind(opts,'triang')))
        p2dfunc=@loadtriang;
    end
    
    file = sprintf('%s/sm_chrg_%03d.mat', subdir, run);
    if exist(file, 'file')
        p=p2dfunc(file, col,1,'noline');
    end
    
    files = dir(sprintf('%s/sm_zoom_%03d*.mat',subdir,run));
    for l=1:length(files)
    	file=sprintf('%s/%s',subdir,files(l).name);
        p = p2dfunc(file, col,1,'');  
        pl=getfch(file,'pulseline');
        if(isempty(pl))
          pl=getzoompls(file);
        end
        if(pl ~= 1)
          dvdisplay(col,p,'title','string',sprintf('%s (PL: %d)',files(l).name,pl));
        else
          dvdisplay(col,p,'title','string',sprintf('%s',files(l).name));
        end
        dvplot(col,p);
    end
    
    
    file = sprintf('%s/sm_lead1_%03d.mat', subdir, run);
    if exist(file, 'file')
        loadLead(file,col);
    end
    file = sprintf('%s/sm_lead2_%03d.mat', subdir, run);
    if exist(file, 'file')
        loadLead(file,col);
    end
    
    file = sprintf('%s/sm_read_%03d.mat', subdir, run);
    if exist(file, 'file')
        sc = loadT1(file,col);
        dvremove(sc + (0:1));
    end
    
    file = sprintf('%s/sm_line_%03d.mat', subdir, run);
    if(exist(file,'file'))
        sc = loadlineplot(file,col);
        'line';
    end
    count=count+1;
    if(mod(count, exptime) == 0 && ~isempty(strfind(opts,'export')))
       dvexport(col);
       dvclose(col);
    end
end
end
function sc=loaddiff(file,col)
  sc=load2D(file,col);
  setsmdiff(col,sc);  
end
function pl=getfch(file,chan)
  f=load(file,'configch','configdata');
  i=find(strcmp(f.configch,chan));
  if(length(i) ~= 1)
    pl=[];    
  else
    pl = configdata{i};
  end
end
function pl=getzoompls(file)
  f=load(file,'scan');
  pl=f.scan.consts(2).val;
end
