within ModelicaByExample.Architectures.ThermalControl.Implementations;
model ContinuousActuator
  "Actuator taking continuous heat command from expandable bus"
  extends Interfaces.Actuator_WithExpandableBus;
protected
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=Modelica.Constants.inf, uMin=0)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
protected
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heater
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(limiter.y,heater. Q_flow) annotation (Line(
      points={{-39,0},{-10,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heater.port, furnace) annotation (Line(
      points={{10,0},{100,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(limiter.u, bus.heat) annotation (Line(
      points={{-62,0},{-100,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(graphics={
        Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-40,60},{-40,50},{-50,40},{-30,30},{-50,20},{-30,10},{-50,0},
              {-30,-10},{-50,-20},{-30,-30},{-50,-40},{-40,-50},{-40,-60}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-20,60},{-20,50},{-30,40},{-10,30},{-30,20},{-10,10},{-30,0},
              {-10,-10},{-30,-20},{-10,-30},{-30,-40},{-20,-50},{-20,-60}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{0,60},{0,50},{-10,40},{10,30},{-10,20},{10,10},{-10,0},{10,-10},
              {-10,-20},{10,-30},{-10,-40},{0,-50},{0,-60}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{20,60},{20,50},{10,40},{30,30},{10,20},{30,10},{10,0},{30,-10},
              {10,-20},{30,-30},{10,-40},{20,-50},{20,-60}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{40,60},{40,50},{30,40},{50,30},{30,20},{50,10},{30,0},{50,-10},
              {30,-20},{50,-30},{30,-40},{40,-50},{40,-60}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5)}));
end ContinuousActuator;
