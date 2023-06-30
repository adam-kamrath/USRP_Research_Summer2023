sampling_rate = 240000;
decimation_factor = 100000000/sampling_rate;
center_frequency = 13560000;

reader = comm.BasebandFileReader('capture.bb', 400);

timeScope = timescope(TimeSpanSource = "Property",...
                      TimeSpan = 5/30e3,SampleRate = sampling_rate);
timeScope.YLimits = [-.2,.2];
data = reader();
timeScope(data);

release(timeScope);
release(reader);