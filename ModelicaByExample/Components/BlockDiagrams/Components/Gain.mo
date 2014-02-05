within ModelicaByExample.Components.BlockDiagrams.Components;
block Gain "A gain block model"
  extends Interfaces.SISO;
  parameter Real k "Gain coefficient";
equation
  y = k*u;
  annotation (Icon(graphics={Polygon(
          points={{-100,100},{-100,-100},{100,0},{-100,100}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-100,30},{40,-26}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="k=%k")}));
end Gain;
