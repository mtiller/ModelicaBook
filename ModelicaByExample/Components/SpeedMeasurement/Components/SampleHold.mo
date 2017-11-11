within ModelicaByExample.Components.SpeedMeasurement.Components;
model SampleHold "A sample-hold ideal speed sensor"
  extends Interfaces.SpeedSensor;
  parameter Modelica.SIunits.Time sample_time;
initial equation
  w = der(flange.phi);
equation
  when sample(0, sample_time) then
    w = der(flange.phi);
  end when;
end SampleHold;
