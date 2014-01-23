within ModelicaByExample.Connectors;
package Graphics
  connector PositivePin
     Modelica.SIunits.Voltage v;
     flow Modelica.SIunits.Current i;
    annotation (
      Icon(graphics={
          Ellipse(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,255},
            fillColor={85,170,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-10,58},{10,-62}},
            fillColor={0,128,255},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Rectangle(
            extent={{-60,10},{60,-10}},
            fillColor={0,128,255},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None,
            lineColor={0,0,0}),
          Text(
            extent={{-100,-100},{100,-140}},
            lineColor={0,0,255},
            fillColor={85,170,255},
            fillPattern=FillPattern.Solid,
            textString="%name")}),
      Documentation(info="<html>
<p>This connector is used to represent the &quot;positive&quot; pins on
electrical components.  This does not imply that the voltage at this pin needs
to be positive or even greater than voltages on <a
href=\"modelica://ModelicaByExample.Connectors.Graphics.NegativePin\">
&quot;negative&quot; pins</a>.  It is simply a convention used to distinguish
different connectors on components (particularly those with only two pins).</p>
</html>"));
  end PositivePin;

  connector NegativePin
     Modelica.SIunits.Voltage v;
     flow Modelica.SIunits.Current i;
    annotation (
      Icon(graphics={
          Ellipse(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,255},
            fillColor={85,170,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-60,10},{60,-10}},
            fillColor={0,128,255},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None,
            lineColor={0,0,0}),
          Text(
            extent={{-100,-100},{100,-140}},
            lineColor={0,0,255},
            fillColor={85,170,255},
            fillPattern=FillPattern.Solid,
            textString="%name")}),
      Documentation(info="<html>
<p>This pin and
<a href=\"modelica://ModelicaByExample.Connectors.Graphics.PositivePin\">
its counterpart</a> are documented in
<a href=\"modelica://ModelicaByExample.Connectors.Graphics.PositivePin\">
PositivePin</a>.</p>
</html>"));
  end NegativePin;
end Graphics;
