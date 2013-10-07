within ModelicaByExample.Architectures.ThermalControl.Implementations;
model ConventionalOnOffControl "Attempt to implement on-off control"
  extends Interfaces.ControlSystem;
  Modelica.Blocks.Logical.Greater greater
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
protected
  Modelica.Blocks.Sources.Trapezoid setpoint_signal(
    amplitude=5,
    final offset=setpoint,
    rising=1,
    width=10,
    falling=1,
    period=20)
    annotation (Placement(transformation(extent={{-30,-48},{-10,-28}})));
public
  Modelica.Blocks.Interfaces.BooleanOutput command "Actuator on-off signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-60,0})));
equation
  connect(temperature, greater.u1) annotation (Line(
      points={{120,0},{0,0},{0,-30},{18,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(setpoint_signal.y, greater.u2) annotation (Line(
      points={{-9,-38},{18,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(greater.y, command) annotation (Line(
      points={{41,-30},{60,-30},{60,-80},{-40,-80},{-40,0},{-60,0}},
      color={255,0,255},
      smooth=Smooth.None));
  annotation (Diagram(graphics={Text(
          extent={{-100,20},{-60,-20}},
          lineColor={255,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="?")}));
end ConventionalOnOffControl;
