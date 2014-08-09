within ModelicaByExample.Components.BlockDiagrams.Examples;
model MultiDomainControl
  "Mixing thermal components with blocks for sensing, actuation and control"

  import Modelica.SIunits.Conversions.from_degC;

  parameter Real h = 0.7 "Convection coefficient";
  parameter Real A = 1.0 "Area";
  parameter Real m = 0.1 "Thermal maass";
  parameter Real c_p = 1.2 "Specific heat";
  parameter Real T_inf = from_degC(25) "Ambient temperature";
  parameter Real T_bar = from_degC(30.0) "Desired temperature";
  parameter Real k = 2.0 "Controller gain";

  Components.Constant setpoint(k=T_bar)
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Components.Feedback feedback
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Components.Gain controller_gain(k=k) "Gain for the proportional control"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  HeatTransfer.ThermalCapacitance cap(C=m*c_p, T0 = from_degC(90))
    "Thermal capacitance component"
    annotation (Placement(transformation(extent={{-30,-30},{-10,-10}})));
  HeatTransfer.Convection convection2(h=h*A)
    annotation (Placement(transformation(extent={{10,-30},{30,-10}})));
  HeatTransfer.AmbientCondition
                   amb(T_amb(displayUnit="K") = T_inf)
    annotation (Placement(transformation(extent={{50,-30},{70,-10}})));
  Components.IdealTemperatureSensor sensor annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,10})));
  Components.HeatSource heatSource
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
equation
  connect(setpoint.y, feedback.u1) annotation (Line(
      points={{-19,40},{-11,40}}, color={0,0,255},
      smooth=Smooth.None));
  connect(feedback.y, controller_gain.u) annotation (Line(
      points={{10,40},{19,40}}, color={0,0,255},
      smooth=Smooth.None));
  connect(convection2.port_a, cap.node) annotation (Line(
      points={{10,-20},{-20,-20}}, color={191,0,0},
      smooth=Smooth.None));
  connect(amb.node, convection2.port_b) annotation (Line(
      points={{60,-20},{30,-20}}, color={191,0,0},
      smooth=Smooth.None));
  connect(sensor.y, feedback.u2) annotation (Line(
      points={{0,21},{0,24.5},{0,24.5},{0,29}},
      color={0,0,255}, pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(heatSource.node, cap.node) annotation (Line(
      points={{-40,-20},{-20,-20}}, color={191,0,0},
      pattern=LinePattern.None, smooth=Smooth.None));
  connect(controller_gain.y, heatSource.u) annotation (Line(
      points={{41,40},{50,40},{50,60},{-70,60},{-70,-20},{-61,-20}},
      color={0,0,255}, pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(sensor.node, cap.node) annotation (Line(
      points={{0,0},{0,0},{0,-20},{-20,-20}},
      color={191,0,0}, pattern=LinePattern.None,
      smooth=Smooth.None));
end MultiDomainControl;
