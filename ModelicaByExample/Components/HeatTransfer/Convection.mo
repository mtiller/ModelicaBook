within ModelicaByExample.Components.HeatTransfer;
model Convection "Modeling convection between port_a and port_b"
  parameter Modelica.SIunits.CoefficientOfHeatTransfer h;
  parameter Modelica.SIunits.Area A;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation
  port_a.Q_flow + port_b.Q_flow = 0 "Conservation of energy";
  port_a.Q_flow = h*A*(port_a.T-port_b.T) "Heat transfer equation";
  annotation ( Icon(graphics={
        Rectangle(
          extent={{-100,100},{-40,-100}},
          lineColor={135,135,135},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-10,80},{-10,-40},{-20,-40},{0,-80},{20,-40},{10,-40},{10,80},
              {-10,80}},
          lineColor={135,135,135},
          smooth=Smooth.None,
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{50,80},{50,-40},{40,-40},{60,-80},{80,-40},{70,-40},{70,80},
              {50,80}},
          lineColor={135,135,135},
          smooth=Smooth.None,
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,-100},{100,-140}},
          lineColor={0,0,255},
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid,
          textString="A=%A"),
        Text(
          extent={{-100,180},{100,140}},
          lineColor={0,0,255},
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid,
          textString="h=%h")}));
end Convection;
