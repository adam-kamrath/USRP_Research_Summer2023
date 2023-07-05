center_frequency = 13560000;
sampling_rate = 200000;
decimation_factor = round(100000000/sampling_rate);

rx = comm.SDRuReceiver(...
                    Platform = "N200/N210/USRP2", ...
                    IPAddress = '192.168.10.2', ...
                    OutputDataType = "double", ...
                    DecimationFactor = decimation_factor, ...
                    Gain = 0, ...
                    CenterFrequency = center_frequency, ...
                    SamplesPerFrame = 200000);

timeScope = timescope(TimeSpanSource = "auto",...
                      TimeSpan = 5,SampleRate = sampling_rate, ...
                      Position=[20,200,800,500]);
timeScope.YLimits = [-.6,.6];


disp("Reception Started");
frameduration = (rx.SamplesPerFrame)/(sampling_rate); 
time = 0; 
while time < 5
  disp(time);
  data = rx();
  timeScope(data)
  time = time + frameduration;
end

disp("Reception Stopped");
release(timeScope); 
release(rx);
