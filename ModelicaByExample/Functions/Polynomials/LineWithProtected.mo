within ModelicaByExample.Functions.Polynomials;
function LineWithProtected "The Line function with protected variables"
  input Real x     "Independent variable";
  input Real p0[2] "Coordinates for one point on the line";
  input Real p1[2] "Coordinates for another point on the line";
  output Real y    "Value of y at the specified x";
protected
  Real x0 = p0[1], x1 = p1[1];
  Real y0 = p0[2], y1 = p1[2];
  Real m = (y1-y0)/(x1-x0)  "Slope";
  Real b = (y0-m*x0)        "Offset";
algorithm
  y := m*x+b;
end LineWithProtected;
