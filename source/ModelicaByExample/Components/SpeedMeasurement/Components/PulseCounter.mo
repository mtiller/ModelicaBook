within ModelicaByExample.Components.SpeedMeasurement.Components;
model PulseCounter "Compute speed using pulse counting"
  extends Interfaces.SpeedSensor;
  parameter Modelica.SIunits.Time sample_time;
  parameter Modelica.SIunits.Angle tooth_angle;
  Modelica.SIunits.Angle next_phi;
  Integer count;
initial equation
  next_phi = flange.phi+tooth_angle;
  count = 0;
algorithm
  when flange.phi>=pre(next_phi) then
    next_phi :=flange.phi + tooth_angle;
    count :=pre(count) + 1;
  end when;
  when sample(0,sample_time) then
    w :=pre(count)*tooth_angle/sample_time;
    count :=0 "Another equation for count?";
  end when;
end PulseCounter;
