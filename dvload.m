% function col = dvload(file)
% file can be filename or collection nr for reload.

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.

function col = dvload(file)
global dvdata;

if ~exist('file','var')
    file=uigetfile('col*.mat');
    file=regexprep(file,'^col_','');
    file=regexprep(file,'.mat$','');    
end

if ~ischar(file)
   col = file;
   if(col > length(dvdata.collections))
       error('Whoops');
   end
   if isfield(dvdata.collections{col}, 'name')
        file = ['col_', dvdata.collections{col}.name];
   else       
        file = sprintf('col_%02d', col);
   end    
else
  col = 1;
  while col <= length(dvdata.collections) && ~isempty(dvdata.collections{col});
    col = col + 1;
  end;
  if file(1) ~= '/'
    file = ['col_', file];
  end
end

load(file);

dvdata.collections{col} = datacol;
fprintf('Loaded %d entries\n',length(dvdata.collections{col}.datasets));

