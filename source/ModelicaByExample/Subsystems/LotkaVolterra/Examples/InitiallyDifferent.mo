within ModelicaByExample.Subsystems.LotkaVolterra.Examples;
model InitiallyDifferent "Multiple regions with different initial populations"
  extends UnconnectedPopulations(
    B(initial_rabbit_population=5, initial_fox_population=12),
    C(initial_rabbit_population=12, initial_fox_population=5),
    D(initial_rabbit_population=7, initial_fox_population=7));
end InitiallyDifferent;
