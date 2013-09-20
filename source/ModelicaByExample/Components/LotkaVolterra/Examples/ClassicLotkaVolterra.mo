within ModelicaByExample.Components.LotkaVolterra.Examples;
model ClassicLotkaVolterra "Includes reproduction, starvation and predation"
  Components.RegionalPopulation prey(init=ModelicaByExample.Components.LotkaVolterra.Components.RegionalPopulation.InitializationOptions.FixedPopulation,
      initial_population=10)
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Components.Reproduction reproduction(alpha=0.1)
    annotation (Placement(transformation(extent={{-70,30},{-50,50}})));
  Components.RegionalPopulation predators(init=ModelicaByExample.Components.LotkaVolterra.Components.RegionalPopulation.InitializationOptions
        .FixedPopulation, initial_population=10)
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Components.Starvation starvation(gamma=0.4)
    annotation (Placement(transformation(extent={{50,-50},{70,-30}})));
  Components.Predation predation(beta=0.02, delta=0.02)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(reproduction.species, prey.species) annotation (Line(
      points={{-60,40},{-60,0}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(prey.species, predation.a) annotation (Line(
      points={{-60,0},{-10,0}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(starvation.species, predators.species) annotation (Line(
      points={{60,-40},{60,0}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(predation.b, predators.species) annotation (Line(
      points={{10,0},{60,0}},
      color={0,127,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end ClassicLotkaVolterra;
