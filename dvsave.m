function dvsave(cols, file)
% dvsave(cols, file)
% Save collection in a single file. file defaults to collection name or col_#.

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global dvdata;

if nargin > 2
    cols(2:end) = [];
end

for col = cols
    if nargin < 2
        if isfield(dvdata.collections{col}, 'name')
            file = ['col_', dvdata.collections{col}.name];
        else
            file = sprintf('col_%02d', col);
        end
    end

    datacol = dvdata.collections{col};

    save(file, 'datacol');
end
