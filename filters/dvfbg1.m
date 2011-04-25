function d = dvfbg1(d, ctrl)

% (c) 2010 Hendrik Bluhm.  Please see LICENSE and COPYRIGHT information in plssetup.m.

if nargin < 2
    ctrl = '';
end

switch ctrl
    case ''
        d = cell2mat(transpose(d(1:end-1))) - repmat(d{end}, length(d)-1, 1);
    case 'interp'
        n1 = length(d{1})-1;
        n2 = length(d{end})-1;
        bg = interp1((0:n2) * round(n1/n2), d{end}, 0:n1); 
        d = cell2mat(transpose(d(1:end-1))) - repmat(bg, length(d)-1, 1);
end
