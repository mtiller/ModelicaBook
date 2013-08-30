within ModelicaByExample.PackageExamples;
package NestedPackages
  "An example of how packages can be used to organize things"
  package Types
    type Rabbits = Real(quantity="Rabbits");
    type Wolves = Real(quantity="Wolves");
    type RabbitReproduction = Real(quantity="Rabbit Reproduction");
    type RabbitFatalities = Real(quantity="Rabbit Fatalities");
    type WolfReproduction = Real(quantity="Wolf Reproduction");
    type WolfFatalities = Real(quantity="Wolf Fatalities");
  end Types;

  model LotkaVolterra "Lotka-Volterra with types"
    parameter Types.RabbitReproduction alpha=0.1;
    parameter Types.RabbitFatalities beta=0.02;
    parameter Types.WolfReproduction gamma=0.4;
    parameter Types.WolfFatalities delta=0.02;
    parameter Types.Rabbits x0=10;
    parameter Types.Wolves y0=10;
    Types.Rabbits x(start=x0);
    Types.Wolves y(start=y0);
  equation
    der(x) = x*(alpha-beta*y);
    der(y) = -y*(gamma-delta*x);
  end LotkaVolterra;
end NestedPackages;
