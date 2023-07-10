filename = '13_54.bb';
center_frequency = 13540000;
sampling_rate = 2000000;
decimation_factor = round(100000000/sampling_rate);

rx = comm.SDRuReceiver(...
                    Platform = "N200/N210/USRP2", ...
                    IPAddress = '192.168.10.2', ...
                    OutputDataType = "double", ...
                    DecimationFactor = decimation_factor, ...
                    Gain = 0, ...
                    CenterFrequency = center_frequency, ...
                    SamplesPerFrame = 200000);

filepath = append('C:\Users\akamrath2\Documents\USRP_Research_Summer2023\VCDsignals\Signals\', filename);
rxWriter = comm.BasebandFileWriter(filepath, ...
    SampleRate=sampling_rate, ...
    CenterFrequency=center_frequency);

timeScope = timescope(TimeSpanSource = "auto",...
                      TimeSpan = 5,SampleRate = sampling_rate, ...
                      Position=[20,200,800,500]);
timeScope.YLimits = [-.6,.6];

disp("Reception Started");
frameduration = (rx.SamplesPerFrame)/(sampling_rate); 
time = 0; 
while time < 5
  data = rx();
  rxWriter(data);
  timeScope(data)
  time = time + frameduration;
end

disp("Reception Stopped");
release(rxWriter);
release(timeScope); 
release(rx);