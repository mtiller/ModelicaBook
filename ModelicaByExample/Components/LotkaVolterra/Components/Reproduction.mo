within ModelicaByExample.Components.LotkaVolterra.Components;
model Reproduction "Model of reproduction"
  extends Interfaces.SinkOrSource;
  parameter Real alpha "Birth rate proportionality constant";
equation
  growth = alpha*species.population "Growth is proporational to population";
  annotation ( Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-60,60},{-20,20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-4,52},{4,28}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-12,44},{12,36}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{20,60},{60,20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-12,12},{12,4}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-12,-4},{12,-12}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-50,-30},{-30,-50}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-10,-30},{10,-50}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{30,-30},{50,-50}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end Reproduction;
