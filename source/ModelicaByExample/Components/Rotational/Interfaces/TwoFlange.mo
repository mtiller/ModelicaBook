within ModelicaByExample.Components.Rotational.Interfaces;
partial model TwoFlange
  "Definition of a partial rotational component with two flanges"

  Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
protected
  Modelica.SIunits.Angle phi_rel;
equation
  phi_rel = flange_a.phi-flange_b.phi;
end TwoFlange;
