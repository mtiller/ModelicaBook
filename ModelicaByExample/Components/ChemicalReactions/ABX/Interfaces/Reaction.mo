within ModelicaByExample.Components.ChemicalReactions.ABX.Interfaces;
partial model Reaction "A reaction potentially involving species A, B and X"
  parameter Real k "Reaction coefficient";
  Mixture mixture
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
protected
  ConcentrationRate consumed[Species];
  ConcentrationRate produced[Species];
  Modelica.SIunits.Concentration C[Species] = mixture.C;
equation
  consumed = -produced;
  mixture.R = consumed;
end Reaction;
