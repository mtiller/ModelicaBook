within ModelicaByExample.Functions.Nonlinearities;
function Quadratic "A quadratic function"
  input Real a "2nd order coefficient";
  input Real b "1st order coefficient";
  input Real c "constant term";
  input Real x "independent variable";
  output Real y "dependent variable";
algorithm
  y := a*x*x + b*x + c;
  annotation(inverse(x = InverseQuadratic(a,b,c,y)));
end Quadratic;
