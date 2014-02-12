within ModelicaByExample.Architectures.ThermalControl.Examples;
model ExpandableModel "Thermal system using expandable bus architecture"
  extends Architectures.ExpandableArchitecture(
    redeclare replaceable Implementations.ThreeZonePlantModel plant(
      C=2, G=1, T_ambient=278.15, h=2),
    redeclare replaceable Implementations.ContinuousActuator actuator,
    redeclare replaceable Implementations.TemperatureSensor sensor,
    redeclare replaceable Implementations.ExpandablePIControl controller(
      setpoint=300, k=20, T=1));
end ExpandableModel;
