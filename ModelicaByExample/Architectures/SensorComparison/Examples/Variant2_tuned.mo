within ModelicaByExample.Architectures.SensorComparison.Examples;
model Variant2_tuned "A tuned up version of variant 2"
  extends Variant2(
    controller(yMax=50, Ti=0.07, Td=0.01, k=4),
    actuator(uMax=50),
    sensor(sample_time=0.01));
end Variant2_tuned;
