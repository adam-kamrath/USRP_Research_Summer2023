sampling_rate = 10000000;
decimation_factor = 100000000/sampling_rate;
center_frequency = 13560000;


rx = comm.SDRuReceiver(...
                    Platform = "N200/N210/USRP2", ...
                    IPAddress = '192.168.10.3', ...
                    OutputDataType = "double", ...
                    DecimationFactor = decimation_factor, ...
                    Gain = 0, ...
                    CenterFrequency = center_frequency, ...
                    SamplesPerFrame = 4000);

frameduration = (rx.SamplesPerFrame)/(sampling_rate); 
time = 0; 
timeScope = timescope(TimeSpanSource = "Property",...
                      TimeSpan = 5/30e3,SampleRate = sampling_rate);
timeScope.YLimits = [-1,1];
disp("Reception Started");

while time < 10
  data = rx();
  timeScope(data)
  time = time + frameduration;
end

disp("Reception Stopped");
release(timeScope); 
release(rx);
