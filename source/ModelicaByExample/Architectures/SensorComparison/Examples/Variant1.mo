within ModelicaByExample.Architectures.SensorComparison.Examples;
model Variant1 "Creating sample-hold variant using system architecture"
  extends SystemArchitecture_WithDefaults(redeclare
      Implementation.SampleHoldSensor sensor);
end Variant1;
