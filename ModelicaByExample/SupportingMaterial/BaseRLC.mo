within ModelicaByExample.SupportingMaterial;
model BaseRLC
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  Modelica.Electrical.Analog.Basic.Resistor resistor(R=100) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,0})));
  Modelica.Electrical.Analog.Basic.Capacitor capacitor(C=1e-3) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={20,0})));
  Modelica.Electrical.Analog.Basic.Inductor inductor(L=1)
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage source(V=24) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-60,0})));
  Modelica.Electrical.Analog.Ideal.IdealClosingSwitch switch
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  Modelica.Blocks.Sources.BooleanStep step(startTime=0.5)
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
equation
  connect(source.n, ground.p) annotation (Line(
      points={{-60,-10},{-60,-40},{0,-40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(switch.n, inductor.p) annotation (Line(
      points={{-30,30},{-10,30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(switch.p, source.p) annotation (Line(
      points={{-50,30},{-60,30},{-60,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(step.y, switch.control) annotation (Line(
      points={{-59,60},{-40,60},{-40,37}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(inductor.n, capacitor.p) annotation (Line(
      points={{10,30},{20,30},{20,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(capacitor.n, ground.p) annotation (Line(
      points={{20,-10},{20,-40},{0,-40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(inductor.n, resistor.p) annotation (Line(
      points={{10,30},{50,30},{50,10},{50,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(resistor.n, ground.p) annotation (Line(
      points={{50,-10},{50,-40},{0,-40}},
      color={0,0,255},
      smooth=Smooth.None));
end BaseRLC;
