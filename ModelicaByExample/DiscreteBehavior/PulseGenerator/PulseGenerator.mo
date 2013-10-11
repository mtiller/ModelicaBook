within ModelicaByExample.DiscreteBehavior.PulseGenerator;
model PulseGenerator "A model that produces pulses at a fixed interval"
  type Time=Real(unit="s");
  parameter Time width=100e-3;
  Boolean pulse;
initial equation
  pulse = false;
equation
  when sample(width,width) then
    pulse = not pre(pulse);
  end when;
end PulseGenerator;
