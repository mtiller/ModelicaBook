within ModelicaByExample.Architectures.ThermalControl.Implementations;
model ConventionalPIControl "PIControl using conventional architecture"
  extends Interfaces.ControlSystem;
  parameter Real setpoint "Desired temperature";
  parameter Real k=1 "Gain";
  parameter Modelica.SIunits.Time T "Time Constant (T>0 required)";
protected
  Modelica.Blocks.Sources.Trapezoid setpoint_signal(
    amplitude=5, final offset=setpoint,
    rising=1, width=10,
    falling=1, period=20)
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{10,-10},{-10,10}})));
  Modelica.Blocks.Continuous.PI PI(final T=T, final k=-k)
    annotation (Placement(transformation(extent={{-30,-10},{-50,10}})));
equation
  connect(setpoint_signal.y, feedback.u2)
    annotation (Line(
      points={{-19,-30},{0,-30},{0,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PI.u, feedback.y) annotation (Line(
      points={{-28,0},{-9,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(feedback.u1, temperature) annotation (Line(
      points={{8,0},{120,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PI.y, heat) annotation (Line(
      points={{-51,0},{-110,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation ( Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid), Text(
          extent={{-100,60},{100,-60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="PI")}));
end ConventionalPIControl;
