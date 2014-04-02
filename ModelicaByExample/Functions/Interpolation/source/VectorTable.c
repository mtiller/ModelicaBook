#ifndef _VECTOR_TABLE_C_
#define _VECTOR_TABLE_C_

/*
  Here we define the structure associated
  with our ExternalObject type 'VectorTable'
*/
typedef struct {
  double *x; /* Independent variable values */
  double *y; /* Dependent variable values */
  size_t npoints; /* Number of points in this data */
  size_t lastIndex; /* Cached value of last index */
} VectorTable;

void *
createVectorTable(const double *data, size_t np) {
  VectorTable *table = malloc(sizeof(VectorTable));
  size_t i;
  
  /* Allocate memory for data */
  table->x = malloc(sizeof(double)*np);
  table->y = malloc(sizeof(double)*np);
  /* Copy data into our local array */
  for(i=0;i<np;i++) {
    table->x[i] = data[2*i];
	table->y[i] = data[2*i+1];
  }
  for(i=0;i<2*np;i++) ModelicaFormatMessage("Value at %d is %g\n", i, data[i]);
  /* Initialize the rest of the table object */
  table->npoints = np;
  table->lastIndex = 0;
  return table;
}

void
destroyVectorTable(void *object) {
  VectorTable *table = (VectorTable *)object;
  if (table==NULL) return;
  free(table->x);
  free(table->y);
  free(table);
}

double
interpolateVectorTable(void *object, double x) {
  VectorTable *table = (VectorTable *)object;
  size_t i = table->lastIndex;
  double p;
  
  ModelicaFormatMessage("Request to compute value of y at %g\n", x);
  if (x<table->x[0])
    ModelicaFormatError("Requested value of x=%g is below the lower bound of %g\n", x, table->x[0]);
  if (x>table->x[table->npoints-1])
    ModelicaFormatError("Requested value of x=%g is above the upper bound of %g\n", x, table->x[table->npoints-1]);
	
  while(x>=table->x[i+1]) i = i + 1;
  while(x<table->x[i]) i = i - 1;
  
  p = (x-table->x[i])/(table->x[i+1]-table->x[i]);
  table->lastIndex = i;
  return p*table->y[i+1]+(1-p)*table->y[i];
}

#endif
