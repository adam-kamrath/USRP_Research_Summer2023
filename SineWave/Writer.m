sampling_rate = 240000;
decimation_factor = round(100000000/sampling_rate);
center_frequency = 13560000;

rx = comm.SDRuReceiver(...
                    Platform = "N200/N210/USRP2", ...
                    IPAddress = '192.168.10.2', ...
                    OutputDataType = "double", ...
                    DecimationFactor = decimation_factor, ...
                    Gain = 0, ...
                    CenterFrequency = center_frequency, ...
                    SamplesPerFrame = 400);

rxWriter = comm.BasebandFileWriter('capture.bb', ...
         SampleRate=sampling_rate,CenterFrequency=center_frequency);

frameduration = (rx.SamplesPerFrame)/(sampling_rate); 
frames = 4000;
end_time = frames * frameduration;

timeScope = timescope(TimeSpanSource = "Property",...
                      TimeSpan = 5/30e3,SampleRate = sampling_rate);
timeScope.YLimits = [-.2,.2];
disp("Reception Started");

time = 0; 
while time < end_time
  data = rx();
  timeScope(data)
  rxWriter(data);
  time = time + frameduration;
end

disp("Reception Stopped");
info(rxWriter)
release(rxWriter);
release(timeScope); 
release(rx);
