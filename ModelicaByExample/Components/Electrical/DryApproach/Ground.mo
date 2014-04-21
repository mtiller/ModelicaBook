within ModelicaByExample.Components.Electrical.DryApproach;
model Ground "Electrical ground"
  Modelica.Electrical.Analog.Interfaces.PositivePin ground "Ground pin"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
equation
  ground.v = 0;
  annotation ( Icon(graphics={
        Rectangle(
          extent={{-62,42},{62,38}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,2},{30,-2}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,-38},{2,-42}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,76},{0,40}},
          color={0,0,255},
          smooth=Smooth.None),
        Rectangle(
          extent={{-46,22},{46,18}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-16,-18},{16,-22}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}));
end Ground;
