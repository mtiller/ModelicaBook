within ModelicaByExample.Subsystems.HeatTransfer.Examples;
model ThreeSegmentRod "Modeling a heat transfer using 3 segment rod subsystem"
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heating
    "Heating actuator"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Modelica.Blocks.Sources.Step bc(height=10, startTime=0.5) "Heat profile"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor sensor
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature ambient(T=293.15)
    "Ambient temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90, origin={0,-80})));
  Components.Rod rod(n=3, C=0.3, G_wall=2.7, T0=293.15, G_rod=1.2)
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
equation
  connect(bc.y, heating.Q_flow) annotation (Line(
      points={{-69,60},{-60,60}},
      color={0,0,127}, smooth=Smooth.None));
  connect(heating.port, rod.port_a) annotation (Line(
      points={{-40,60},{-30,60},{-30,0},{-20,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rod.ambient, ambient.port) annotation (Line(
      points={{0,-20},{0,-70},{0,-70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rod.port_b, sensor.port) annotation (Line(
      points={{20,0},{80,0}},
      color={191,0,0},
      smooth=Smooth.None));
end ThreeSegmentRod;
