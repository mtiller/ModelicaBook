within ModelicaByExample.Architectures.SensorComparison.Implementation;
model BasicPlant "Implementation of the basic plant model"
  parameter Modelica.SIunits.Inertia J_a=0.1 "Moment of inertia";
  parameter Modelica.SIunits.Inertia J_b=0.3 "Moment of inertia";
  parameter Modelica.SIunits.RotationalSpringConstant c=100 "Spring constant";
  parameter Modelica.SIunits.RotationalDampingConstant d_shaft=3
    "Shaft damping constant";
  parameter Modelica.SIunits.RotationalDampingConstant d_load=4
    "Load damping constant";

  Modelica.Mechanics.Rotational.Interfaces.Support housing
    "Connection to mounting"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a
    "Input shaft for plant"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b
    "Output shaft of plant"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
protected
  Modelica.Mechanics.Rotational.Components.Fixed fixed
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J=J_a)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia1(J=J_b)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Mechanics.Rotational.Components.SpringDamper springDamper(c=c, d=
        d_shaft)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Mechanics.Rotational.Components.Damper damper(d=d_load)
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
equation
  connect(springDamper.flange_a, inertia.flange_b) annotation (Line(
      points={{-10,0},{-20,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(springDamper.flange_b, inertia1.flange_a) annotation (Line(
      points={{10,0},{20,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(damper.flange_b, inertia1.flange_b) annotation (Line(
      points={{40,-30},{50,-30},{50,0},{40,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(damper.flange_a, fixed.flange) annotation (Line(
      points={{20,-30},{0,-30},{0,-70}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(inertia1.flange_b, flange_b) annotation (Line(
      points={{40,0},{100,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(inertia.flange_a, flange_a) annotation (Line(
      points={{-40,0},{-100,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(fixed.flange, housing) annotation (Line(
      points={{0,-70},{0,-60},{-100,-60}},
      color={0,0,0},
      smooth=Smooth.None));
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={128,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-88,-52},{92,-92}},
          pattern=LinePattern.None,
          textString="%name",
          lineColor={0,0,0}),
        Text(
          extent={{-96,96},{96,-60}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Basic
Plant")}));
end BasicPlant;
