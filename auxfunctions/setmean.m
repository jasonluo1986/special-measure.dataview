function setmean(col, ds)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global dvdata;
filt(1).function = @dvfcutnan;
filt(1).args = {};
filt(2).function = @mean;
filt(2).args = {1};

if strcmp(func2str(dvdata.collections{col}.datasets(ds).filter(1).function), 'permute')
    dvdata.collections{col}.datasets(ds).filter(1).args ...
        = [dvdata.collections{col}.datasets(ds).filter.args+1, 1];
else
    filt(3).function = @squeeze;
    filt(3).args = {};
end

[filt.mode] = deal('');
    
dvdata.collections{col}.datasets(ds).filter = [filt, dvdata.collections{col}.datasets(ds).filter];
