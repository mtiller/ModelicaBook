within ModelicaByExample.Functions.Interpolation;
type VectorTable "A vector table implemented as an ExternalObject"
  extends ExternalObject;
  function constructor
    input Real ybar[:,2];
    output VectorTable table;
    external "C" table=createVectorTable(ybar, size(ybar,1))
      annotation(IncludeDirectory="modelica://ModelicaByExample.Functions.Interpolation/source",
                 Include="#include \"VectorTable.c\"");
  end constructor;

  function destructor "Release storage"
    input VectorTable table;
    external "C" destroyVectorTable(table)
      annotation(IncludeDirectory="modelica://ModelicaByExample.Functions.Interpolation/source",
                 Include="#include \"VectorTable.c\"");
  end destructor;
end VectorTable;
