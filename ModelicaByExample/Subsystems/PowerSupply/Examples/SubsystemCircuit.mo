within ModelicaByExample.Subsystems.PowerSupply.Examples;
model SubsystemCircuit "Example using BasicPowerSupply subsystem"
  Components.BasicPowerSupply power_supply(
    C=1e-2,
    n=10,
    considerMagnetization=false,
    Lm1=1e-2)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Electrical.Analog.Sources.SineVoltage wall_voltage(V=120, freqHz=60)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-80,0})));
  Modelica.Electrical.Analog.Ideal.IdealClosingSwitch switch(Goff=0)
    annotation (Placement(transformation(extent={{-70,30},{-50,50}})));
  Modelica.Blocks.Sources.BooleanStep step(startTime=0.25)
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
  Modelica.Electrical.Analog.Basic.Ground ground1
    annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));
  Modelica.Electrical.Analog.Basic.Resistor load(R=100) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,0})));
equation
  connect(switch.p,wall_voltage. p) annotation (Line(
      points={{-70,40},{-80,40},{-80,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(step.y,switch. control) annotation (Line(
      points={{-69,70},{-60,70},{-60,47}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(wall_voltage.n, ground1.p) annotation (Line(
      points={{-80,-10},{-80,-40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(wall_voltage.n, power_supply.gnd)     annotation (Line(
      points={{-80,-10},{-80,-40},{-26,-40},{-26,-6},{-10,-6}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(switch.n, power_supply.p)     annotation (Line(
      points={{-50,40},{-26,40},{-26,6},{-10,6}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(load.p, power_supply.p_load)     annotation (Line(
      points={{50,10},{50,20},{20,20},{20,6},{10,6}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(load.n, power_supply.n_load)     annotation (Line(
      points={{50,-10},{50,-20},{20,-20},{20,-6},{10,-6}},
      color={0,0,255},
      smooth=Smooth.None));
end SubsystemCircuit;
