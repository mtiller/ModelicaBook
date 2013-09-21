within ModelicaByExample.Components.SpeedMeasurement.Components;
model IdealSensor "An ideal sensor with no artifact"
  extends Interfaces.SpeedSensor;
equation
  w = der(flange.phi);
end IdealSensor;
