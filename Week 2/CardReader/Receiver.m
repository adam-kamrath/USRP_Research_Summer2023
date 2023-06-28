center_frequency = 13560000;
sampling_rate = 156250;
decimation_factor = round(100000000/sampling_rate);

pause(3);

rx = comm.SDRuReceiver(...
                    Platform = "N200/N210/USRP2", ...
                    IPAddress = '192.168.10.3', ...
                    OutputDataType = "double", ...
                    DecimationFactor = decimation_factor, ...
                    Gain = 0, ...
                    CenterFrequency = center_frequency, ...
                    SamplesPerFrame = 156250*5);





timeScope = timescope(TimeSpanSource = "Property",...
                      TimeSpan = 5,SampleRate = sampling_rate);
timeScope.YLimits = [-.6,.6];

disp("Reception Started");
frameduration = (rx.SamplesPerFrame)/(sampling_rate); 
time = 0; 
while time < 5
  data = rx();
  timeScope(data)
  time = time + frameduration;
  disp(time);
end

disp("Reception Stopped");
release(timeScope); 
release(rx);
