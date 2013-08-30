within ModelicaByExample.Connectors;
package SimpleDomains "Examples of connectors for simple domains"
  connector Electrical
     Modelica.SIunits.Voltage v;
     flow Modelica.SIunits.Current i;
  end Electrical;

  connector Thermal
     Modelica.SIunits.Temperature T;
     flow Modelica.SIunits.HeatFlowRate q;
  end Thermal;

  connector Translational
     Modelica.SIunits.Position x;
     flow Modelica.SIunits.Force f;
  end Translational;

  connector Rotational
     Modelica.SIunits.Angle phi;
     flow Modelica.SIunits.Torque tau;
  end Rotational;
end SimpleDomains;
