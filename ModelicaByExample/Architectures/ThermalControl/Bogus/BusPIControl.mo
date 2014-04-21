within ModelicaByExample.Architectures.ThermalControl.Bogus;
model BusPIControl "PI control using bus connectors"
  extends
    ModelicaByExample.Architectures.ThermalControl.Bogus.ControlSystem_WithBus;
  parameter Real setpoint "Desired temperature";
  parameter Real k=1 "Gain";
  parameter Modelica.SIunits.Time T "Time Constant (T>0 required)";
protected
  Modelica.Blocks.Sources.Trapezoid const(
    amplitude=5,
    final offset=setpoint,
    rising=1,
    width=10,
    falling=1,
    period=20)
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{30,-10},{10,10}})));
  Modelica.Blocks.Continuous.PI PI(final T=T, final k=-k)
    annotation (Placement(transformation(extent={{-10,-10},{-30,10}})));
equation
  connect(const.y, feedback.u2) annotation (Line(
      points={{1,-30},{20,-30},{20,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PI.u, feedback.y) annotation (Line(
      points={{-8,0},{11,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(basicBus.temperature, feedback.u1) annotation (Line(
      points={{0,-100},{60,-100},{60,0},{28,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(PI.y, basicBus.heat) annotation (Line(
      points={{-31,0},{-60,0},{-60,-100},{0,-100}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid), Text(
          extent={{-100,60},{100,-60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="PI")}));
end BusPIControl;
