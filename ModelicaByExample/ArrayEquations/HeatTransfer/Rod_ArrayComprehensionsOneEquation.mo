within ModelicaByExample.ArrayEquations.HeatTransfer;
model Rod_ArrayComprehensionsOneEquation
  "Modeling heat conduction in a rod using single equation with array comprehensions"
  type Temperature=Real(unit="K", min=0);
  type ConvectionCoefficient=Real(unit="W/K", min=0);
  type ConductionCoefficient=Real(unit="W.m-1.K-1", min=0);
  type Mass=Real(unit="kg", min=0);
  type SpecificHeat=Real(unit="J/(K.kg)", min=0);
  type Density=Real(unit="kg/m3", min=0);
  type Area=Real(unit="m2");
  type Volume=Real(unit="m3");
  type Length=Real(unit="m", min=0);
  type Radius=Real(unit="m", min=0);

  constant Real pi = 3.14159;

  parameter Integer n=10;
  parameter Length L=1.0;
  parameter Radius R=0.1;
  parameter Density rho=2.0;
  parameter ConvectionCoefficient h=2.0;
  parameter ConductionCoefficient k=10;
  parameter SpecificHeat C=10.0;
  parameter Temperature Tamb=300 "Ambient temperature";

  parameter Area A_c = pi*R^2, A_s = 2*pi*R*L;
  parameter Volume V = A_c*L/n;

  Temperature T[n];
initial equation
  T = linspace(200,300,n);
equation
  rho*V*C*der(T) = {-h*A_s*(T[i]-Tamb)
                    -(if i==1 then 0 else k*A_c/(L/n)*(T[i]-T[i-1]))
                    -(if i==n then 0 else k*A_c/(L/n)*(T[i]-T[i+1])) for i in 1:n};
end Rod_ArrayComprehensionsOneEquation;
