within ModelicaByExample.ArrayEquations.HeatTransfer;
model Rod_ForLoop "Modeling heat conduction in a rod using a for loop"
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
  rho*V*C*der(T[1]) = -h*A_s*(T[1]-Tamb)-k*A_c*(T[1]-T[2])/(L/n);
  for i in 2:(n-1) loop
    rho*V*C*der(T[i]) = -h*A_s*(T[i]-Tamb)-k*A_c*(T[i]-T[i-1])/(L/n)-k*A_c*(T[i]-T[i+1])/(L/n);
  end for;
  rho*V*C*der(T[end]) = -h*A_s*(T[end]-Tamb)-k*A_c*(T[end]-T[end-1])/(L/n);
end Rod_ForLoop;
