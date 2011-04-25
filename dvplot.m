function plotdata = dvplot(collections, datasets, ax)
% plotdata = dvplot(collections, datasets, ax)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.


global dvdata;
persistent d
persistent lastfile

if nargin < 1
    collections = 1:length(dvdata.collections);
    collections = collections(~isempty(dvdata.collections(collections)));
end

plotdata = [];
lastfile = '';

legstr = {};
legh = [];

for col = collections
    
    if col > length(dvdata.collections) || isempty(dvdata.collections{col})
        fprintf('Collection %d invalid\n', col);
        continue;
    end
    
    startfig = col * 100 + 5900;
    collection = dvdata.collections{col};

    if nargin < 2 
        datasets = collection.lastplot;
    elseif isempty(datasets)
        datasets = 1:length(collection.datasets);
    end
    
    if nargin < 3
        dvdata.collections{col}.lastplot = datasets;
    end
    
    figs = cumsum(bitand([collection.datasets.flags], 4096+8)==0);    
    %figs = cumsum([collection.datasets.nfigs]);
    
    for i = datasets    
        ds = collection.datasets(i);

        if isempty(ds.file) || (bitand(ds.flags, 8) && (nargin < 3  || ~isempty(ax)))
            continue;
        end

        if bitand(ds.flags, 128) %recursive set, combine first
            alldata = dvplot(col, i+ds.file, []);
            x = alldata(1).x;
            y = alldata(1).y;
            alldata = {alldata.data};
            ds.file = collection.datasets(ds.file(1)+i).file(1); % run as for single set from here.
            % this is not quite right for mulitply recursive sets - would have
            % to descend through recursion. May also get trouble if mixing recursions.
        elseif length(ds.file) > 1
                alldata = cell(1, length(ds.file));
        end

        if ~bitand(ds.flags, 4096)
            legstr = {};
            legh = [];
        end

        for j = 1:length(ds.file)
            if ~bitand(ds.flags, 128) % not recursive, populate alldata
                
                if ~isfield(ds, 'type') 
                    ds.type = 'sm';
                end
                switch ds.type
                    case {'', 'sm'} % sm file
                        if(regexp(ds.file{1},'^sm_'))
                            fn={ds.file{1}(4:end)};
                        else
                            fn=ds.file;
                        end
                        legstr(end+1)=fn;
                        
                        if isnumeric(ds.file)
                            d = dvdata.cache{ds.file(j)};
                        else
                            if ~strcmp(ds.file{j}, lastfile)
                                d = load(ds.file{j});
                                lastfile = ds.file{j};
                            end
                        end
                        data = d.data{ds.channel};

                        if j==1 % get x,y from first dataset
                            if isempty(d.scan.loops(1).npoints)
                                x = d.scan.loops(1).rng;
                            elseif isempty(d.scan.loops(1).rng)
                                x = 1:d.scan.loops(1).npoints;
                            else
                                x = linspace(d.scan.loops(1).rng(1), d.scan.loops(1).rng(end), ...
                                    d.scan.loops(1).npoints);
                            end
                            if length(d.scan.loops) >= 2
                                if isempty(d.scan.loops(2).npoints)
                                    y = d.scan.loops(2).rng;
                                elseif isempty(d.scan.loops(2).rng)
                                    y = 1:d.scan.loops(2).npoints;
                                else
                                    y = linspace(d.scan.loops(2).rng(1), d.scan.loops(2).rng(end), ...
                                        d.scan.loops(2).npoints);
                                end
                            else
                                y = [];
                            end

                        end
                        
                    case 'fit'
                        [x, data, legstr(end+1)] = dvplotfit(ds.file);
                        x = x{ds.channel};
                        data = data{ds.channel};
                        y = [];
                end
                   

            end

           for f = 1:length(ds.filter)
               if ischar(ds.filter(f).function)                                    
                  ds.filter(f).function=str2func(ds.filter(f).function);                  
               end
           end
           for f = ds.filter               
                switch f.mode
                    case 'x';
                        x = f.function(x, f.args{:});
                    case 'y'
                        y = f.function(y, f.args{:});
                    case 'all'
                        [data, x, y] = f.function(data, x, y, f.args{:});
                        
                    case 'comb'
                        if ~bitand(ds.flags, 128) && j < length(ds.file) 
                            alldata{j} = data;
                            break;
                        else % combine data into single set.
                            data = f.function(alldata, f.args{:});
                            alldata = [];
                            ds.file = ds.file(1); % use data from first ds below
                        end
                    otherwise
                        data = f.function(data, f.args{:});
                end
            end

        end
    
        %if ~isempty(ds.xyscale)
        %    x = diag(ds.xyscale(1)) * x;
        %    y = diag(ds.xyscale(min(2, end))) * y;
        %end

        %if ~isempty(ds.datascale)
        %    data = data * ds.datascale;
        %end
        pd.data = data;
        pd.x = x;
        pd.y = y;
        plotdata = [plotdata, pd];
        
        if bitand(ds.flags, 8) || nargin >= 3 && isempty(ax)
            continue;
        end
        if nargin >= 3 && ~isempty(ax)
            axes(ax);
            %offset = 0;
        else
            figure(floor((figs(i)-1) / prod(collection.figsize)) + startfig);
            subplot(collection.figsize(1), collection.figsize(2), mod(figs(i)-1, prod(collection.figsize)) + 1);

            if bitand(ds.flags, 4096) %&& ~bitand(collection.datasets(max(1, i-1)).flags, 8)
                hold on;
            else
                hold off;
            end
        end
        
        switch bitand(ds.flags, 32+64)
            case 32
                img = imagesc(x, y, data);
                if bitand(ds.flags, 2048);
                    axis image;
                end
            case 64
                img = plot(y, data);
            otherwise
                img = plot(x, data');
        end
        
        legh(end+1) = img(1);
        
        scalelineprops = {};
        scalelabelprops = {};
        titleprops = {};
        axprops = {};     
        colaxprop = {};
        titstr = '';
        
        for graph = ds.graphobjs

            switch graph.type
                    
                case 'line'
                    line(graph.args{:});
                    
                case 'text'
                    text(graph.args{:});
                    
                case 'scaleline'
                    scalelineprops = graph.args;
                    
                case 'scalelabel'
                    scalelabelprops = graph.args;
                    
                case 'title'
                    titleprops = graph.args;
                    
                case 'colaxes'
                    colaxprop = graph.args;
                    
                case 'axes'
                    axprops = graph.args;
                    
                case 'data'
                    set(img, graph.args{:});
                    
                case 'xlabel'
                    xlabel('', graph.args{:});

                case 'ylabel'
                    ylabel('', graph.args{:});

                case 'curve'
                    fp = graph.args{1};
                    if ~isfield(fp, 'x')
                        fp.x = x;
                    end
                    if ~isfield(fp, 'style')
                        fp.style = {};
                    end
                    % could run a loop here, allow fp to be a struct array
                    
                    hs = get(gca, 'nextplot');
                    hold on
                    for j = 1:size(fp.params, 1)
                        if(ischar(fp.fn))
                            fp.fn=eval(fp.fn);
                        end
                        plot(fp.x, fp.fn(fp.params(j, :), fp.x), fp.style{:});
                    end
                    set(gca, 'nextplot', hs);
                    
                case 'conf' %sm-specific
                    for j = 1:length(graph.args)
                        titstr = [titstr, sprintf('%s = %.3g,', graph.args{j}, ...
                            d.configvals(strcmp(d.configch, graph.args{j})))];
                    end
                    titstr(end) = [];
                    %confdata = [d.configch(graph.args{1}); num2cell(d.configval2(graph.args{1}))];
                    
                case 'legend'
                    set(legend(legh, legstr{:}), graph.args{:});                    
                    
            end
        end
        
        
        if bitand(ds.flags, 2) ; axis off; end
        if bitand(ds.flags, 4)  % scalebar
          
            shift = [mean(x), mean(y)];
            range = [x(end)-x(1), y(end)-y(1)];
            
            sbwidth = range(1) / 3;
            % round to nearest 1, 2 or 5, * 10^n
            sbround = [1 2 5];

            sbwidth = sbround(floor(mod(log10(sbwidth), 1) * 3) + 1) * ...
                10 ^ floor(log10(sbwidth));
            
            hold on;
            f = plot(range(1) * 0.45 + shift(1) - [sbwidth, 0], ...
                range(2) * -0.45 + shift(2)* [1, 1], 'color', 'k');
            set(f, 'LineWidth', 2);    
            if ~isempty(scalelineprops)
                set(f, scalelineprops{:});
            end
            
            if isempty(ds.xycalib)
                if sbwidth < 1
                    str = sprintf('%.2f V', sbwidth);
                else
                    str = sprintf('%d V', sbwidth);
                end
            else
                if sbwidth < 1
                    if sbwidth < .1
                        str = sprintf('%d nm', sbwidth*1e3);
                    else
                        str = sprintf('%.1f \\mum', sbwidth);
                    end    
                else
                    str = sprintf('%d \\mum', sbwidth);
                end
            end
            t = text(range(1) * 0.45 + shift(1) - sbwidth, range(2) * -0.4 + shift(2), ...
                str, 'FontSize', 12, 'color', 'k', 'FontWeight', 'bold');
            if ~isempty(scalelabelprops)
                set(t, scalelabelprops{:});
            end
          
            hold off;
        end
                
        
        if bitand(ds.flags, 16)
            if iscell(ds.file)  % Strip the excess gunk from the file name.
                ft=regexprep(ds.file{1},'^(sm_)*','');
                ft=regexprep(ft,'.mat$','');
                titstr = strvcat(ft, titstr);
            else                            
                titstr = strvcat(dvdata.cache{ds.file}.filename, titstr);
            end
        end
                
        if bitand(ds.flags, 8+16+512+1024)
            tit = title(titstr, 'interpreter', 'none');        
            if  ~isempty(titleprops)
                set(tit, titleprops{:});
            end
        end

        if bitand(ds.flags, 1);
            cb = colorbar;             
            if ~isempty(colaxprop)
                set(cb, colaxprop{:});
            end
        end
        
        set(gca, 'ydir','normal', axprops{:})

        if isfield(collection, 'name') && ~isempty(collection.name)
            set(gcf, 'name', collection.name);
        end
    end
end
