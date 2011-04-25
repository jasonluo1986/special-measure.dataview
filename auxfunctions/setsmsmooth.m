%Smooth data by binning nc points together along x axis.

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.

function setsmgrad(col, ds,nc)
dvfilter(col, ds, @(x)smgh(x,nc));
dvplot(col, ds);
end
function y=smgh(x,nc)
  for l=1:size(x,1)
    y(l,:)=smooth(x(l,:),nc);
  end  
end

%imdisplay(collection, images, 'axis');
