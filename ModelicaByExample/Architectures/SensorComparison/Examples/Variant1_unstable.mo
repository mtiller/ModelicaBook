within ModelicaByExample.Architectures.SensorComparison.Examples;
model Variant1_unstable "Choice of sample interval that creates an instability"
  extends Variant1(sensor(sample_time=0.036));
end Variant1_unstable;
