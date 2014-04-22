within ModelicaByExample.Components.HeatTransfer;
model AmbientCondition
  "Model of an \"infinite reservoir\" at some ambient temperature"
  parameter Modelica.SIunits.Temperature T_amb "Ambient temperature";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a node annotation (
      Placement(transformation(extent={{-10,-10},{10,10}}), iconTransformation(
          extent={{-10,-10},{10,10}})));
equation
  node.T = T_amb;
  annotation (Icon(graphics={
        Rectangle(
          extent={{-30,100},{30,-100}},
          lineColor={0,0,0},
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,-100},{100,-140}},
          lineColor={0,0,0},
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,0},
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid,
          textString="T_amb=%T_amb")}));
end AmbientCondition;
