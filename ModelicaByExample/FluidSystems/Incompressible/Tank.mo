within ModelicaByExample.FluidSystems.Incompressible;
model Tank "Tank with a uniform cross-sectional area"
  import Modelica.SIunits.*;
  parameter Area A "Cross-sectional area";
  parameter Density rho "Fluid density";
  parameter Height h0(start=0.1) "Initial fluid height";
  Port port;
protected
  Height h;
  Volume V;
initial equation
  h = h0;
equation
  V = h*A;
  der(V) = port.Q;
  port.p = rho*Modelica.Constants.g_n*h;
end Tank;
