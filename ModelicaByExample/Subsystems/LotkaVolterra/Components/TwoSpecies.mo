within ModelicaByExample.Subsystems.LotkaVolterra.Components;
model TwoSpecies "Lotka-Volterra two species configuration"
  // Import several component models from ModelicaByExample.Components.LotkaVolterra
  import ModelicaByExample.Components.LotkaVolterra.Components.RegionalPopulation;
  import ModelicaByExample.Components.LotkaVolterra.Components.Reproduction;
  import ModelicaByExample.Components.LotkaVolterra.Components.Starvation;
  import ModelicaByExample.Components.LotkaVolterra.Components.Predation;

  parameter Real alpha=0.1 "Birth rate";
  parameter Real gamma=0.4 "Starvation coefficient";
  parameter Real initial_rabbit_population=10 "Initial rabbit population";
  parameter Real initial_fox_population=10 "Initial fox population";
  parameter Real beta=0.02 "Prey (rabbits) consumed";
  parameter Real delta=0.02 "Predators (foxes) fed";

  ModelicaByExample.Components.LotkaVolterra.Interfaces.Species rabbits
    "Population of rabbits in this region"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  ModelicaByExample.Components.LotkaVolterra.Interfaces.Species foxes
    "Population of foxes in this region"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
protected
  RegionalPopulation rabbit_population(
      initial_population=initial_rabbit_population,
      init=RegionalPopulation.InitializationOptions.FixedPopulation) "Rabbit population"
    annotation (Placement(transformation(extent={{-50,-60},{-30,-40}})));
  Reproduction reproduction(alpha=alpha) "Reproduction of rabbits"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-80,-50})));
  RegionalPopulation fox_population(
      init=RegionalPopulation.InitializationOptions.FixedPopulation,
      initial_population=initial_fox_population)
    annotation (Placement(transformation(extent={{30,-60},{50,-40}})));
  Starvation fox_starvation(gamma=gamma) "Starvation of foxes"
    annotation (Placement(transformation(extent={{70,-60},{90,-40}})));
  Predation fox_predation(beta=beta, delta=delta)
    "Foxes eating rabbits"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
equation
  connect(reproduction.species, rabbit_population.species)
    annotation (Line(
      points={{-80,-40},{-80,-20},{-40,-20},{-40,-40}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(fox_predation.a, rabbit_population.species)
    annotation (Line(
      points={{-10,-20},{-40,-20},{-40,-40}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(fox_starvation.species, fox_population.species)
    annotation (Line(
      points={{80,-40},{80,-20},{40,-20},{40,-40}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(fox_population.species, fox_predation.b)
    annotation (Line(
      points={{40,-40},{40,-20},{10,-20}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(rabbit_population.species, rabbits)
    annotation (Line(
      points={{-40,-40},{-40,0},{-100,0}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(fox_population.species, foxes)
    annotation (Line(
      points={{40,-40},{40,0},{100,0}},
      color={0,127,0},
      smooth=Smooth.None));
  annotation (Icon(graphics={
          Text(extent={{-100,120},{100,80}}, lineColor={0,127,0},
          textString="%name"),
          Bitmap(extent={{-100,86},{100,-98}}, fileName=
              "modelica://ModelicaByExample/Resources/Images/rabbitandfox.jpg")}));
end TwoSpecies;
