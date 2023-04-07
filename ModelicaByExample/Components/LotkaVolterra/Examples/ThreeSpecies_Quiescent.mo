within ModelicaByExample.Components.LotkaVolterra.Examples;
model ThreeSpecies_Quiescent "Three species in a quiescent state"
  import ModelicaByExample.Components.LotkaVolterra.Components.RegionalPopulation.InitializationOptions.SteadyState;
  extends ThirdSpecies(
    rabbits(init=SteadyState, initial_population=30),
    foxes(init=SteadyState, initial_population=2),
    wolves(init=SteadyState, initial_population=4));
  annotation (experiment(StopTime=100, Tolerance=1e-006));
end ThreeSpecies_Quiescent;
