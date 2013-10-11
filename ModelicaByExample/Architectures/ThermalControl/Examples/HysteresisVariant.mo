within ModelicaByExample.Architectures.ThermalControl.Examples;
model HysteresisVariant "Using on-off controller with hysteresis"
  extends OnOffVariant(redeclare Implementations.OnOffControl_WithHysteresis
      controller(setpoint=300, bandwidth=1));
end HysteresisVariant;
