within ModelicaByExample.Subsystems.LotkaVolterra.Components;
model Migration "Simple 'diffusion' based model of migration"
  parameter Real rabbit_migration=0.001 "Rabbit migration rate";
  parameter Real fox_migration=0.005 "Fox migration rate";
  ModelicaByExample.Components.LotkaVolterra.Interfaces.Species rabbit_a
    "Rabbit population in Region A"
    annotation (Placement(transformation(extent={{-70,90},{-50,110}})));
  ModelicaByExample.Components.LotkaVolterra.Interfaces.Species rabbit_b
    "Rabbit population in Region B"
    annotation (Placement(transformation(extent={{-70,-110},{-50,-90}})));
  ModelicaByExample.Components.LotkaVolterra.Interfaces.Species fox_a
    "Fox population in Region A"
    annotation (Placement(transformation(extent={{50,90},{70,110}})));
  ModelicaByExample.Components.LotkaVolterra.Interfaces.Species fox_b
    "Fox population in Region B"
    annotation (Placement(transformation(extent={{50,-110},{70,-90}})));
equation
  rabbit_a.rate = (rabbit_a.population-rabbit_b.population)*rabbit_migration;
  rabbit_a.rate + rabbit_b.rate = 0 "Conservation of rabbits";
  fox_a.rate = (fox_a.population-fox_b.population)*fox_migration;
  fox_a.rate + fox_b.rate = 0 "Conservation of foxes";
  annotation ( Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,127,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,20},{100,-20}},
          lineColor={0,127,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%name",
          origin={-120,0},
          rotation=90),
        Bitmap(extent={{-84,82},{-36,-82}}, fileName=
              "modelica://ModelicaByExample/Resources/Images/rabbit.png"),
        Bitmap(extent={{18,80},{94,-84}}, fileName=
              "modelica://ModelicaByExample/Resources/Images/fox.png")}));
end Migration;
