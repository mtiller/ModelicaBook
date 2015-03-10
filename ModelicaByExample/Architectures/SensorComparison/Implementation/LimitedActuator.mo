within ModelicaByExample.Architectures.SensorComparison.Implementation;
model LimitedActuator "An actuator with lag and saturation"
  extends Interfaces.Actuator;
  parameter Modelica.SIunits.Time delayTime
    "Delay time of output with respect to input signal";
  parameter Real uMax "Upper limits of input signals";
protected
  Modelica.Mechanics.Rotational.Sources.Torque torque(useSupport=true)
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=uMax)
    annotation (Placement(transformation(extent={{-18,-10},{2,10}})));
  Modelica.Blocks.Nonlinear.FixedDelay lag(delayTime=delayTime)
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
equation
  connect(torque.flange, shaft) annotation (Line(
      points={{50,0},{100,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(torque.support, housing) annotation (Line(
      points={{40,-10},{40,-60},{100,-60}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(limiter.y, torque.tau) annotation (Line(
      points={{3,0},{28,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(lag.u, tau) annotation (Line(
      points={{-72,0},{-120,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(lag.y, limiter.u) annotation (Line(
      points={{-49,0},{-20,0}},
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
          textString="Limited
Actuator")}));
end LimitedActuator;
