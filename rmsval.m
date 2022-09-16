function val = rmsval (x)

% rmsval                      compute the r.m.s. value
% 
% Description:
% -----------
%
% Input:
% - x(n)                      Signal
%
% Output:                     
%- val*                       r.m.s. value
%
% Notes:                      
%
% Example:                    
%
% See also:                   
%
% References:                 
%
% Validation:                 
%
% 16-Sep-2022 - First version.

% --------------------------->| description of the function ---|------------------------------------------->| remarks

val = sqrt(sum(x.^2) / numel(x));

end


