within ModelicaByExample.Components.HeatTransfer.Examples;
model ComplexNetwork "A complex heat transfer network"

  ThermalCapacitance cap1(C=0.12, T0(displayUnit="degC") = 363.15)
    "Thermal capacitance component"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Convection conv3(h=0.7,A=1.0)
    annotation (Placement(transformation(extent={{52,-10},{72,10}})));
  AmbientCondition amb2(T_amb(displayUnit="degC") = 298.15)
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Convection conv2(h=0.2,A=1.0)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Convection conv4(h=1.1,A=1.0)
    annotation (Placement(transformation(extent={{34,30},{54,50}})));
  ThermalCapacitance cap2(                              C=0.32, T0(displayUnit=
          "degC") = 363.15) "Thermal capacitance component"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Convection conv5(h=1.3,A=1.0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={10,-40})));
  Convection conv1(h=0.8,A=1.0)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  AmbientCondition amb1(T_amb(displayUnit="K") = 300)
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
equation
  connect(amb2.node, conv3.port_b) annotation (Line(
      points={{90,0},{72,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conv2.port_b, conv3.port_a) annotation (Line(
      points={{40,0},{52,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conv4.port_b, amb2.node) annotation (Line(
      points={{54,40},{80,40},{80,0},{90,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conv4.port_a, cap1.node) annotation (Line(
      points={{34,40},{10,40},{10,0},{-10,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conv2.port_a, cap1.node) annotation (Line(
      points={{20,0},{-10,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conv5.port_a, cap1.node) annotation (Line(
      points={{10,-30},{10,0},{-10,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conv5.port_b, cap2.node) annotation (Line(
      points={{10,-50},{10,-70},{-10,-70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conv1.port_b, cap1.node) annotation (Line(
      points={{-30,0},{-10,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conv1.port_a, amb1.node) annotation (Line(
      points={{-50,0},{-80,0}},
      color={191,0,0},
      smooth=Smooth.None));
end ComplexNetwork;
