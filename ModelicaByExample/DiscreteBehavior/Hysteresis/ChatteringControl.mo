within ModelicaByExample.DiscreteBehavior.Hysteresis;
model ChatteringControl "A control strategy that will 'chatter'"
  type HeatCapacitance=Real(unit="J/K");
  type Temperature=Real(unit="K");
  type Heat=Real(unit="W");
  type Mass=Real(unit="kg");
  type HeatTransferCoefficient=Real(unit="W/K");
  Boolean heat "Indicates whether heater is on";
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
  heat = T<Tbar;
  Q = if heat then Qcapacity else 0;
  C*der(T) = Q-h*(T-Tamb);
end ChatteringControl;
