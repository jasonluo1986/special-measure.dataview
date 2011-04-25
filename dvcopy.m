function destcol = dvcopy(srccol, srcds, destcol, destpos)
% dvcopy(srccol, srcds, destcol = 0, destpos = end)
%
% copy datasets srcds from collection srccol to collection destcol
% or a new collection.

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global dvdata;

if nargin < 3 || destcol == 0% new collection
    destcol = 1;
    while destcol <= length(dvdata.collections) && ~isempty(dvdata.collections{destcol}); 
        destcol = destcol + 1; 
    end;

    % initialise
    dvdata.collections{destcol}.datasets = [];
    dvdata.collections{destcol}.figsize = [2 2];
else
    if destcol > length(dvdata.collections) || isempty(dvdata.collections{destcol})
        fprintf('Collection %d invalid\n', destcol);
        return;
    end
end

if nargin < 4 || isempty(destpos)% insert at end
    destpos = length(dvdata.collections{destcol}.datasets) + 1;
end


% recmask = logical(bitand([dvdata.collections{srccol}.datasets(srcds).flags], 128));
% 
% if srccol~=destcol
%     srcrec = [dvdata.collections{srccol}.datasets(srcds(recmask)).file];
% else
%     srcrec = [];
% end
% 
% srcsets = dvdata.collections{srccol}.datasets([srcds srcrec]);
% 
% 
% recsets = find(recmask);
% for i = 1:recsets% length(recsets)
%    srcsets(i).file = destpos + i - srcsets(i).file;
% end
    

dvdata.collections{destcol}.datasets = ...
    [dvdata.collections{destcol}.datasets(1:destpos - 1), ...
    dvdata.collections{srccol}.datasets(srcds), ...
    dvdata.collections{destcol}.datasets(destpos:end)];
