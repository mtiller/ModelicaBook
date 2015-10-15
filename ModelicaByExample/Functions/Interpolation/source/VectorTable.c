#ifndef _VECTOR_TABLE_C_
#define _VECTOR_TABLE_C_

#include <stdlib.h>
#include "ModelicaUtilities.h"

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
createVectorTable(double *data, size_t np) {
  VectorTable *table = (VectorTable*) malloc(sizeof(VectorTable));
  if (table) {
    /* Allocate memory for data */
    table->x = (double*) malloc(sizeof(double)*np);
    if (table->x) {
      table->y = (double*) malloc(sizeof(double)*np);
      if (table->y) {
        /* Copy data into our local array */
        size_t i;
        for(i=0;i<np;i++) {
          table->x[i] = data[2*i];
          table->y[i] = data[2*i+1];
        }
        /* Initialize the rest of the table object */
        table->npoints = np;
        table->lastIndex = 0;
      }
      else {
        free(table->x);
        free(table);
        table = NULL;
        ModelicaError("Memory allocation error\n");
      }
    }
    else {
      free(table);
      table = NULL;
      ModelicaError("Memory allocation error\n");
    }
  }
  else {
    ModelicaError("Memory allocation error\n");
  }
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
    ModelicaFormatError("Requested value of x=%g is below the lower bound of %g\n",
      x, table->x[0]);
  if (x>table->x[table->npoints-1])
    ModelicaFormatError("Requested value of x=%g is above the upper bound of %g\n",
      x, table->x[table->npoints-1]);

  while(i<table->npoints-1&&x>table->x[i+1]) i++;
  while(i>0&&x<table->x[i]) i--;

  p = (x-table->x[i])/(table->x[i+1]-table->x[i]);
  table->lastIndex = i;
  return p*table->y[i+1]+(1-p)*table->y[i];
}

#endif
