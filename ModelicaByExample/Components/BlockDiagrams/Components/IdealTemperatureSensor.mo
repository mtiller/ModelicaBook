within ModelicaByExample.Components.BlockDiagrams.Components;
model IdealTemperatureSensor "An ideal (no thermal time-constant) sensor"
  extends Interfaces.SO;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a node
    "Thermal node being measured"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
equation
  y = node.T;
  node.Q_flow = 0 "Sensor shouldn't affect thermal system";
  annotation (Icon(graphics={
        Ellipse(
          extent={{-32,-30},{32,-94}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-22,60},{22,-56}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-22,82},{22,38}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-18,78},{18,42}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-28,-34},{28,-90}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-18,60},{18,-66}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-26,-36},{26,-88}},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-16,46},{16,-54}},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-90,0},{-22,0}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{22,0},{100,0}},
          color={0,0,255},
          smooth=Smooth.None)}));
end IdealTemperatureSensor;
