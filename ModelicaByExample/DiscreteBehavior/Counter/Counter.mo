within ModelicaByExample.DiscreteBehavior.Counter;
model Counter "Counting samples"
  type Time = Real(unit="s");
  parameter Time interval=100e-3;
  Integer count;
initial equation
  count = 0;
equation
  when sample(interval, interval) then
    count = pre(count)+1;
  end when;
end Counter;
