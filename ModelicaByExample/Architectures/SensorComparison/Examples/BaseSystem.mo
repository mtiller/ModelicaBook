within ModelicaByExample.Architectures.SensorComparison.Examples;
model BaseSystem "System architecture with base implementations"
  extends SystemArchitecture(
    redeclare replaceable Implementation.ProportionalController controller,
    redeclare replaceable Implementation.IdealActuator actuator,
    redeclare replaceable Implementation.BasicPlant plant,
    redeclare replaceable Implementation.IdealSensor sensor);
end BaseSystem;
