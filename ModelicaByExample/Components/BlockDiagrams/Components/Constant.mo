within ModelicaByExample.Components.BlockDiagrams.Components;
block Constant "A constant source"
  parameter Real k "Constant output value";
  extends Icons.Axes;
  extends Interfaces.SO;
equation
  y = k;
  annotation ( Icon(graphics={Line(
          points={{-80,20},{80,20}},
          color={0,128,255},
          smooth=Smooth.None), Text(
          extent={{-80,60},{80,20}},
          lineColor={0,128,255},
          fillPattern=FillPattern.Solid,
          textString="k=%k")}));
end Constant;
