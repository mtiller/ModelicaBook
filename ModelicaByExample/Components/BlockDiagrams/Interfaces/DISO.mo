within ModelicaByExample.Components.BlockDiagrams.Interfaces;
partial block DISO "A double input, single output (DISO) partial model"
  extends SO;
  RealInput u1 "Input signal 1" annotation (Placement(transformation(extent={{-120,
            50},{-100,70}}), iconTransformation(extent={{-120,50},{-100,70}})));
  RealInput u2 "Input signal 2" annotation (Placement(transformation(extent={{-120,
            -70},{-100,-50}}),
                             iconTransformation(extent={{-120,-70},{-100,-50}})));
end DISO;
