within ModelicaByExample.Subsystems.PowerSupply.Examples;
model FlatCircuit "A model with power source, AC-DC conversion and load in one diagram"
  import Modelica.Electrical.Analog;
  Analog.Sources.SineVoltage wall_voltage(V=120, freqHz=60)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270, origin={-90,0})));
  Analog.Ideal.IdealClosingSwitch switch(Goff=0)
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Analog.Ideal.IdealTransformer transformer(Lm1=1, n=10, considerMagnetization=false)
    annotation (Placement(transformation(extent={{-50,0},{-30,20}})));
  Analog.Ideal.IdealDiode D1(Vknee=0, Ron=1e-5, Goff=1e-5)
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=45, origin={-12,20})));
  Analog.Basic.Capacitor capacitor(C=1e-2)
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270, origin={60,-10})));
  Analog.Basic.Resistor load(R=100)
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270, origin={100,-10})));
  Modelica.Blocks.Sources.BooleanStep step(startTime=0.25)
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Analog.Ideal.IdealDiode D2(Vknee=0, Ron=1e-5, Goff=1e-5)
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-45, origin={12,20})));
  Analog.Ideal.IdealDiode D3(Vknee=0, Ron=1e-5, Goff=1e-5)
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-45, origin={-12,0})));
  Analog.Ideal.IdealDiode D4(Vknee=0, Ron=1e-5, Goff=1e-5)
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=45, origin={12,0})));
  Analog.Basic.Ground ground1
    annotation (Placement(transformation(extent={{-100,-52},{-80,-32}})));
equation
  connect(D1.p, D3.p) annotation(
    Line(points = {{-19, 13}, {-19, 13}, {-19, 7}, {-19, 7}}, color = {0, 0, 255}));
  connect(load.p, capacitor.p) annotation (Line(
      points = {{100, 0}, {100, 13}, {60, 13}, {60, 0}},
      color={0,0,255}));
  connect(load.p, D2.n) annotation (Line(
      points = {{100, 0}, {100, 13}, {19, 13}, {19, 12.9289}, {19.0711, 12.9289}},
      color={0,0,255}));
  connect(D1.n, D2.p) annotation(
    Line(points = {{-5, 27}, {5, 27}, {5, 27}, {5, 27}}, color = {0, 0, 255}));
  connect(switch.p, wall_voltage.p) annotation (Line(
      points={{-80,40},{-90,40},{-90,10}},
      color={0,0,255}, smooth=Smooth.None));
  connect(switch.n, transformer.p1) annotation (Line(
      points={{-60,40},{-50,40},{-50,15}},
      color={0,0,255}, smooth=Smooth.None));
  connect(step.y, switch.control) annotation (Line(
      points={{-79,60},{-70,60},{-70,47}},
      color={255,0,255}, smooth=Smooth.None));
  connect(D3.n, D4.p) annotation (Line(
      points={{-4.92893,-7.07107},{-2.46446,-7.07107},{-2.46446,-7.07107},{
          1.09406e-006,-7.07107},{1.09406e-006,-7.07107},{4.92893,-7.07107}},
      color={0,0,255}, smooth=Smooth.None));
  connect(D2.n, D4.n) annotation (Line(
      points={{19.0711,12.9289},{19.0711,11.4644},{19.0711,11.4644},{19.0711,10},
          {19.0711,7.07107},{19.0711,7.07107}},
      color={0,0,255}, smooth=Smooth.None));
  connect(transformer.p2, D1.n) annotation (Line(
      points={{-30,15},{-30,34},{0,34},{0,27.0711},{-4.92893,27.0711}},
      color={0,0,255}, smooth=Smooth.None));
  connect(D4.p, transformer.n2) annotation (Line(
      points={{4.92893,-7.07107},{0,-7.07107},{0,-20},{-30,-20},{-30,5}},
      color={0,0,255}, smooth=Smooth.None));
  connect(wall_voltage.n, transformer.n1) annotation (Line(
      points={{-90,-10},{-90,-20},{-50,-20},{-50,5}},
      color={0,0,255}, smooth=Smooth.None));
  connect(wall_voltage.n, ground1.p) annotation (Line(
      points={{-90,-10},{-90,-32}},
      color={0,0,255}, smooth=Smooth.None));
  connect(transformer.n2, ground1.p) annotation (Line(
      points={{-30,5},{-30,-32},{-90,-32}},
      color={0,0,255}, smooth=Smooth.None));
  connect(D1.p, capacitor.n) annotation (Line(
      points={{-19.0711,12.9289},{-24,12.9289},{-24,-32},{60,-32},{60,-20}},
      color={0,0,255}, smooth=Smooth.None));
  connect(load.n, capacitor.n) annotation (Line(
      points={{100,-20},{100,-32},{60,-32},{60,-20}},
      color={0,0,255}, smooth=Smooth.None));
end FlatCircuit;
