within ModelicaByExample.Architectures.SensorComparison.Examples;
model Variant1 "Creating sample-hold variant using system architecture"
  extends BaseSystem(redeclare replaceable
      Implementation.SampleHoldSensor sensor(sample_rate=0.01));
end Variant1;
