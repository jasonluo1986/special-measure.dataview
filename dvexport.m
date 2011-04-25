function dvexport(collection, filebase, opts, figs)
% imexport(collection, filebase, opts, figs)
% create eps files from each figure in a collection, 
% as currently displayed on the screen. Write tex file with graphics
% commands.
% If filebase is not given, it is generated from collection name or number
% and ../tex/ prepended if the tex directory exists.
% opts: intended to prevent writing of images or tex files, change format
%    nofig: do not generate figure files.

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global dvdata;

if nargin < 2 || isempty(filebase)
    if isfield(dvdata.collections{collection}, 'name')
        filebase = dvdata.collections{collection}.name;
    else
        filebase = sprintf('col_%02d', collection);
    end
    if ~strcmp(filebase(1:4), './tex/') && exist('./tex') == 7
        texbase = ['./tex/'];
    else
        texbase='';
    end
end

if nargin < 3
    opts = '';
end

format = 'epsc2';

if nargin < 4
    figs = 1:ceil(sum(bitand([dvdata.collections{collection}.datasets.flags], 4096+8)==0)...
        / prod(dvdata.collections{collection}.figsize));
end

colfile = fopen([texbase filebase, '.tex'], 'w'); 

for i = figs
    if(~exist([texbase filebase '_eps']))
        mkdir([texbase filebase '_eps']);
    end
    file = sprintf('%s_eps/%s%03d', [texbase filebase], filebase,i);
    if isempty(strfind(opts, 'nofig')) && ishandle(5899 + collection*100 + i)
        set(5899 + collection*100 + i, 'PaperPositionMode', 'auto');
        saveas(5899 + collection*100 + i, file, format);
    end
    
    fprintf(colfile, '%s%s.eps}\\\\\n', '\includegraphics[height=0.48\textheight,width=\textwidth,keepaspectratio=true]{',...
         sprintf('%s_eps/%s%03d', filebase, filebase,i));
end

fclose(colfile);
