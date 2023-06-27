rx = comm.SDRuReceiver(Platform = 'N200/N210/USRP2', IPAddress = '192.168.10.2');
rx.CenterFrequency = 13560000;
rx.Gain = 0;
rx.DecimationFactor = 64;
rx.SamplesPerFrame = 4096;

rxLog = dsp.SignalSink;
    for i = 1:20
        data = rx();
        rxLog(data);
    end
display(rxLog.Buffer);

