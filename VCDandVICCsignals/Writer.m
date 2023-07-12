clc
center_frequency = 13560000;
sampling_rate = 2000000;
decimation_factor = round(100000000/sampling_rate);

file_name = 'SOFfinder_test.bb';
file_path = append('C:\Users\akamrath2\Documents\USRP_Research_Summer2023\VCDandVICCsignals\Signals\', file_name);

%Create the receiver object
rx = comm.SDRuReceiver(...
                    Platform = "N200/N210/USRP2", ...
                    IPAddress = '192.168.10.2', ...
                    OutputDataType = "double", ...
                    DecimationFactor = decimation_factor, ...
                    Gain = 3, ...
                    CenterFrequency = center_frequency, ...
                    SamplesPerFrame = 500000);

%Create the file writer object
rxWriter = comm.BasebandFileWriter(file_path, ...
    SampleRate=sampling_rate, ...
    CenterFrequency=center_frequency);

%Create time scope to plot data
timeScope = timescope(TimeSpanSource = "auto",...
                      TimeSpan = 5,SampleRate = sampling_rate, ...
                      Position=[20,200,800,500], ...
                      YLimits=[-.6,.6]);

%Plot 10 seconds of data, one frame at a time
disp("Reception Started");
frameduration = (rx.SamplesPerFrame)/(sampling_rate); 
time = 0; 
while time < 10
  data = rx();
  rxWriter(data);
  timeScope(data)
  time = time + frameduration;
end
disp("Reception Stopped");

%Release instances
release(rxWriter);
release(timeScope); 
release(rx);