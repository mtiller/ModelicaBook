within ModelicaByExample.Connectors;
package FluidConnectors "Examples of fluid connectors"
  connector Incompressible
    Modelica.SIunits.Pressure p;
    flow Modelica.SIunits.VolumeFlowRate q;
  end Incompressible;

  connector GenericFluid
    Modelica.SIunits.Pressure p;
    flow Modelica.SIunits.MassFlowRate m_flow;
  end GenericFluid;

  connector ThermoFluid
    Modelica.SIunits.Pressure p;
    flow Modelica.SIunits.MassFlowRate m_flow;
    Modelica.SIunits.Temperature T;
    flow Modelica.SIunits.HeatFlowRate q;
  end ThermoFluid;
end FluidConnectors;
