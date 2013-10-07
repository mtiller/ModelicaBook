within ModelicaByExample.Architectures.ThermalControl.Bogus;
connector ControllerBus
  "An example of a simple bus connector for the control system"
  Modelica.Blocks.Interfaces.RealInput temperature;
  Modelica.Blocks.Interfaces.RealOutput heat;
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
          thickness=0.5),
        Line(
          points={{-40,40},{-40,-40}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Polygon(
          points={{-40,-40},{-48,-20},{-32,-20},{-40,-40}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,40},{30,20},{50,20},{40,40}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid)}));
end ControllerBus;
