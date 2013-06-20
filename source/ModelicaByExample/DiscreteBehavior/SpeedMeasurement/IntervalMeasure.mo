within ModelicaByExample.DiscreteBehavior.SpeedMeasurement;
model IntervalMeasure "Measure interval between teeth"
  extends SecondOrderSystem;
  parameter Real tooth_angle(unit="rad")=0.31415;
  Real next_phi;
  Real last_time;
  Real omega_measured;
initial equation
  next_phi = phi+tooth_angle;
  last_time = time;
equation
  when phi>=pre(next_phi) then
    omega_measured = tooth_angle/(time-pre(last_time));
    next_phi = phi+tooth_angle;
    last_time = time;
  end when;
end IntervalMeasure;
