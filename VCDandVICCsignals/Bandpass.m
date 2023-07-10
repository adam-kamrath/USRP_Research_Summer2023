bandpassSpecs = fdesign.bandpass('N,Fst1,Fp1,Fp2,Fst2,C',300,4e5,4.25e5,4.5e5,4.75e5,2e6);
bandpassSpecs.Stopband1Constrained = true;
bandpassSpecs.Astop1 = 60;
bandpassSpecs.Stopband2Constrained = true;
bandpassSpecs.Astop2 = 60;

BandpassFilter = design(bandpassSpecs, 'Systemobject', true);
fvtool(BandpassFilter)
measure(BandpassFilter)
release(BandpassFilter);