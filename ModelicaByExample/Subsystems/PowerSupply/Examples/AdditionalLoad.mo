within ModelicaByExample.Subsystems.PowerSupply.Examples;
model AdditionalLoad "A circuit with an additional transient load"
  extends SubsystemCircuit;
  Modelica.Electrical.Analog.Basic.Resistor add_load(R=10)
                                                        annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={90,0})));
  Modelica.Electrical.Analog.Ideal.IdealClosingSwitch switch1(
                                                             Goff=0)
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Modelica.Blocks.Sources.BooleanStep load_step(startTime=0.7)
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
equation
  connect(switch1.n, add_load.p) annotation (Line(
      points={{80,20},{90,20},{90,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(switch1.p, load.p) annotation (Line(
      points={{60,20},{50,20},{50,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(add_load.n, load.n) annotation (Line(
      points={{90,-10},{90,-10},{90,-20},{50,-20},{50,-10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(load_step.y, switch1.control) annotation (Line(
      points={{61,50},{70,50},{70,27}},
      color={255,0,255},
      smooth=Smooth.None));
end AdditionalLoad;
