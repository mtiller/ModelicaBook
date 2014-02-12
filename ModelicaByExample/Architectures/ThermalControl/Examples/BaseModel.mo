within ModelicaByExample.Architectures.ThermalControl.Examples;
model BaseModel "Base model using a conventional architecture"
  extends Architectures.BaseArchitecture(
    redeclare Implementations.ThreeZonePlantModel plant(
      C=2, G=1, h=2, T_ambient=278.15),
    redeclare
      ModelicaByExample.Architectures.ThermalControl.Implementations.ConventionalPIControl
      controller(setpoint=300, T=1, k=20),
    redeclare Implementations.ConventionalActuator actuator,
    redeclare Implementations.ConventionalSensor sensor);
end BaseModel;
