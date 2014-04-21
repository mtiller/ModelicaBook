within ModelicaByExample.SupportingMaterial;
model RotSMD_WithBacklash "Inserting a backlash element"
  extends RotSMD(J2(phi(fixed=true, start=0), w(fixed=true, start=0)), J1(w(
          fixed=true, start=5)));
  Modelica.Mechanics.Rotational.Components.ElastoBacklash backlash(
    c=1000,
    b(displayUnit="rad") = 0.5,
    d=0) annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
equation
  connect(backlash.flange_b, J2.flange_a) annotation (Line(
      points={{-30,0},{-20,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(backlash.flange_a, J1.flange_b) annotation (Line(
      points={{-50,0},{-60,0}},
      color={0,0,0},
      smooth=Smooth.None));
end RotSMD_WithBacklash;
