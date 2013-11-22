within ModelicaByExample.DiscreteBehavior.SynchronousSystems;
model SynchronizedSampling "A simple way to synchronize sampling"
  Integer tick "A clock counter";
  Real x, y;
  Real e "Error between x and y";
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

  e = x-y;
end SynchronizedSampling;
