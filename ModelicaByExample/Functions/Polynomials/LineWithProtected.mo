within ModelicaByExample.Functions.Polynomials;
function LineWithProtected "The Line function with protected variables"
  input Real x     "Independent variable";
  input Real p0[2] "Coordinates for one point on the line";
  input Real p1[2] "Coordinates for another point on the line";
  output Real y    "Value of y at the specified x";
protected
  Real m = (p1[2]-p0[2])/(p1[1]-p0[1])        "Slope";
  Real b = (p1[2]+p0[2]-m*(p1[1]+p0[1]))/2.0  "Offset";
algorithm
  y := m*x+b;
end LineWithProtected;
