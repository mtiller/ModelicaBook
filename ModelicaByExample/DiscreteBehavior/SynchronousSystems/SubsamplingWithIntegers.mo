within ModelicaByExample.DiscreteBehavior.SynchronousSystems;
model SubsamplingWithIntegers "Use integers to implement subsampling"
  Integer tick "Clock counter";
  Real x, y, z;
equation
  when sample(0,0.1) then
    tick = pre(tick)+1;
  end when;

  when change(tick) then
    x = time;
  end when;

  when change(tick) then
    y = time;
  end when;

  when mod(tick-1,2)==0 then
    z = time;
  end when;
end SubsamplingWithIntegers;
