within ModelicaByExample.Architectures.SensorComparison.Interfaces;
partial model Controller "Interface for controller subsystem"
  Modelica.Blocks.Interfaces.RealInput setpoint "Desired system response"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120})));
  Modelica.Blocks.Interfaces.RealInput measured "Actual system response"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,0})));
  Modelica.Blocks.Interfaces.RealOutput command "Command to send to actuator"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-110,0})));
  annotation (Icon(graphics={Rectangle(extent={{-100,100},{
              100,-100}}, lineColor={0,128,255})}));
end Controller;
