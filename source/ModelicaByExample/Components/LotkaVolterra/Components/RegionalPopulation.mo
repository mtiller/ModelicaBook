within ModelicaByExample.Components.LotkaVolterra.Components;
model RegionalPopulation "Population of animals in a specific region"
  encapsulated type InitializationOptions = enumeration(
      Free "No initial conditions",
      FixedPopulation "Specify initial population",
      SteadyState "Population initially in steady state");
  parameter InitializationOptions init annotation(choicesAllMatching=true);
  parameter Real initial_population annotation(Dialog(group="Initialization", enable=init==InitializationOptions.FixedPopulation));
  Interfaces.Species species
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  annotation (Diagram(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,127,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
protected
  Real population(start=10) = species.population "Population in this region";
initial equation
  if init==InitializationOptions.FixedPopulation then
    species.population = initial_population;
  elseif init==InitializationOptions.SteadyState then
    der(species.population) = 0;
  else
  end if;
equation
  der(species.population) = species.rate;
  assert(species.population>0, "Population must be greater than zero");
end RegionalPopulation;
