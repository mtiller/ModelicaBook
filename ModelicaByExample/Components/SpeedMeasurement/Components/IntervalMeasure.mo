within ModelicaByExample.Components.SpeedMeasurement.Components;
model IntervalMeasure
  "Estimate speed by measuring interval between encoder teeth"
  extends Interfaces.SpeedSensor;
  parameter Modelica.SIunits.Angle tooth_angle;
  Real next_phi, prev_phi;
  Real last_time;
initial equation
  next_phi = flange.phi+tooth_angle;
  prev_phi = flange.phi-tooth_angle;
  last_time = time;
equation
  when {flange.phi>=pre(next_phi),flange.phi<=pre(prev_phi)} then
    w = tooth_angle/(time-pre(last_time));
    next_phi = flange.phi+tooth_angle;
    prev_phi = flange.phi-tooth_angle;
    last_time = time;
  end when;
end IntervalMeasure;
