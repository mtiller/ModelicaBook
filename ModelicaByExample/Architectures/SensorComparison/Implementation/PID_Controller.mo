within ModelicaByExample.Architectures.SensorComparison.Implementation;
model PID_Controller "Controller subsystem implemented using a PID controller"
  extends Interfaces.Controller;
  parameter Real k "Gain of controller";
  parameter Modelica.SIunits.Time Ti "Time constant of Integrator block";
  parameter Modelica.SIunits.Time Td "Time constant of Derivative block";
  parameter Real yMax "Upper limit of output";
protected
  Modelica.Blocks.Continuous.LimPID PID(k=k, Ti=Ti, Td=Td, yMax=yMax)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}})));
equation
  connect(setpoint, PID.u_s) annotation (Line(
      points={{0,120},{0,60},{40,60},{40,0},{12,0}},
      color={0,0,127}, pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(measured, PID.u_m) annotation (Line(
      points={{100,0},{60,0},{60,-40},{0,-40},{0,-12}},
      color={0,0,127}, pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(PID.y, command) annotation (Line(
      points={{-11,0},{-110,0}},
      color={0,0,127}, pattern=LinePattern.None,
      smooth=Smooth.None));
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={0,128,255},
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
          textString="PID
Controller")}));
end PID_Controller;
