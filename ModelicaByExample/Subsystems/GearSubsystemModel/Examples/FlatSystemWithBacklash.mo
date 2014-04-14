within ModelicaByExample.Subsystems.GearSubsystemModel.Examples;
model FlatSystemWithBacklash
  "An example where all components models are present at the same level"

  Modelica.Blocks.Sources.Trapezoid trapezoid(
    amplitude=2,
    offset=-1,
    period=0.8,
    width=0.4)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Modelica.Mechanics.Rotational.Sources.Torque torque(useSupport=true)
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J=0.1)
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Modelica.Mechanics.Rotational.Components.Damper load(d=2)
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Modelica.Mechanics.Rotational.Components.Fixed fixed
    annotation (Placement(transformation(extent={{-70,-60},{-50,-40}})));
protected
  Modelica.Mechanics.Rotational.Components.Inertia inertia_a(final J=0.01)
    "Inertia for the element 'a'"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia_b(final J=0.02)
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Modelica.Mechanics.Rotational.Components.ElastoBacklash backlash(
    final c=1000,
    final d=2,
    final b=0.17453292519943) "Backlash as measured from flange_a"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Mechanics.Rotational.Components.IdealGear idealGear(ratio=4,
      useSupport=true)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation
  connect(fixed.flange, torque.support) annotation (Line(
      points={{-60,-50},{-60,-10}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      smooth=Smooth.None));
  connect(load.flange_a, fixed.flange) annotation (Line(
      points={{-20,-40},{-60,-40},{-60,-50}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      smooth=Smooth.None));
  connect(inertia.flange_b, load.flange_b) annotation (Line(
      points={{100,0},{100,-40},{0,-40}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      smooth=Smooth.None));
  connect(trapezoid.y, torque.tau) annotation (Line(
      points={{-79,0},{-72,0}},
      color={0,0,127},
      pattern=LinePattern.Solid,
      smooth=Smooth.None));
  connect(inertia_b.flange_b, inertia.flange_a) annotation (Line(
      points={{70,0},{80,0}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      smooth=Smooth.None));
  connect(idealGear.flange_b, inertia_b.flange_a) annotation (Line(
      points={{40,0},{50,0}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      smooth=Smooth.None));
  connect(inertia_a.flange_a, torque.flange) annotation (Line(
      points={{-40,0},{-50,0}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      smooth=Smooth.None));
  connect(inertia_a.flange_b, backlash.flange_a) annotation (Line(
      points={{-20,0},{-10,0}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      smooth=Smooth.None));
  connect(backlash.flange_b, idealGear.flange_a) annotation (Line(
      points={{10,0},{20,0}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      smooth=Smooth.None));
  connect(idealGear.support, fixed.flange) annotation (Line(
      points={{30,-10},{30,-30},{-60,-30},{-60,-50}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      smooth=Smooth.None));
  annotation (Diagram(graphics={Rectangle(
          extent={{-44,26},{76,-26}},
          fillColor={205,230,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          lineThickness=0.5,
          pattern=LinePattern.Dash)}));
end FlatSystemWithBacklash;
