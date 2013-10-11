within ModelicaByExample.Components.BlockDiagrams.Interfaces;
partial block MISO "A multiple input, single output (MISO) partial block"
  parameter Integer nin;
  extends SO;
  RealInput u[nin] "A vector of input signals (of size nin)"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
end MISO;
