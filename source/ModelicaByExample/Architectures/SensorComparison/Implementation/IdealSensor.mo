within ModelicaByExample.Architectures.SensorComparison.Implementation;
model IdealSensor "Implementation of an ideal sensor"
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor idealSpeedSensor
    "An ideal speed sensor" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,0})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft
    "Flange of shaft from which sensor information shall be measured"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Blocks.Interfaces.RealOutput w "Absolute angular velocity of flange"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  connect(idealSpeedSensor.flange, shaft) annotation (Line(
      points={{-10,0},{-100,0}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(idealSpeedSensor.w, w) annotation (Line(
      points={{11,0},{110,0}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end IdealSensor;
