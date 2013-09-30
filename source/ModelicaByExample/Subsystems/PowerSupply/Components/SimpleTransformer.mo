within ModelicaByExample.Subsystems.PowerSupply.Components;
model SimpleTransformer
  parameter Real n;
  extends Modelica.Electrical.Analog.Interfaces.TwoPort;
equation
  i1 + i2/n = 0;
  v1 = n*v2;
end SimpleTransformer;
