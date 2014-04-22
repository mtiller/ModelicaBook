within ModelicaByExample.Architectures.ThermalControl.Implementations;
model TemperatureSensor "Temperature sensor using an expandable bus"
  extends Interfaces.Sensor_WithExpandableBus;
protected
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor sensor
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(sensor.T, bus.temperature) annotation (Line(
      points={{10,0},{100,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(room, sensor.port) annotation (Line(
      points={{-100,0},{-10,0}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Icon(graphics={
        Ellipse(
          extent={{-8,-98},{32,-60}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,40},{24,-68}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,40},{0,80},{2,86},{6,88},{12,90},{18,88},{22,86},{24,80},{24,
              40},{0,40}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{0,40},{0,-64}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{24,40},{24,-64}},
          color={0,0,0},
          thickness=0.5),
        Line(points={{-28,-20},{0,-20}},   color={0,0,0}),
        Line(points={{-28,20},{0,20}},   color={0,0,0}),
        Line(points={{-28,60},{0,60}},   color={0,0,0}),
        Text(
          extent={{94,-28},{52,-78}},
          lineColor={0,0,0},
          textString="K")}));
end TemperatureSensor;
