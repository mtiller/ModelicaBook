within ModelicaByExample.Components.SpeedMeasurement.Examples;
model PlantWithIntervalMeasure
  "Comparison between ideal and an interval measuring sensor"
  extends Plant;
  Components.IntervalMeasure intervalMeasure(teeth=200)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}}, rotation=90,
        origin={20,30})));
equation
  connect(intervalMeasure.flange, inertia1.flange_b) annotation (Line(
      points={{20,20},{20,0},{10,0}}, color={0,0,0},
      smooth=Smooth.None));
  annotation (experiment(StopTime=10, Tolerance=1e-006));
end PlantWithIntervalMeasure;
