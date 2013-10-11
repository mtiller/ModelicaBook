within ModelicaByExample.Chapter2.SpeedMeasurement;
model SampleAndHold "Measure speed and hold"
  extends SecondOrderSystem;
  parameter Real sample_time(unit="s")=0.125;
  Real omega_measured;
equation
  when sample(0,sample_time) then
    omega_measured = omega;
  end when;
end SampleAndHold;
