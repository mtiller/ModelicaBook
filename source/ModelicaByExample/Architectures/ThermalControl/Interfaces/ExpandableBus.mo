within ModelicaByExample.Architectures.ThermalControl.Interfaces;
expandable connector ExpandableBus "An example of an expandable bus connector"

  annotation (Icon(graphics={
        Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Line(
          points={{40,-40},{40,40}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=0.5,
          pattern=LinePattern.Dot),
        Line(
          points={{-40,40},{-40,-40}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=0.5,
          pattern=LinePattern.Dot),
        Polygon(
          points={{-40,-40},{-48,-20},{-32,-20},{-40,-40}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,40},{30,20},{50,20},{40,40}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,-100},{100,-140}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="%name")}));
end ExpandableBus;
