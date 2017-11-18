within ModelicaByExample.ArrayEquations.HeatTransfer;
model Rod_VectorNotationNoSubscripts
  "Modeling heat conduction in a rod using vector notation"
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
  type Heat=Real(unit="W");

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
  Heat Qconv[n];
  Heat Qleft[n];
  Heat Qright[n];
initial equation
  T = linspace(200,300,n);
equation
  Qconv = {-h*A_s*(T[i]-Tamb) for i in 1:n};
  Qleft = {(if i==1 then 0 else -k*A_c*(T[i]-T[i-1])/(L/n)) for i in 1:n};
  Qright = {(if i==n then 0 else -k*A_c*(T[i]-T[i+1])/(L/n)) for i in 1:n};
  rho*V*C*der(T) = Qconv+Qleft+Qright;
end Rod_VectorNotationNoSubscripts;
