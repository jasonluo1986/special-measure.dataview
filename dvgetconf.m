function vals = dvgetconf(col, datasets, chan)
% get config channel values

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global dvdata;

if nargin < 2 || isempty(datasets)
    datasets = 1:length(collection.datasets);
end

vals = zeros(1, length(datasets));

lastfile = '';

for i = 1:length(datasets);
    file = dvdata.collections{col}.datasets(datasets(i)).file(1);
    if bitand(dvdata.collections{col}.datasets(datasets(i)).flags, 128)
        file = dvdata.collections{col}.datasets(file(1)+datasets(i)).file(1);
    end
    if isnumeric(file)
        d = dvdata.cache{file};
    else
        if ~strcmp(file{1}, lastfile)
            d = load(file{1});
            lastfile = file{1};
        end
    end

    vals(i) = d.configvals(strmatch(chan, d.configch));
end
