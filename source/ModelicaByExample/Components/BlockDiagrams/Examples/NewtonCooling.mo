within ModelicaByExample.Components.BlockDiagrams.Examples;
model NewtonCooling "Newton cooling system modeled with blocks"
  parameter Real h = 0.7;
  parameter Real m = 0.1;
  parameter Real c_p = 1.2;
  parameter Real T_inf = 27.5;
  Components.Integrator T(y0=20)
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Components.Gain gain(k=-1)
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Components.Constant ambient(k=T_inf)
    annotation (Placement(transformation(extent={{10,-40},{30,-20}})));
  Components.Sum sum(nin=2)
    annotation (Placement(transformation(extent={{52,-20},{72,0}})));
  Components.Gain gain1(k=h/(m*c_p))
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
equation
  connect(T.y, gain.u) annotation (Line(
      points={{-9,0},{9,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sum.y, gain1.u) annotation (Line(
      points={{73,-10},{80,-10},{80,20},{-80,20},{-80,0},{-71,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(gain.y, sum.u[2]) annotation (Line(
      points={{31,0},{40,0},{40,-9.5},{51,-9.5}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(ambient.y, sum.u[1]) annotation (Line(
      points={{31,-30},{40,-30},{40,-10.5},{51,-10.5}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(gain1.y, T.u) annotation (Line(
      points={{-49,0},{-31,0}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end NewtonCooling;
