within ModelicaByExample.Architectures.SensorComparison.Examples;
model Variant2 "Adds PID control and realistic actuator subsystems"
  extends Variant1(
      redeclare replaceable Implementation.PID_Controller controller(
        yMax=15, Td=0.1, k=20, Ti=0.1),
      redeclare replaceable Implementation.LimitedActuator actuator(
        delayTime=0.005, uMax=10));
end Variant2;
