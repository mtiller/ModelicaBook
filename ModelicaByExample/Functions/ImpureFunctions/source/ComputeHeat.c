#ifndef _COMPUTE_HEAT_C_
#define _COMPUTE_HEAT_C_

#define UNINITIALIZED -1
#define ON 1
#define OFF 0

double
computeHeat(double T, double Tbar, double Q) {
  static int state = UNINITIALIZED;
  if (state==UNINITIALIZED) {
    if (T>Tbar) state = OFF;
    else state = ON;
  }
  if (state==OFF && T<Tbar-2) state = ON;
  if (state==ON && T>Tbar+2) state = OFF;

  if (state==ON) return Q;
  else return 0;
}

#endif
