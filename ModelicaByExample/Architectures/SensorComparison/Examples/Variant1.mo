within ModelicaByExample.Architectures.SensorComparison.Examples;
model Variant1 "Creating sample-hold variant using system architecture"
  extends SystemArchitecture_WithDefaults(redeclare replaceable
      Implementation.SampleHoldSensor sensor);
end Variant1;
