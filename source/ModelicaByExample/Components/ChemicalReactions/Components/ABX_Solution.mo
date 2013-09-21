within ModelicaByExample.Components.ChemicalReactions.Components;
model ABX_Solution "A mixture of species A, B and X"
  Interfaces.ABX abx
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  der(abx.C) = -abx.R;
end ABX_Solution;
