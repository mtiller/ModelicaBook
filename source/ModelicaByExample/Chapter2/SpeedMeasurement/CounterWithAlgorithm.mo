within ModelicaByExample.Chapter2.SpeedMeasurement;
model CounterWithAlgorithm "Count teeth in a given interval using an algorithm"
  extends SecondOrderSystem;
  parameter Real sample_time(unit="s")=0.125;
  parameter Real tooth_angle(unit="rad")=0.031415;
  Real next_phi;
  Integer count;
  Real omega_measured;
initial equation
  next_phi = phi+tooth_angle;
  count = 0;
algorithm
  when phi>=pre(next_phi) then
    next_phi :=phi + tooth_angle;
    count :=pre(count) + 1;
  end when;
  when sample(0,sample_time) then
    omega_measured :=pre(count)*tooth_angle/sample_time;
    count :=0;
  end when;
end CounterWithAlgorithm;
