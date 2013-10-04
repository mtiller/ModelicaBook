within ModelicaByExample.Architectures.SensorComparison.Examples;
model BaseSystem "System architecture with base implementations"
  extends SystemArchitecture(
    redeclare Implementation.ProportionalController controller,
    redeclare Implementation.IdealActuator actuator,
    redeclare Implementation.BasicPlant plant,
    redeclare Implementation.IdealSensor sensor);
end BaseSystem;
