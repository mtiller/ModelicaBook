within ModelicaByExample.Components.BlockDiagrams.Components;
block Sum "Block that sums its inputs"
  extends Interfaces.MISO;
equation
  y = sum(u);
  annotation (Diagram(graphics={Rectangle(extent={{-100,100},{100,-100}},
            lineColor={0,0,0})}), Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Polygon(
          points={{56,-64},{52,-72},{-56,-72},{-8,0},{-54,72},{52,72},{56,64},{
              66,70},{60,80},{-72,80},{-20,0},{-72,-80},{60,-80},{66,-70},{56,
              -64}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={0,0,0})}));
end Sum;
