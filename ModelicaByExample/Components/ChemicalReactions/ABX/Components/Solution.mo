within ModelicaByExample.Components.ChemicalReactions.ABX.Components;
model Solution "A mixture of species A, B and X"
  Interfaces.Mixture mixture
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.SIunits.Concentration C[Species]=mixture.C
    annotation(Dialog(group="Initialization",showStartAttribute=true));
equation
  der(mixture.C) = mixture.R;
end Solution;
