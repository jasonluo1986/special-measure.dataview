function sc = loadRawHist(file, col, frames, channels,groups,pulses)
%function sc = loadRawHist(file, col, frames, channels,groups,pulses)
% Load a 'raw' data file (all singleshot data), generate hists for every
% group, pulse. -OR- for the groups and pulses specified in last two
% arguments

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.

global dvdata;
if ~exist('frames','var')
    frames = [];
end
    
load(file, 'scan','data');

nchan = length(scan.loops(1).getchan);
if iscell(scan.data.conf.datachan)
  dchan = length(scan.data.conf.datachan);
else
  dchan=1;
end
rawchans = nchan+(1:dchan); % where raw data with different daq channels sits.

if ~exist('channels','var') || isempty(channels)
    channels = 1:dchan;
end

if ~exist('groups','var') || isempty('groups')
    groups = 1:length(scan.data.pulsegroups);
end
npulse=scan.data.pulsegroups(1).npulse(1);
if ~exist('pulses','var') || isempty('pulses')
    pulses = 1:npulse;
end

allout = [];
for l=1:dchan
    [col, ds] = dvinsert(file, col, [], rawchans(l));    

    if ndims(data{rawchans(dchan)}) == 2
      dvfilter(col, ds, 'permute', '', [1 3 2]);
    end
    dvfilter(col,ds,'permute','',[3 1 2]);    
    len=prod(size(data{rawchans(dchan)}));
    ng=length(scan.data.pulsegroups);
    dvfilter(col,ds,'reshape','',[npulse,len/(ng*npulse), ng]);
    dvfilter(col,ds,'permute','',[3 1 2]);
    %ds now has all the data in pulses,groups,reps format.
    nplots = length(pulses)*length(groups);
    for i = 2:nplots
        dvcopy(col,ds,col)
        ds = [ds length(dvdata.collections{col}.datasets)];
    end
    k=1;   
    
    for j=groups
        ro=plsinfo('ro',scan.data.pulsegroups(j).name);
        roi=find(ro(:,1) == l);
        if(isempty(roi))
            ro=ro(1,:);
        else
            ro=ro(roi(1),:);
        end
        for i=pulses
            dvfilter(col,ds(k),'subsref','',struct('type','()','subs',{{j,i,':'}}));
            dvfilter(col,ds(k),'squeeze','');
            
            addMakeRaw(col,ds(k),ro);
            % Stuff the readout information into the y-data.
            k=k+1;
        end
    end       
  dvdisplay(col, ds , 'filename');
  dvplot(col, ds);
end    
end

function addMakeRaw(col, ds, ro)
  dvfilter(col,ds,@makeRawHist,'all',200,ro);
end
function [data x y]=makeRawHist(data, x, y, bins,ro)
  [d c] = hist(data,bins);
  data = d;
  x = c;
  y = ro;
end
