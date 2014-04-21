within ModelicaByExample.Components.HeatTransfer;
model ConvectionToAmbient "An overly specialized model of convection"
  parameter Modelica.SIunits.CoefficientOfHeatTransfer h;
  parameter Modelica.SIunits.Area A;
  parameter Modelica.SIunits.Temperature T_amb "Ambient temperature";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
equation
  port_a.Q_flow = h*A*(port_a.T-T_amb) "Heat transfer equation";
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
          extent={{-20,20},{180,-20}},
          lineColor={0,0,255},
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid,
          textString="T_amb=%T_amb"),
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
          textString="h=%h")}));
end ConvectionToAmbient;
