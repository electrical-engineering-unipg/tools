function answr = isMatlab ()

% isMatlab                    return true if the function is being run in Matlab
% 
% Description:
% -----------
% This function aims at improve the compatibility between Matlab and Octave. It allows to programs to
% be aware of the running environment (= Matlab or Octave).
%
%
% Input:
% *                           
%
% Output:                     
% - answr                     True if the function is being run in Matlab
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
% 14-Sep-2022 - First version.

% --------------------------->| description of the function ---|------------------------------------------->| remarks

answr = (exist('OCTAVE_VERSION', 'builtin') == 0);

end


