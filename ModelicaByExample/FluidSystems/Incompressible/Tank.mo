within ModelicaByExample.FluidSystems.Incompressible;
model Tank "Tank with a uniform cross-sectional area"
  import Modelica.SIunits.*;
  parameter Area A "Cross-sectional area";
  parameter Density rho "Fluid density";
  Port port;
protected
  Height h;
  Volume V;
equation
  V = h*A;
  der(V) = port.Q;
  port.p = density*Modelica.Constants.g_n*h;
end Tank;
