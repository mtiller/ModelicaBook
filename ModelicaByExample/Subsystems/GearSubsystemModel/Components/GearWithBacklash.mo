within ModelicaByExample.Subsystems.GearSubsystemModel.Components;
model GearWithBacklash "A subsystem model for a gear with backlash"
  extends Modelica.Mechanics.Rotational.Icons.Gear;
  import Modelica.Mechanics.Rotational.Components.*;

  parameter Boolean useSupport(start=true);
  parameter Modelica.SIunits.Inertia J_a
    "Moment of inertia for element connected to flange 'a'";
  parameter Modelica.SIunits.Inertia J_b
    "Moment of inertia for element connected to flange 'b'";
  parameter Modelica.SIunits.RotationalSpringConstant c
    "Backlash spring constant (c > 0 required)";
  parameter Modelica.SIunits.RotationalDampingConstant d
    "Backlash damping constant";
  parameter Modelica.SIunits.Angle b=0
    "Total backlash as measured from flange_a side";
  parameter Real ratio
    "Transmission ratio (flange_a.phi/flange_b.phi, once backlash is cleared)";
protected
  Inertia inertia_a(final J=J_a) "Inertia for the element 'a'"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Inertia inertia_b(final J=J_b)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  ElastoBacklash backlash(final c=c, final d=d, final b=b) "Backlash as measured from flange_a"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  IdealGear idealGear(final useSupport=useSupport, final ratio=ratio)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
public
  Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Mechanics.Rotational.Interfaces.Support support if useSupport
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
equation
  connect(flange_a, inertia_a.flange_a)
    annotation (Line(points={{-80,0},{-100,0}},
      color={0,0,0}, smooth=Smooth.None));
  connect(inertia_b.flange_b, flange_b)
    annotation (Line(points={{60,0},{100,0}},
      color={0,0,0}, smooth=Smooth.None));
  connect(idealGear.support, support)
    annotation (Line(points={{0,-10},{0,-100}},
      color={0,0,0}, smooth=Smooth.None));
  connect(idealGear.flange_b, inertia_b.flange_a)
    annotation (Line(points={{10,0},{40,0}},
      color={0,0,0}, smooth=Smooth.None));
  connect(backlash.flange_a, inertia_a.flange_b)
    annotation (Line(points={{-40,0},{-60,0}},
      color={0,0,0}, smooth=Smooth.None));
  connect(backlash.flange_b, idealGear.flange_a)
    annotation (Line(points={{-20,0},{-10,0}},
      color={0,0,0}, smooth=Smooth.None));
  annotation ( Icon(graphics={
        Polygon(
          points={{-74,72},{-74,44},{-68,44},{-68,72},{-74,72}},
          smooth=Smooth.None,
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-100,72},{-94,72},{-94,52},{-74,52},{-74,72},{-44,72},{-44,76},
              {-100,76},{-100,72}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-100,44},{-68,44},{-68,64},{-48,64},{-48,44},{-44,44},{-44,40},
              {-100,40},{-100,44}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,0},
          fillColor={205,230,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}));
end GearWithBacklash;
