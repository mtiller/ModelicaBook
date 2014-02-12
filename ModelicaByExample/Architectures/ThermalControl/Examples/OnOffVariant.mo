within ModelicaByExample.Architectures.ThermalControl.Examples;
model OnOffVariant "Variation with on-off control"
  extends ExpandableModel(
    redeclare replaceable
      Implementations.OnOffActuator actuator(heating_capacity=500),
    redeclare replaceable
      Implementations.OnOffControl controller(setpoint=300));
end OnOffVariant;
