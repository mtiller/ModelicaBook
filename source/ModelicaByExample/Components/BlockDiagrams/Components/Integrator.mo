within ModelicaByExample.Components.BlockDiagrams.Components;
block Integrator
  "This block integrates the input signal to compute the output signal"
  parameter Real y0 "Initial condition";
  extends Interfaces.SISO;
initial equation
  y = y0;
equation
  der(y) = u;
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-42,4},{42,-4}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-42,80},{42,0}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="1"),
        Text(
          extent={{-42,0},{42,-80}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="s")}));
end Integrator;
