function hndl = plot_tps2014b (data)
  
  % plot_tps2014b               Plot a dataset generated by the oscilloscope TPS 2014-B
  %
  % Description:
  % -----------
  % This function plots into a new figure a dataset generated by the oscilloscope TDS 2014-B.
  % The input argument must be a structure returned by import_tps2014b().
  % Each channel is plotted into a subplot. 
  % If all channels share the same time scale, the horizontal axes of all subplots (corresponding to
  % the time or to the frequency) are synchronized. Otherwise a warning message is emitted.
  %
  %
  % Input:
  % - data(n)                   Dataset generated by the oscilloscope TPS 2014-B
  %
  % Output:
  % - hndl(n)                   Handle to the generated graphics
  %
  % Notes:
  %
  % Example:
  %
  % See also: import_tps2014b()
  %
  % References:
  %
  % Validation:
  %
  % 13-Sep-2022 - First version.

  % --------------------------->| description of the function ---|------------------------------------------->| remarks

  % Check if the function is being run in Matlab or Octave
  isMatlab = (exist('OCTAVE_VERSION', 'builtin') == 0);
  
  % Plot all datasets
  nbChannels = numel(data);
  fig = figure;
  for n = 1 : nbChannels
    listOf_axes(n) = axes(fig);
    subplot(nbChannels, 1, n, listOf_axes(n));
    hndl(n) = plot(listOf_axes(n), data(n).time, data(n).value);
    box(listOf_axes(n), 'on');
    xlabel(listOf_axes(n), sprintf('Time  (%s)', data(n).Info.hunit));
    ylabel(listOf_axes(n), sprintf('%s  (%s)', data(n).Info.source, data(n).Info.vunit));
    grid(listOf_axes(n), 'on');
    if isMatlab
      hndl_zoom = zoom(listOf_axes(n));
      hndl_zoom.Motion = 'horizontal';
      hndl_zoom.Enable = 'on';
    end
  end

  % Check that all the channels share the same horizontal scale
  flag = true;
  for n = 2 : nbChannels
    if ~( (data(n).Info.length == data(1).Info.length)  &&  all(data(n).time == data(1).time) )
      flag = false;
      warning('The channels don''t have the same time scale');
      break;
    end
  end

  % If all axes share the same time scale, link the x axes of all channels
  if flag  &&  isMatlab
    linkaxes(listOf_axes, 'x');
  end
end
