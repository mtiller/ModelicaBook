within ModelicaByExample.Subsystems.LotkaVolterra.Examples;
model WithMigration "Connect populations by migration"
  extends InitiallyDifferent;
  Components.Migration migrate_AB "Migration from region A to region B"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Components.Migration migrate_BC "Migration from region B to region C"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Components.Migration migrate_CD "Migration from region C to region D"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
equation
  connect(migrate_CD.rabbit_b, D.rabbits) annotation (Line(
      points={{-6,-70},{-6,-76},{-20,-76},{-20,-90},{-10,-90}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(migrate_CD.rabbit_a, C.rabbits) annotation (Line(
      points={{-6,-50},{-6,-44},{-20,-44},{-20,-30},{-10,-30}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(migrate_BC.rabbit_b, C.rabbits) annotation (Line(
      points={{-6,-10},{-6,-16},{-20,-16},{-20,-30},{-10,-30}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(migrate_CD.fox_b, D.foxes) annotation (Line(
      points={{6,-70},{6,-76},{20,-76},{20,-90},{10,-90}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(migrate_BC.fox_b, C.foxes) annotation (Line(
      points={{6,-10},{6,-16},{20,-16},{20,-30},{10,-30}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(migrate_CD.fox_a, C.foxes) annotation (Line(
      points={{6,-50},{6,-44},{20,-44},{20,-30},{10,-30}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(migrate_BC.fox_a, B.foxes) annotation (Line(
      points={{6,10},{6,16},{20,16},{20,30},{10,30}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(migrate_BC.rabbit_a, B.rabbits) annotation (Line(
      points={{-6,10},{-6,16},{-20,16},{-20,30},{-10,30}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(migrate_AB.fox_b, B.foxes) annotation (Line(
      points={{6,50},{6,50},{6,44},{20,44},{20,30},{10,30}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(migrate_AB.rabbit_b, B.rabbits) annotation (Line(
      points={{-6,50},{-6,44},{-20,44},{-20,30},{-10,30}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(migrate_AB.fox_a, A.foxes) annotation (Line(
      points={{6,70},{6,76},{20,76},{20,90},{10,90}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(migrate_AB.rabbit_a, A.rabbits) annotation (Line(
      points={{-6,70},{-6,76},{-20,76},{-20,90},{-10,90}},
      color={0,127,0},
      smooth=Smooth.None));
end WithMigration;
