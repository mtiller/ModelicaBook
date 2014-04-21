within ModelicaByExample.Components.BlockDiagrams.Components;
block Feedback "A block to compute feedback terms"
  Interfaces.RealInput u1
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Interfaces.RealInput u2 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-110})));
  Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation
  y = u1-u2;
  annotation ( Icon(graphics={
        Ellipse(
          extent={{-20,20},{20,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-100,0},{-20,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{0,-100},{0,-20}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{20,0},{100,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-32,18},{-28,2}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-38,12},{-22,8}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-18,-28},{-2,-32}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end Feedback;
