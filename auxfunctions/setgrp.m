function setgrp(col, ds, nds, offset)
% setgrp(collection, ds, nds, offset)
% Split consecutive datasets and add an offset.
% ds: first dataset
% nds: # datasets in each grop
% offset: optional, can be single value or vector with one entry for each group

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.



dvdisplay(col, ds+cumsum(nds(1:end-1)), 'prevax', 0);

if nargin < 4
    return;
end

if length(offset) == 1;
    offset = repmat(offset, 1, length(nds));
end

for i = 1:length(nds);
    setoffset2(col, ds+(0:nds(i)-1), offset(i))
    ds = ds + nds(i);
end
