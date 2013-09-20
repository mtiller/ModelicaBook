within ModelicaByExample.Components.LotkaVolterra.Components;
model Predation "Model of predation"
  extends Interfaces.Interaction;
  parameter Real beta "Prey (Species A) consumed";
  parameter Real delta "Predators (Species B) fed";
equation
  b_growth = delta*a.population*b.population;
  a_decline = beta*a.population*b.population;
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-80,20},{-40,-20}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-46,-16},{-20,-16}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-42,-12},{-24,-12}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-40,-8},{-28,-8}},
          color={0,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{80,-50},{-20,50}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-12,34},{28,2},{-16,-32},{-22,8},{-12,34}},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}));
end Predation;
