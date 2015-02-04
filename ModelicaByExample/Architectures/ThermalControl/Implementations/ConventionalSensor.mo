within ModelicaByExample.Architectures.ThermalControl.Implementations;
model ConventionalSensor "Ideal sensor in a conventional architecture"
  extends Interfaces.Sensor;
protected
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor sensor
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(sensor.T, temperature) annotation (Line(
      points={{10,0},{110,0}},
      color={0,0,127}));
  connect(sensor.port, room) annotation (Line(
      points={{-10,0},{-100,0}},
      color={191,0,0}));
  annotation ( Icon(graphics={
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
          points={{0,40},{0,80},{2,86},{6,88},{12,90},{18,88},{22,86},{24,80},{
              24,40},{0,40}},
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
end ConventionalSensor;
