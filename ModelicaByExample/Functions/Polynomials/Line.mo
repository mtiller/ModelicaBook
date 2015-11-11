within ModelicaByExample.Functions.Polynomials;
function Line "Compute coordinates along a line"
  input Real x     "Independent variable";
  input Real p0[2] "Coordinates for one point on the line";
  input Real p1[2] "Coordinates for another point on the line";
  output Real y    "Value of y at the specified x";
algorithm
  y := (p1[2]-p0[2])/(p1[1]-p0[1])*(x-p0[1])+p0[2];
end Line;
