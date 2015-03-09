within ModelicaByExample.Components.LotkaVolterra.Examples;
model ThreeSpecies_Quiescent "Three species in a quiescent state"
  import ModelicaByExample.Components.LotkaVolterra.Components.RegionalPopulation.InitializationOptions.SteadyState;
  extends ThirdSpecies(
    rabbits(init=SteadyState, population(start=30)),
    foxes(init=SteadyState, population(start=2)),
    wolves(init=SteadyState, population(start=4)));
  annotation (experiment(StopTime=100, Tolerance=1e-006));
end ThreeSpecies_Quiescent;
