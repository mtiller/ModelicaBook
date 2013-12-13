within ModelicaByExample.DiscreteBehavior.SpeedMeasurement;
model SampleAndHold "Measure speed and hold"
  extends BasicEquations.RotationalSMD.SecondOrderSystem;
  parameter Real sample_time(unit="s")=0.125;
  discrete Real omega1_measured;
equation
  when sample(0,sample_time) then
    omega1_measured = omega1;
  end when;
end SampleAndHold;
