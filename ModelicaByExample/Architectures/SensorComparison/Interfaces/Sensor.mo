within ModelicaByExample.Architectures.SensorComparison.Interfaces;
partial model Sensor "Interface for sensor"
  Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft
    "Flange of shaft from which sensor information shall be measured"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Blocks.Interfaces.RealOutput w "Absolute angular velocity of flange"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  annotation (Icon(graphics={Rectangle(extent={{-100,100},{
              100,-100}}, lineColor={128,255,0})}));
end Sensor;
