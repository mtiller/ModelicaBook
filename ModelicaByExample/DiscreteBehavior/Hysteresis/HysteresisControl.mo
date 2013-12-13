within ModelicaByExample.DiscreteBehavior.Hysteresis;
model HysteresisControl "A control strategy that doesn't chatter"
  type HeatCapacitance=Real(unit="J/K");
  type Temperature=Real(unit="K");
  type Heat=Real(unit="W");
  type Mass=Real(unit="kg");
  type HeatTransferCoefficient=Real(unit="W/K");
  Boolean heat(start=false) "Indicates whether heater is on";
  parameter HeatCapacitance C=1.0;
  parameter HeatTransferCoefficient h=2.0;
  parameter Heat Qcapacity=25.0;
  parameter Temperature Tamb=285;
  parameter Temperature Tbar=295;
  Temperature T;
  Heat Q;
initial equation
  T = Tbar+5;
  heat = false;
equation
  Q = if heat then Qcapacity else 0;
  C*der(T) = Q-h*(T-Tamb);
  when {T>Tbar+1,T<Tbar-1} then
    heat = T<Tbar;
  end when;
end HysteresisControl;
