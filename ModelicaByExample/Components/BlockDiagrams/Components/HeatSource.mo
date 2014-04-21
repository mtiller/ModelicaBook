within ModelicaByExample.Components.BlockDiagrams.Components;
model HeatSource "Apply heating (or cooling) to a thermal system"
  extends Interfaces.SI;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b node
    "Thermal node that heating or cooling is applied to"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation
  node.Q_flow = -u;
  annotation ( Icon(graphics={Polygon(
          points={{-100,20},{-100,-20},{40,-20},{40,-40},{90,0},{40,40},{40,20},
              {-100,20}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}));
end HeatSource;
