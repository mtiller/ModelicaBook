within ModelicaByExample.Components.Electrical.Examples;
model SwitchedRLC "Recreation of the switched RLC circuit"
  DryApproach.StepVoltage Vs(V0=0, Vf=24, stepTime=0.5)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-40,0})));
  DryApproach.Inductor inductor(L=1, i(fixed=true, start=0))
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  DryApproach.Capacitor capacitor(C=1e-3, v(fixed=true, start=0))
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={30,0})));
  DryApproach.Resistor resistor(R=100) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,2})));
  DryApproach.Ground ground
    annotation (Placement(transformation(extent={{-10,-38},{10,-18}})));
equation
  connect(inductor.n, resistor.n) annotation (Line(
      points={{10,20},{60,20},{60,12}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(capacitor.n, inductor.n) annotation (Line(
      points={{30,10},{30,20},{10,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(inductor.p, Vs.p) annotation (Line(
      points={{-10,20},{-40,20},{-40,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(capacitor.p, ground.ground) annotation (Line(
      points={{30,-10},{30,-20},{0,-20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(resistor.p, ground.ground) annotation (Line(
      points={{60,-8},{60,-20},{0,-20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(Vs.n, ground.ground) annotation (Line(
      points={{-40,-10},{-40,-20},{0,-20}},
      color={0,0,255},
      smooth=Smooth.None));
end SwitchedRLC;
