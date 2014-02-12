within ModelicaByExample.Architectures.SensorComparison.Interfaces;
partial model Plant "Interface for plant model"
  Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b
    "Output shaft of plant"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a
    "Input shaft for plant"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Mechanics.Rotational.Interfaces.Support housing
    "Connection to mounting"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  annotation (Icon(graphics={Rectangle(extent={{-100,100},{
              100,-100}}, lineColor={128,0,255})}));
end Plant;
