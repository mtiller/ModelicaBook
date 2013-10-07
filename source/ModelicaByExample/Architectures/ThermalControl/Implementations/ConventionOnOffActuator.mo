within ModelicaByExample.Architectures.ThermalControl.Implementations;
model ConventionOnOffActuator "Attempt to implement on-off actuator"
  extends Interfaces.Actuator;
  parameter Real heating_capacity "Heating capacity of actuator";
protected
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heater
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Math.BooleanToReal command(realTrue=heating_capacity,
      realFalse=0)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(heater.port, furnace) annotation (Line(
      points={{10,0},{100,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(command.y, heater.Q_flow) annotation (Line(
      points={{-39,0},{-10,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics={Text(
          extent={{-100,20},{-60,-20}},
          lineColor={255,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="?")}));
end ConventionOnOffActuator;
