within ModelicaByExample.Components.SpeedMeasurement.Components;
model PulseCounter "Compute speed using pulse counting"
  extends Interfaces.SpeedSensor;
  parameter Modelica.SIunits.Time sample_time;
  parameter Integer teeth;
  Modelica.SIunits.Angle next_phi, prev_phi;
  Integer count;
protected
  parameter Modelica.SIunits.Angle tooth_angle=2*Modelica.Constants.pi/teeth;
initial equation
  next_phi = flange.phi+tooth_angle;
  prev_phi = flange.phi-tooth_angle;
  count = 0;
algorithm
  when {flange.phi>=pre(next_phi), flange.phi<=pre(prev_phi)} then
    next_phi := flange.phi + tooth_angle;
    prev_phi := flange.phi - tooth_angle;
    count := pre(count) + 1;
  end when;
  when sample(0,sample_time) then
    w := pre(count)*tooth_angle/sample_time;
    count := 0 "Another equation for count?";
  end when;
end PulseCounter;
