%Plot the magnitude of the gradient of the data.

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.

function setsmgrad(col, ds)
dvfilter(col, ds, @smgh);
dvplot(col, ds);
end
function y=smgh(x)
[dx,dy]=gradient(x);
y=sqrt(dx.*dx+dy.*dy);
end

%imdisplay(collection, images, 'axis');
