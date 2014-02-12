within ModelicaByExample.Architectures.SensorComparison.Examples;
model Variant2_tuned "A tuned up version of variant 2"
  extends Variant2(
    controller(yMax=50, Ti=0.03, Td=0.03, k=5),
    actuator(uMax=50),
    sensor(sample_rate=0.01));
end Variant2_tuned;
