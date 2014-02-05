within ModelicaByExample.Components.LotkaVolterra.Examples;
model ThirdSpecies "Adding a third species to Lotka-Volterra"
  import ModelicaByExample.Components.LotkaVolterra.Components.RegionalPopulation.InitializationOptions.FixedPopulation;
  extends ClassicLotkaVolterra(rabbits(initial_population=25), foxes(initial_population=2));
  Components.RegionalPopulation wolves(init=FixedPopulation, initial_population=4)
    annotation (Placement(transformation(extent={{30,40},{50,60}})));
  Components.Starvation wolf_starvation(gamma=0.4)
    annotation (Placement(transformation(extent={{70,40},{90,60}})));
  Components.Predation wolf_predation(beta=0.04, delta=0.08) "Wolves eating Foxes"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=90, origin={60,20})));
  Components.Predation wolf_rabbit_predation(beta=0.02, delta=0.01) "Wolves eating rabbits"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
equation
  connect(wolf_predation.b, wolves.species) annotation (Line(
      points={{60,30},{60,80},{40,80},{40,60},{40,60}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(wolf_rabbit_predation.a, rabbits.species) annotation (Line(
      points={{-10,40},{-40,40},{-40,-20}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(wolf_predation.a, foxes.species) annotation (Line(
      points={{60,10},{60,0},{40,0},{40,-20}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(wolf_starvation.species, wolves.species) annotation (Line(
      points={{80,60},{80,80},{40,80},{40,60}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(wolves.species, wolf_rabbit_predation.b) annotation (Line(
      points={{40,60},{40,80},{20,80},{20,40},{10,40}},
      color={0,127,0},
      smooth=Smooth.None));
  annotation (experiment(StopTime=100, Tolerance=1e-006));
end ThirdSpecies;
