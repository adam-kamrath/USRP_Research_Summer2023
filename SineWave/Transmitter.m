center_frequency = 13560000;
sampling_rate = 240000;
interpolation_factor = round(100000000/sampling_rate);

tx = comm.SDRuTransmitter(...
                    Platform = "N200/N210/USRP2", ...
                    IPAddress = '192.168.10.3', ...
                    MasterClockRate = 100e6, ...
                    InterpolationFactor = interpolation_factor, ...
                    Gain = 0, ...
                    CenterFrequency = center_frequency, ...
                    TransportDataType = "int16");

sinewave = dsp.SineWave(1,30e3); 
sinewave.SampleRate = sampling_rate; 
sinewave.SamplesPerFrame = 400; 
sinewave.OutputDataType = 'double'; 
sinewave.ComplexOutput = true;
data = step(sinewave);

frameDuration = (sinewave.SamplesPerFrame)/(sinewave.SampleRate); 
time = 0;
disp("Transmission Started"); 

while time < 30
    tx(data); 
    time = time+frameDuration; 
end 
disp("Transmission Stopped"); 
release(tx);