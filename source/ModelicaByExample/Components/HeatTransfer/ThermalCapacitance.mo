within ModelicaByExample.Components.HeatTransfer;
model ThermalCapacitance "A model of thermal capacitance"
  parameter Modelica.SIunits.HeatCapacity C "Thermal capacitance";
  parameter Modelica.SIunits.Temperature T0 "Initial temperature";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a node
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
initial equation
  node.T = T0;
equation
  C*der(node.T) = node.Q_flow;
  annotation (Icon(graphics={
        Polygon(
          points={{0,77},{-20,73},{-40,67},{-52,53},{-58,45},{-68,35},{-72,23},{
              -76,9},{-78,-5},{-76,-21},{-76,-33},{-76,-43},{-70,-55},{-64,-63},
              {-48,-67},{-30,-73},{-18,-73},{-2,-75},{8,-79},{22,-79},{32,-77},{
              42,-71},{54,-65},{56,-63},{66,-51},{68,-43},{70,-41},{72,-25},{76,
              -11},{78,-3},{78,13},{74,25},{66,35},{54,43},{44,51},{36,67},{26,75},
              {0,77}},
          lineColor={160,160,164},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-58,45},{-68,35},{-72,23},{-76,9},{-78,-5},{-76,-21},{-76,-33},
              {-76,-43},{-70,-55},{-64,-63},{-48,-67},{-30,-73},{-18,-73},{-2,-75},
              {8,-79},{22,-79},{32,-77},{42,-71},{54,-65},{42,-67},{40,-67},{30,
              -69},{20,-71},{18,-71},{10,-71},{2,-67},{-12,-63},{-22,-63},{-30,-61},
              {-40,-55},{-50,-45},{-56,-33},{-58,-25},{-58,-15},{-60,-3},{-60,5},
              {-60,17},{-58,27},{-56,29},{-52,37},{-48,45},{-44,55},{-40,67},{-58,
              45}},
          lineColor={0,0,0},
          fillColor={160,160,164},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,-80},{100,-120}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-100,120},{100,80}},
          lineColor={0,0,255},
          textString="C=%C")}));
end ThermalCapacitance;
