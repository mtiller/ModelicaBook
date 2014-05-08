within ModelicaByExample.Architectures.SensorComparison.Implementation;
model ProportionalController "Implementation of a proportional controller"
  parameter Real k=20 "Controller gain";
  Modelica.Blocks.Interfaces.RealInput setpoint "Desired system response"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270, origin={0,120})));
  Modelica.Blocks.Interfaces.RealInput measured "Actual system response"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180, origin={100,0})));
  Modelica.Blocks.Interfaces.RealOutput command "Command to send to actuator"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180, origin={-110,0})));
protected
  Modelica.Blocks.Math.Gain gain(k=k)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180, origin={-50,0})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}})));
equation
  connect(feedback.y, gain.u) annotation (Line(
      points={{-9,0},{2,0},{2,0},{-38,0}},
      color={0,0,127}, smooth=Smooth.None));
  connect(feedback.u1, setpoint) annotation (Line(
      points={{8,0},{40,0},{40,60},{0,60},{0,120}},
      color={0,0,127}, pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(gain.y, command) annotation (Line(
      points={{-61,0},{-80.5,0},{-80.5,0},{-110,0}},
      color={0,0,127}, pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(measured, feedback.u2) annotation (Line(
      points={{100,0},{60,0},{60,-40},{0,-40},{0,-8}},
      color={0,0,127}, smooth=Smooth.None));
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0}, fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-88,-52},{92,-92}},
          pattern=LinePattern.None,
          textString="%name", lineColor={0,0,0}),
        Text(
          extent={{-96,96},{96,-60}},
          lineColor={0,0,0}, fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Prop
Control")}));
end ProportionalController;
