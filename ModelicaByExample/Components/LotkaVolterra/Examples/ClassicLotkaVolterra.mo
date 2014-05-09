within ModelicaByExample.Components.LotkaVolterra.Examples;
model ClassicLotkaVolterra "Includes reproduction, starvation and predation"
  Components.RegionalPopulation rabbits(init=ModelicaByExample.Components.LotkaVolterra.Components.RegionalPopulation.InitializationOptions.FixedPopulation,
      initial_population=10)
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));
  Components.Reproduction reproduction(alpha=0.1) "Reproduction of rabbits"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-80,-30})));
  Components.RegionalPopulation foxes(init=ModelicaByExample.Components.LotkaVolterra.Components.RegionalPopulation.InitializationOptions.FixedPopulation,
      initial_population=10)
    annotation (Placement(transformation(extent={{30,-40},{50,-20}})));
  Components.Starvation fox_starvation(gamma=0.4) "Starvation of foxes"
    annotation (Placement(transformation(extent={{70,-40},{90,-20}})));
  Components.Predation fox_predation(beta=0.02, delta=0.02)
    "Foxes eating rabbits"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(reproduction.species, rabbits.species) annotation (Line(
      points={{-80,-20},{-80,0},{-40,0},{-40,-20}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(fox_predation.a, rabbits.species) annotation (Line(
      points={{-10,0},{-40,0},{-40,-20}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(fox_starvation.species, foxes.species) annotation (Line(
      points={{80,-20},{80,0},{40,0},{40,-20}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(foxes.species, fox_predation.b) annotation (Line(
      points={{40,-20},{40,0},{10,0}},
      color={0,127,0},
      smooth=Smooth.None));
  annotation (experiment(StopTime=100, Tolerance=1e-006));
end ClassicLotkaVolterra;
