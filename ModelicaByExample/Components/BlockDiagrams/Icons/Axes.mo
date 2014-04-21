within ModelicaByExample.Components.BlockDiagrams.Icons;
block Axes "Introduces graphics for independent and dependent axes"

  annotation ( Icon(graphics={
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
        Line(
          points={{-80,-80},{-80,80}},
          color={0,0,0},
          smooth=Smooth.None),
        Polygon(
          points={{-80,80},{-84,68},{-76,68},{-80,80}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,-80},{80,-80}},
          color={0,0,0},
          smooth=Smooth.None),
        Polygon(
          points={{80,-80},{68,-76},{68,-84},{80,-80}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid)}));
end Axes;
