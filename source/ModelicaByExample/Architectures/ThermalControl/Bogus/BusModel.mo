within ModelicaByExample.Architectures.ThermalControl.Bogus;
model BusModel "System model using normal bus connectors"
  extends
    ModelicaByExample.Architectures.ThermalControl.Bogus.BusBasedArchitecture(
    redeclare ModelicaByExample.Architectures.ThermalControl.Bogus.BusActuator
                                          actuator,
    redeclare Implementations.ThreeZonePlantModel plant(
      C=2,
      G=1,
      T_ambient=278.15,
      h=2),
    redeclare ModelicaByExample.Architectures.ThermalControl.Bogus.BusSensor
                                        sensor,
    redeclare ModelicaByExample.Architectures.ThermalControl.Bogus.BusPIControl
                                           controller(
      setpoint=300,
      k=20,
      T=1));
end BusModel;
