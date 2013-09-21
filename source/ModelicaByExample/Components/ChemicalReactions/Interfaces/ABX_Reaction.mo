within ModelicaByExample.Components.ChemicalReactions.Interfaces;
partial model ABX_Reaction
  "A reaction potentially involving species A, B and X"
  parameter Real k "Reaction coefficient";
  ABX solution "Solution reaction is occurring in"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
protected
  ConcentrationRate consumed[ABX_Species];
  ConcentrationRate produced[ABX_Species];
  Modelica.SIunits.Concentration C[ABX_Species] = solution.C;
equation
  consumed = -produced;
  solution.R = -consume;
end ABX_Reaction;
