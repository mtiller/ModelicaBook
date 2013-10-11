within ModelicaByExample.Components.SpeedMeasurement.Interfaces;
partial model SpeedSensor "The base class for all of our sensor models"
  extends Modelica.Mechanics.Rotational.Interfaces.PartialAbsoluteSensor;
  Modelica.Blocks.Interfaces.RealOutput w "Sensed speed"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
end SpeedSensor;
