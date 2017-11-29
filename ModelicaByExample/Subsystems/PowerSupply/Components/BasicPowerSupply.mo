within ModelicaByExample.Subsystems.PowerSupply.Components;
model BasicPowerSupply "Power supply with transformer and rectifier"
  import Modelica.Electrical.Analog;
  parameter Modelica.SIunits.Capacitance C=1e-2
    "Filter capacitance"
    annotation(Dialog(group="General"));
  parameter Modelica.SIunits.Conductance Goff=1e-5
    "Backward state-off conductance (opened diode conductance)"
    annotation(Dialog(group="General"));
  parameter Modelica.SIunits.Resistance Ron=1e-5
    "Forward state-on differential resistance (closed diode resistance)"
    annotation(Dialog(group="General"));
  parameter Real n=10
    "Turns ratio primary:secondary voltage"
    annotation(Dialog(group="Transformer"));
  parameter Boolean considerMagnetization=false
    "Choice of considering magnetization"
    annotation(Dialog(group="Transformer"));
  parameter Modelica.SIunits.Inductance Lm1=1e-2
    "Magnetization inductance w.r.t. primary side"
    annotation(Dialog(group="Transformer", enable=considerMagnetization));

  Analog.Interfaces.NegativePin gnd
    "Pin to ground power supply"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  Analog.Interfaces.PositivePin p
    "Positive pin on supply side"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Analog.Interfaces.PositivePin p_load
    "Positive pin for load side"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Analog.Interfaces.NegativePin n_load
    "Negative pin for load side"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
protected
  Analog.Ideal.IdealTransformer transformer(
    final n=n, final considerMagnetization=considerMagnetization,
    final Lm1=Lm1)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Analog.Ideal.IdealDiode D1(final Vknee=0, final Ron=Ron, final Goff=Goff)
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=45,
        origin={-2,10})));
  Analog.Basic.Capacitor capacitor(C=C)
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,-20})));
  Analog.Ideal.IdealDiode D2(final Vknee=0, final Ron=Ron, final Goff=Goff)
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-45,
        origin={22,10})));
  Analog.Ideal.IdealDiode D3(final Vknee=0, final Ron=Ron, final Goff=Goff)
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-45,
        origin={-2,-10})));
  Analog.Ideal.IdealDiode D4(final Vknee=0, final Ron=Ron, final Goff=Goff)
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=45,
        origin={22,-10})));
equation
  connect(D1.p, capacitor.n) annotation (Line(
      points = {{-9.07107, 2.92893}, {-8.5355, 2.92893}, {-8.5355, 2.92893}, {-14, 2.92893}, {-14, -42}, {70, -42}, {70, -30}},
      color={0,0,255}));
  connect(transformer.p2, D1.n) annotation(
    Line(points = {{-40, 5}, {-40, 24}, {10, 24}, {10, 17.0711}, {5.07107, 17.0711}}, color = {0, 0, 255}));
  connect(capacitor.p, D2.n) annotation(
    Line(points = {{70, -10}, {70, 2.92893}, {29.0711, 2.92893}}, color = {0, 0, 255}));
  connect(D2.n, D4.n) annotation(
    Line(points = {{29, 3}, {29, 3}, {29, -3}, {29, -3}}, color = {0, 0, 255}));
  connect(D1.p, D3.p) annotation(
    Line(points = {{-9, 3}, {-9, 3}, {-9, -3}, {-9, -3}}, color = {0, 0, 255}));
  connect(D3.n, D4.p) annotation(
    Line(points = {{5, -17}, {15, -17}, {15, -17}, {15, -17}}, color = {0, 0, 255}));
  connect(D1.n, D2.p) annotation(
    Line(points = {{5, 17}, {15, 17}, {15, 17}, {15, 17}}, color = {0, 0, 255}));
  connect(D4.p,transformer. n2) annotation (Line(
      points={{14.9289,-17.0711},{10,-17.0711},{10,-30},{-40,-30},{-40,-5}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(transformer.n1, gnd) annotation (Line(
      points={{-60,-5},{-60,-60},{-100,-60}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(transformer.n2, gnd) annotation (Line(
      points={{-40,-5},{-40,-60},{-100,-60}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(transformer.p1, p) annotation (Line(
      points={{-60,5},{-60,60},{-100,60}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(capacitor.p, p_load) annotation (Line(
      points={{70,-10},{70,60},{100,60}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(capacitor.n, n_load) annotation (Line(
      points={{70,-30},{70,-60},{100,-60}},
      color={0,0,255},
      smooth=Smooth.None));
end BasicPowerSupply;
