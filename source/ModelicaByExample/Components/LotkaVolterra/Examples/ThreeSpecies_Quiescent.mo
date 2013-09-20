within ModelicaByExample.Components.LotkaVolterra.Examples;
model ThreeSpecies_Quiescent "Three species in a quiescent state"
  extends ThirdSpecies(
    rabbits(init=ModelicaByExample.Components.LotkaVolterra.Components.RegionalPopulation.InitializationOptions.SteadyState),
    foxes(init=ModelicaByExample.Components.LotkaVolterra.Components.RegionalPopulation.InitializationOptions.SteadyState),
    wolves(init=ModelicaByExample.Components.LotkaVolterra.Components.RegionalPopulation.InitializationOptions.SteadyState));

  annotation (experiment(StopTime=100, Tolerance=1e-006), __Dymola_experimentSetupOutput);
end ThreeSpecies_Quiescent;
