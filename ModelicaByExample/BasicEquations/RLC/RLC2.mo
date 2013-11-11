within ModelicaByExample.BasicEquations.RLC;
model RLC2
  type Voltage=Real(unit="V");
  type Current=Real(unit="A");
  type Resistance=Real(unit="Ohm");
  type Capacitance=Real(unit="F");
  type Inductance=Real(unit="H");
  parameter Voltage Vb=24 "Battery voltage";
  parameter Inductance L = 1;
  parameter Resistance R = 100;
  parameter Capacitance C = 1e-3;
  Voltage V;
  Current i_L;
  Current i_R;
  Current i_C;
equation
  der(V) = i_C/C;
  der(i_L) = (Vb-V)/L;
  i_R = i_L-i_C;
  V = i_R*R;
end RLC2;
