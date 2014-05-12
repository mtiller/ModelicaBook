within ModelicaByExample.Subsystems.LotkaVolterra.Examples;
model UnconnectedPopulations "Several unconnected regional populations"
  Components.TwoSpecies A "Region A"
    annotation (Placement(transformation(extent={{-10,80},{10,100}})));
  Components.TwoSpecies B "Region B"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Components.TwoSpecies C "Region C"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Components.TwoSpecies D "Region D"
    annotation (Placement(transformation(extent={{-10,-100},{10,-80}})));
  annotation (experiment(StopTime=40, Intervals=0.008));
end UnconnectedPopulations;
