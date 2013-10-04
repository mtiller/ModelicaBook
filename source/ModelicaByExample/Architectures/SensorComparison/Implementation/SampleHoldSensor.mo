within ModelicaByExample.Architectures.SensorComparison.Implementation;
model SampleHoldSensor "Implementation of a sample hold sensor"
  Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft
    "Flange of shaft from which sensor information shall be measured"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Blocks.Interfaces.RealOutput w "Absolute angular velocity of flange"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Components.SpeedMeasurement.Components.SampleHold sampleHoldSensor(
      sample_rate=sample_rate)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  parameter Modelica.SIunits.Time sample_rate=0.01;
equation
  connect(sampleHoldSensor.w, w) annotation (Line(
      points={{11,0},{110,0}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(sampleHoldSensor.flange, shaft) annotation (Line(
      points={{-10,0},{-100,0}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end SampleHoldSensor;
