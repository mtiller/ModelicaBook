within ModelicaByExample.Components.SpeedMeasurement.Examples;
model Plant "The basic plant model"
  extends ModelicaByExample.Components.Rotational.Examples.SMD;
  Components.IdealSensor idealSensor
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
                          rotation=90, origin={-20,30})));
equation
  connect(idealSensor.flange, inertia1.flange_a) annotation (Line(
      points={{-20,20},{-20,0},{-10,0}}, color={0,0,0},
      smooth=Smooth.None));
  annotation(experiment(StopTime=10, Tolerance=1e-006));
end Plant;
