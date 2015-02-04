within ModelicaByExample.Components.ChemicalReactions.Examples;
model ABX_System "Model of simple two reaction system"
  ABX.Components.Solution solution(C(each fixed=true, start={1,1,0}))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  ABX.Components.'A+B->X' 'A+B->X'(k=0.1)
    annotation (Placement(transformation(extent={{30,30},{50,50}})));
  ABX.Components.'A+B<-X' 'A+B<-X'(k=0.1)
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  ABX.Components.'X+B->R+S' 'X+B->R+S'(k=10)
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
equation
  connect('A+B<-X'.mixture, solution.mixture) annotation (Line(
      points={{30,0},{10,0}}, color={0,0,0},
      pattern=LinePattern.None));
  connect('X+B->R+S'.mixture, solution.mixture) annotation (Line(
      points={{30,-40},{20,-40},{20,0},{10,0}},
      color={0,0,0}, pattern=LinePattern.None));
  connect('A+B->X'.mixture, solution.mixture) annotation (Line(
      points={{30,40},{20,40},{20,0},{10,0}},
      color={0,0,0}, pattern=LinePattern.None));
end ABX_System;
