within ModelicaByExample.DiscreteBehavior.BouncingBall;
model StableBouncingBall
  "The 'classic' bouncing ball model with numerical tolerances"
  type Height=Real(unit="m");
  type Velocity=Real(unit="m/s");
  parameter Real e=0.8 "Coefficient of restitution";
  parameter Height h0=1.0 "Initial height";
  constant Height eps=1e-3 "Small height";
  Boolean done "Flag when to turn off gravity";
  Height h "Height";
  Velocity v(start=0.0, fixed=true) "Velocity";
initial equation
  h = h0;
  done = false;
equation
  v = der(h);
  der(v) = if done then 0 else -9.81;
  when {h<0,h<-eps} then
    done = h<-eps;
    reinit(v, -e*(if h<-eps then 0 else pre(v)));
  end when;
end StableBouncingBall;
