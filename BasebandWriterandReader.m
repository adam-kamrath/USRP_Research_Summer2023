rx = comm.SDRuReceiver(...
              Platform ="N200/N210/USRP2", ...
              CenterFrequency =13.56e6, ...
              Gain = 2);
sampleRate = rx.MasterClockRate/rx.DecimationFactor;
rxWriter = comm.BasebandFileWriter('b200_capture.bb', ...
         sampleRate,rx.CenterFrequency)
for counter = 1:2000
    data = rx();
    rxWriter(data);
end
info(rxWriter);
bbr = comm.BasebandFileReader('C:\Users\akamrath2\Desktop\b200_capture.bb', SamplesPerFrame=inf)
info(bbr)
samples = bbr()
release(bbr)
release(rx);
release(rxWriter);