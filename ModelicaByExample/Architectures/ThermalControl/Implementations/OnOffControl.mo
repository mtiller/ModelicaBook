within ModelicaByExample.Architectures.ThermalControl.Implementations;
model OnOffControl "An example of an on-off controller without hysteresis"
  extends Interfaces.ControlSystem_WithExpandableBus;
  parameter Real setpoint "Desired temperature";
protected
  Modelica.Blocks.Logical.Greater greater
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Trapezoid setpoint_signal(
    amplitude=5, final offset=setpoint, rising=1,
    width=10, falling=1, period=20)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
equation
  connect(greater.y, bus.heat_command) annotation (Line(
      points={{11,0},{60,0},{60,-100},{0,-100}},
      color={255,0,255}, smooth=Smooth.None));
  connect(setpoint_signal.y, greater.u1) annotation (Line(
      points={{-59,0},{-12,0}},
      color={0,0,127}, smooth=Smooth.None));
  connect(bus.temperature, greater.u2) annotation (Line(
      points={{0,-100},{-40,-100},{-40,-8},{-12,-8}},
      color={0,0,0}, smooth=Smooth.None));
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid), Text(
          extent={{-100,30},{100,-30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="On-Off"),
        Text(
          extent={{-100,-40},{100,-60}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="(without hysteresis)")}));
end OnOffControl;
