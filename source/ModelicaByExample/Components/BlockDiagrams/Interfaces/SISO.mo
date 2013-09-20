within ModelicaByExample.Components.BlockDiagrams.Interfaces;
partial block SISO "A single input, single output (SISO) partial model"
  extends SO;
  RealInput u "Input signal"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  annotation (Diagram(graphics), Icon(graphics));
end SISO;
