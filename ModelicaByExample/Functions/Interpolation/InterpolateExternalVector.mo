within ModelicaByExample.Functions.Interpolation;
function InterpolateExternalVector
  "Interpolate a function defined by a vector using an ExternalObject"
  input Real x;
  input VectorTable table;
  output Real y;
  external "C" y = interpolateVectorTable(table, x)
    annotation(IncludeDirectory="modelica://ModelicaByExample.Functions.Interpolation/source",
               Include="#include \"VectorTable.c\"");
end InterpolateExternalVector;
