within ModelicaByExample.Architectures.SensorComparison.Implementation;
model SampleHoldSensor "Implementation of a sample hold sensor"
  parameter Modelica.SIunits.Time sample_rate(min=Modelica.Constants.eps);
  Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft
    "Flange of shaft from which sensor information shall be measured"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Blocks.Interfaces.RealOutput w "Absolute angular velocity of flange"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
  Components.SpeedMeasurement.Components.SampleHold sampleHoldSensor(
      sample_rate=sample_rate)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(sampleHoldSensor.w, w) annotation (Line(
      points={{11,0},{110,0}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(sampleHoldSensor.flange, shaft) annotation (Line(
      points={{-10,0},{-100,0}},
      color={0,0,0},
      pattern=LinePattern.None));
  annotation ( Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={128,255,0},
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
          textString="Sample-Hold
Sensor")}));
end SampleHoldSensor;
