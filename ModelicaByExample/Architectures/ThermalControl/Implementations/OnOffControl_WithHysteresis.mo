within ModelicaByExample.Architectures.ThermalControl.Implementations;
model OnOffControl_WithHysteresis
  "An example of an on-off controller with hysteresis"

  extends Interfaces.ControlSystem_WithExpandableBus;
  parameter Real setpoint "Desired temperature";
  Modelica.Blocks.Logical.OnOffController controller(bandwidth=bandwidth)
    annotation (Placement(transformation(extent={{-10,-16},{10,4}})));
protected
  Modelica.Blocks.Sources.Trapezoid setpoint_signal(
    amplitude=5, final offset=setpoint,
    rising=1, width=10, falling=1,
    period=20)
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
public
  parameter Real bandwidth "Bandwidth around reference signal";
equation
  connect(setpoint_signal.y, controller.reference) annotation (Line(
      points={{-49,0},{-12,0}},
      color={0,0,127}, smooth=Smooth.None));
  connect(bus.temperature, controller.u) annotation (Line(
      points={{0,-100},{-40,-100},{-40,-12},{-12,-12}},
      color={0,0,0}, smooth=Smooth.None));
  connect(controller.y, bus.heat_command) annotation (Line(
      points={{11,-6},{40,-6},{40,-100},{0,-100}},
      color={255,0,255}, smooth=Smooth.None));
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
          textString="(with hysteresis)")}));
end OnOffControl_WithHysteresis;
