within ModelicaByExample.Components.Rotational.Examples;
model SMD_WithBacklash "The spring-mass-damper system with backlash"
  extends SMD(inertia2(phi(fixed=true, start=0)), inertia1(phi(fixed=true, start=0), w(start=5)));
  Components.Backlash backlash(c=1000, b(displayUnit="rad") = 0.5)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
equation
  connect(inertia1.flange_b, backlash.flange_a) annotation (Line(
      points={{-70,0},{-50,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(backlash.flange_b, inertia2.flange_a) annotation (Line(
      points={{-30,0},{-10,0}},
      color={0,0,0},
      smooth=Smooth.None));
end SMD_WithBacklash;
