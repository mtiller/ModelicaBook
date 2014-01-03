within ModelicaByExample.Functions.ImpureFunctions;
model HysteresisEmbeddedControl "A control strategy that uses embedded C code"
  type HeatCapacitance=Real(unit="J/K");
  type Temperature=Real(unit="K");
  type Heat=Real(unit="W");
  type Mass=Real(unit="kg");
  type HeatTransferCoefficient=Real(unit="W/K");
  parameter HeatCapacitance C=1.0;
  parameter HeatTransferCoefficient h=2.0;
  parameter Heat Qcapacity=25.0;
  parameter Temperature Tamb=285;
  parameter Temperature Tbar=295;
  Temperature T;
  Heat Q;
initial equation
  T = Tbar+5;
equation
  when sample(0, 0.01) then
    Q = computeHeat(T, Tbar, Qcapacity);
  end when;
  C*der(T) = Q-h*(T-Tamb);
end HysteresisEmbeddedControl;
