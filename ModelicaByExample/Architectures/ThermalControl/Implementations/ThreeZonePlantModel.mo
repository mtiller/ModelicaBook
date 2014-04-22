within ModelicaByExample.Architectures.ThermalControl.Implementations;
model ThreeZonePlantModel "A plant model with three zones"
  extends Interfaces.PlantModel;
  parameter Modelica.SIunits.HeatCapacity C "Zone capacitance";
  parameter Modelica.SIunits.ThermalConductance G "Conductance between rooms";
  parameter Modelica.SIunits.Temperature T_ambient "Fixed temperature at port";
  parameter Real h "Convenction coefficient";
protected
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor zone1(C=C)
    annotation (Placement(transformation(extent={{-70,-40},{-50,-20}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor cond12(G=G)
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor zone2(C=C)
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor cond23(G=G)
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor zone3(C=C)
    annotation (Placement(transformation(extent={{50,-40},{70,-20}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor cond13(G=G)
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature ambient(final T=T_ambient)
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));

  Modelica.Thermal.HeatTransfer.Components.Convection convection annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,20})));
  Modelica.Thermal.HeatTransfer.Components.Convection convection1 annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,40})));
  Modelica.Thermal.HeatTransfer.Components.Convection convection2 annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={28,60})));
  Modelica.Blocks.Sources.Constant const(final k=h)
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));

equation
  connect(zone1.port, furnace) annotation (Line(
      points={{-60,-40},{-80,-40},{-80,0},{-100,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(zone1.port, cond13.port_a) annotation (Line(
      points={{-60,-40},{-60,-80},{-10,-80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(cond13.port_b, zone3.port) annotation (Line(
      points={{10,-80},{60,-80},{60,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(zone1.port, cond12.port_a) annotation (Line(
      points={{-60,-40},{-40,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(cond12.port_b, zone2.port) annotation (Line(
      points={{-20,-40},{0,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(zone2.port, cond23.port_a) annotation (Line(
      points={{0,-40},{20,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(cond23.port_b, zone3.port) annotation (Line(
      points={{40,-40},{60,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(zone3.port, room) annotation (Line(
      points={{60,-40},{80,-40},{80,0},{100,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ambient.port, convection2.fluid) annotation (Line(
      points={{-70,80},{28,80},{28,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convection1.fluid, ambient.port) annotation (Line(
      points={{-10,50},{-10,80},{-70,80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convection.fluid, ambient.port) annotation (Line(
      points={{-50,30},{-50,80},{-70,80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(const.y, convection.Gc) annotation (Line(
      points={{-79,40},{-70,40},{-70,20},{-60,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, convection1.Gc) annotation (Line(
      points={{-79,40},{-20,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, convection2.Gc) annotation (Line(
      points={{-79,40},{-40,40},{-40,60},{18,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(convection.solid, zone1.port) annotation (Line(
      points={{-50,10},{-50,-40},{-60,-40},{-60,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convection1.solid, zone2.port) annotation (Line(
      points={{-10,30},{-10,-40},{0,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convection2.solid, zone3.port) annotation (Line(
      points={{28,50},{30,50},{30,-20},{48,-20},{48,-40},{60,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation ( Icon(graphics={
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,0}),
        Ellipse(
          extent={{-80,20},{-40,-20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={170,213,255}),
        Ellipse(
          extent={{-20,20},{20,-20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={170,213,255}),
        Ellipse(
          extent={{40,20},{80,-20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={170,213,255}),
        Line(
          points={{-40,0},{-20,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{20,0},{40,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-80,0},{-90,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{80,0},{90,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-60,-20},{-60,-40},{60,-40},{60,-20}},
          color={0,0,0},
          smooth=Smooth.None)}));
end ThreeZonePlantModel;
