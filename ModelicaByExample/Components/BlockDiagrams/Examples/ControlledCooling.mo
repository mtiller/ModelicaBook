within ModelicaByExample.Components.BlockDiagrams.Examples;
model ControlledCooling "Adding a setpoint and control strategy"
  import Modelica.SIunits.Conversions.from_degC;
  parameter Real h = 0.7 "Convection coefficient";
  parameter Real m = 0.1 "Thermal maass";
  parameter Real c_p = 1.2 "Specific heat";
  parameter Real T_inf = from_degC(27.5) "Ambient temperature";
  parameter Real T_bar = from_degC(30.0) "Desired temperature";
  parameter Real k = 2.0 "Controller gain";
  Components.Integrator T(y0=Modelica.SIunits.Conversions.from_degC(20))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Components.Constant ambient(k=T_inf)
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Components.Gain gain1(k=1/(m*c_p))
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Components.Gain convection(k=h)
    annotation (Placement(transformation(extent={{50,-40},{70,-20}})));
  Components.Sum total_heat(nin=2)
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Components.Constant setpoint(k=T_bar)
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Components.Feedback feedback
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Components.Feedback feedback1
    annotation (Placement(transformation(extent={{20,-20},{40,-40}})));
  Components.Gain convection1(k=k)
    annotation (Placement(transformation(extent={{50,20},{70,40}})));
equation
  connect(gain1.y, T.u) annotation (Line(
      points={{-19,0},{-11,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(total_heat.y, gain1.u) annotation (Line(
      points={{-49,0},{-41,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(convection.y, total_heat.u[1]) annotation (Line(
      points={{71,-30},{80,-30},{80,-60},{-80,-60},{-80,-0.5},{-71,-0.5}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(setpoint.y, feedback.u1) annotation (Line(
      points={{11,30},{19,30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(feedback1.y, convection.u) annotation (Line(
      points={{40,-30},{49,-30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(ambient.y, feedback1.u1) annotation (Line(
      points={{11,-30},{19,-30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(T.y, feedback1.u2) annotation (Line(
      points={{11,0},{30,0},{30,-19}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(T.y, feedback.u2) annotation (Line(
      points={{11,0},{30,0},{30,19}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(feedback.y, convection1.u) annotation (Line(
      points={{40,30},{49,30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(convection1.y, total_heat.u[2]) annotation (Line(
      points={{71,30},{80,30},{80,60},{-80,60},{-80,0.5},{-71,0.5}},
      color={0,0,255},
      smooth=Smooth.None));
end ControlledCooling;
