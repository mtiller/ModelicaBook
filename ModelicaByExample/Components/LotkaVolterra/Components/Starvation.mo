within ModelicaByExample.Components.LotkaVolterra.Components;
model Starvation "Model of starvation"
  extends Interfaces.SinkOrSource;
  parameter Real gamma "Starvation coefficient";
equation
  decline = gamma*species.population
    "Decline is proporational to population (competition)";
  annotation (Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Bitmap(extent={{-98,86},{98,-98}},
            fileName="modelica://ModelicaByExample/Resources/Images/death.png")}));
end Starvation;
