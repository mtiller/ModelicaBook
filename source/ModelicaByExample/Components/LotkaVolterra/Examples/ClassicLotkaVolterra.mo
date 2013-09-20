within ModelicaByExample.Components.LotkaVolterra.Examples;
model ClassicLotkaVolterra "Includes reproduction, starvation and predation"
  Components.RegionalPopulation rabbits(init=ModelicaByExample.Components.LotkaVolterra.Components.RegionalPopulation.InitializationOptions.FixedPopulation,
      initial_population=10)
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Components.Reproduction reproduction(alpha=0.1) "Reproduction of rabbits"
    annotation (Placement(transformation(extent={{-70,30},{-50,50}})));
  Components.RegionalPopulation foxes(init=ModelicaByExample.Components.LotkaVolterra.Components.RegionalPopulation.InitializationOptions.FixedPopulation,
      initial_population=10)
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Components.Starvation fox_starvation(gamma=0.4) "Starvation of foxes"
    annotation (Placement(transformation(extent={{50,-50},{70,-30}})));
  Components.Predation fox_predation(beta=0.02, delta=0.02)
    "Foxes eating rabbits"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(reproduction.species, rabbits.species) annotation (Line(
      points={{-60,40},{-60,0}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(rabbits.species, fox_predation.a) annotation (Line(
      points={{-60,0},{-10,0}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(fox_starvation.species, foxes.species) annotation (Line(
      points={{60,-40},{60,0}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(fox_predation.b, foxes.species) annotation (Line(
      points={{10,0},{60,0}},
      color={0,127,0},
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    experiment(StopTime=100, Tolerance=1e-006),
    __Dymola_experimentSetupOutput);
end ClassicLotkaVolterra;
