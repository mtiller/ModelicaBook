within ModelicaByExample.Functions.Interpolation;
function InterpolateVector "Interpolate a function defined by a vector"
  input Real x         "Independent variable";
  input Real ybar[:,2] "Interpolation data";
  output Real y        "Dependent variable";
protected
  Integer i;
  Integer n = size(ybar,1) "Number of interpolation points";
  Real p;
algorithm
  assert(x>=ybar[1,1], "Independent variable must be greater than or equal to "+String(ybar[1,1]));
  assert(x<=ybar[n,1], "Independent variable must be less than or equal to "+String(ybar[n,1]));
  i := 1;
  while x>=ybar[i+1,1] loop
    i := i + 1;
  end while;
  p := (x-ybar[i,1])/(ybar[i+1,1]-ybar[i,1]);
  y := p*ybar[i+1,2]+(1-p)*ybar[i,2];
end InterpolateVector;
