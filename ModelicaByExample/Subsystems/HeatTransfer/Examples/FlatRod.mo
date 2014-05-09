within ModelicaByExample.Subsystems.HeatTransfer.Examples;
model FlatRod "Modeling a heat transfer in a rod in a without subsystems"
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heating
    "Heating actuator"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Modelica.Blocks.Sources.Step bc(height=10, startTime=0.5) "Heat profile"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor C1(C=0.1, T(fixed=true))
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-60,2})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor G1(G=1.2)
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor C2(C=0.1, T(fixed=true))
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={0,2})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor G2(G=1.2)
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor C3(C=0.1, T(fixed=true))
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={60,2})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor sensor
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor wall1(G=0.9)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90, origin={-60,-40})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature ambient(T=293.15)
    "Ambient temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90, origin={0,-80})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor wall2(G=0.9)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90, origin={0,-40})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor wall3(G=0.9)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90, origin={60,-40})));
equation
  connect(bc.y, heating.Q_flow) annotation (Line(
      points={{-69,60},{-60,60}},
      color={0,0,127}, smooth=Smooth.None));
  connect(C1.port, G1.port_a) annotation (Line(
      points={{-60,-8},{-60,-20},{-40,-20}},
      color={191,0,0}, smooth=Smooth.None));
  connect(C2.port, G2.port_a) annotation (Line(
      points={{0,-8},{0,-20},{20,-20}},
      color={191,0,0}, smooth=Smooth.None));
  connect(G2.port_b, C3.port) annotation (Line(
      points={{40,-20},{60,-20},{60,-8}},
      color={191,0,0}, smooth=Smooth.None));
  connect(G1.port_b, C2.port) annotation (Line(
      points={{-20,-20},{0,-20},{0,-8}},
      color={191,0,0}, smooth=Smooth.None));
  connect(heating.port, C1.port) annotation (Line(
      points={{-40,60},{-30,60},{-30,20},{-80,20},{-80,-20},{-60,-20},{-60,-8}},
      color={191,0,0}, smooth=Smooth.None));
  connect(wall1.port_b, C1.port) annotation (Line(
      points={{-60,-30},{-60,-8}},
      color={191,0,0}, smooth=Smooth.None));
  connect(wall1.port_a, ambient.port) annotation (Line(
      points={{-60,-50},{-60,-60},{0,-60},{0,-70}},
      color={191,0,0}, smooth=Smooth.None));
  connect(wall2.port_a, ambient.port) annotation (Line(
      points={{0,-50},{0,-50},{0,-70}},
      color={191,0,0}, smooth=Smooth.None));
  connect(wall3.port_a, ambient.port) annotation (Line(
      points={{60,-50},{60,-60},{0,-60},{0,-70}},
      color={191,0,0}, smooth=Smooth.None));
  connect(wall3.port_b, C3.port) annotation (Line(
      points={{60,-30},{60,-8}},
      color={191,0,0}, smooth=Smooth.None));
  connect(sensor.port, C3.port) annotation (Line(
      points={{80,-20},{60,-20},{60,-8}},
      color={191,0,0}, smooth=Smooth.None));
  connect(C2.port, wall2.port_b) annotation (Line(
      points={{0,-8},{0,-19},{0,-30},{0,-30}},
      color={191,0,0}, pattern=LinePattern.None,
      smooth=Smooth.None));
end FlatRod;
