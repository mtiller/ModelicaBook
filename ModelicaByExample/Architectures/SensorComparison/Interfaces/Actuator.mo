within ModelicaByExample.Architectures.SensorComparison.Interfaces;
partial model Actuator "Interface for actuator"
  Modelica.Mechanics.Rotational.Interfaces.Flange_b shaft "Output shaft"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Mechanics.Rotational.Interfaces.Support housing
    "Connection to housing"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Blocks.Interfaces.RealInput tau "Input torque command"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  annotation (Icon(graphics={Rectangle(extent={{-100,100},{
              100,-100}}, lineColor={255,85,85})}));
end Actuator;
