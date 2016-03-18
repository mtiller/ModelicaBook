within ModelicaByExample.Components.Rotational.Components;
model Ground "Mechanical ground"
  Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
equation
  flange_a.phi = 0;
  annotation (Icon(graphics={
        Line(
          points={{-80,20},{80,20}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-80,20},{-40,-40}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-60,20},{-20,-40}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-40,20},{0,-40}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-20,20},{20,-40}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{0,20},{40,-40}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{20,20},{60,-40}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{40,20},{80,-40}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{60,20},{80,-10}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-80,-10},{-60,-40}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-80,20},{-80,-40}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{80,20},{80,-40}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{0,60},{0,20}},
          color={0,0,0},
          smooth=Smooth.None)}));
end Ground;
