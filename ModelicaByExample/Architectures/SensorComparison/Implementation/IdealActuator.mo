within ModelicaByExample.Architectures.SensorComparison.Implementation;
model IdealActuator "An implementation of an ideal actuator"
  Modelica.Mechanics.Rotational.Interfaces.Flange_b shaft "Output shaft"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Mechanics.Rotational.Interfaces.Support housing
    "Connection to housing"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Blocks.Interfaces.RealInput tau "Input torque command"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
protected
  Modelica.Mechanics.Rotational.Sources.Torque torque(useSupport=true)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(torque.flange, shaft) annotation (Line(
      points={{10,0},{100,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(torque.support, housing) annotation (Line(
      points={{0,-10},{0,-60},{100,-60}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(torque.tau, tau) annotation (Line(
      points={{-12,0},{-120,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-88,-52},{92,-92}},
          pattern=LinePattern.None,
          textString="%name",
          lineColor={0,0,0}),
        Text(
          extent={{-96,96},{96,-60}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Ideal
Actuator")}));
end IdealActuator;
