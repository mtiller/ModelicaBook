within ModelicaByExample.ArrayEquations.StateSpace.Examples;
model LotkaVolterra "Lotka-Volterra model in state space form"
  parameter Real alpha=0.1 "Reproduction rate of prey";
  parameter Real beta=0.02 "Mortality rate of predator per prey";
  parameter Real gamma=0.4 "Mortality rate of predator";
  parameter Real delta=0.02 "Reproduction rate of predator per prey";
  parameter Real x_init=10 "Initial prey population";
  parameter Real y_init=10 "Initial predator population";
  extends ABCD(nx=2, nu=0, ny=0, x0={x_init, y_init});
equation
  // This model is in ABCD form but the A matrix includes a
  // *nonlinear* term. As such, it can be cast into a general
  // (non-LTI) ABCD form that allows the matrices to be both
  // non-linear and time variant. This form is still useful in some
  // cases because it can be used to compute properties that can be
  // applied locally to some region of state space (e.g., natural
  // frequencies).

  A = [alpha-beta*x[2], 0; 0, -gamma+delta*x[1]];
  B = fill(0,2,0);
  C = fill(0,0,2);
  D = fill(0,0,0);
  u = fill(0,0);
end LotkaVolterra;
