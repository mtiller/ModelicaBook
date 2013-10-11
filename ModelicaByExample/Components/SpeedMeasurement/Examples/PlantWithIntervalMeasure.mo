within ModelicaByExample.Components.SpeedMeasurement.Examples;
model PlantWithIntervalMeasure
  "Comparison between ideal and an interval measuring sensor"
  extends Plant;
  Components.IntervalMeasure intervalMeasure(tooth_angle=0.17453292519943)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,30})));
equation
  connect(intervalMeasure.flange, inertia.flange_b) annotation (Line(
      points={{20,20},{20,0},{10,0}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    experiment(StopTime=10, Tolerance=1e-006),
    __Dymola_experimentSetupOutput);
end PlantWithIntervalMeasure;
