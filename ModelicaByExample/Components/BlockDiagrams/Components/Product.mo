within ModelicaByExample.Components.BlockDiagrams.Components;
block Product "Block that outputs the product of its inputs"
  extends Interfaces.MISO;
equation
  y = product(u);
  annotation (Diagram(graphics={Rectangle(extent={{-100,100},{100,-100}},
            lineColor={0,0,0})}), Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,60},{-20,-60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,60},{70,40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{20,60},{40,-60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end Product;
