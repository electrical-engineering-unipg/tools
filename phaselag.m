function [lag, phs] = phaselag (y1, y2, threshold, dt, frq)

% phaselag                    compute the lag between two signals so that y2(n+lag) ~ y1(n)
% 
% Description:
% -----------
% This function estimates the lag between two signal by maximizing the cross-correlation between the
% signals. Before computing the cross-correlation, signals are chopped so as to remove the highest
% values. This can be useful when spikes are present in signals:
%
%        .
%        .  .
%        .  .
% ^   ...   .                                   ^   ...   .      - - - - - - -   theshold*max(|y|)
% | ..    ...                                   | ..    ... 
% |.        .                                   |.        . 
% +----------.-------.---->     becomes:        +----------.-------.---->
% |           ..   ..                           |           ..   .. 
% |             ...                             |             ... 
%               .                                             .  - - - - - - -  -theshold*max(|y|)
%               .
%
% Ths lag is estimated in such a way that y2(n+lag) is aligned with y1(n). 
% In case of periodic signals, the corresponding phase can be computed by:
%
%   phase = mod(lag*2*pi*f*dt , 2*pi)
%
% where: (f = frequency, dt = sampling time).
%
% That is: y2(2*pi*f*t + phase) is aligned with y1(2*pi*f*t)
%
% The computation method is based on finding the max. of the cross-correlation. The method proposed
% in [1] doesn't seem to work properly if the signals have different lengths; I modified.
%
% If no output argument is required, this function plots the results in a new figure.
%
% The proprietary function xcorr() is replaced by a free (simplified) version, hence no particular
% toolbox is required.
%
%
% Input:
% - y1(n), y2(m)              Signals
% - threshold                 Threshold used to chop signals (default or empty = 0.5) ; end
%
% Output:                     
% - lag                       Delay so that y2(n+lag) is in phase with y1(n)
%
% Notes:                      
%
% Example:       
% >> fr = 50 ; T = 1/fr;
% >> t = linspace(0, 4*T, 256);
% >> y1 = sqrt(2)*sin(2*pi*fr*t) + 0.1*randn(size(t));
% >> y2 = sin(2*pi*fr*t(1:100)+pi/3) + 0.1*randn(1,100);
% >> [lag, phs] = phaselag(y1, y2, [], t(2)-t(1), 50)
% 
% lag = 38
% phs = 0.9327      (exact value: pi/3 = 1.0472)
%
% See also:                   
%
% References:                 
% [1] https://fr.mathworks.com/matlabcentral/answers/93848-how-can-i-use-cross-correlation-as-a-tool-to-align-two-signals-in-matlab
%
% Validation:                 
%
% Date:                       16-Sep-2022 - First version.

% --------------------------->| description of the function ---|------------------------------------------->| remarks

% Handle arguments by default
if nargin < 3  ||  isempty(threshold) , threshold = 0.5 ; end
if nargin < 4 , dt = 1 ; end

% Remove spikes or other outlier values
if numel(threshold == 1) , threshold = [threshold threshold] ; end
y1p = preprocessing(y1, threshold(1));
y2p = preprocessing(y2, threshold(2));

% Compute the cross-correlation and estimate the lag
xc = free_xcorr(y1p, y2p);
[~, ind] = max(xc);

% This doesn't seem to work:
% lag = ind - max(numel(y1), numel(y2));

% My modification
lag = ind - numel(y2);

% If the sampling period and signal frequency are provided, compute the phase
if nargin == 5
  phs = 2*pi*mod(lag*frq*dt, 1.0);
end


% If no output argument is required, plot the signals
if nargout == 0
  figure
  subplot(3, 1, 1);
  yyaxis left ; ylabel('y_1');
  plot(dt*(0:numel(y1)-1), y1, 'b') ; hold on; 
  plot(dt*(0:numel(y1p)-1), y1p, 'b.');
  yyaxis right ; ylabel('y_2');
  plot(dt*(0:numel(y2)-1), y2, 'r') ; hold on
  plot(dt*(0:numel(y2p)-1), y2p, 'r.');
  grid on ; box on;

  subplot(3, 1, 2);
  plot(dt*(0:numel(xc)-1), xc) ; hold on
  plot(ind*dt, xc(ind), 'r*');
  grid on ; box on;
  ylabel('cross-correlation');

  subplot(3, 1, 3);
  yyaxis left ; ylabel('y_1');
  plot(dt*(0:numel(y1)-1), y1, 'b') ; hold on
  yyaxis right ; ylabel('y_2 (aligned)');
  plot(dt*(0:numel(y2)-1)+lag*dt, y2, 'r');
  grid on ; box on;
  xlabel('Time');
  if nargin == 5
    title(sprintf('phase = %+3.0f°', phs*180/pi));
  end
end
end

function yp = preprocessing(y, threshold)
  % Cut off spikes
  if nargin < 2 , threshold = 0.7 ; end
  max_y = max(abs(y)) * threshold;
  yp = y;
  yp(y>max_y) = max_y;
  yp(y<-max_y) = -max_y;
end

function xc = free_xcorr(y1, y2) 
  % Free simplistic version of xcorr()
  xc = conv(y1(:), flipud(y2(:)));
end
