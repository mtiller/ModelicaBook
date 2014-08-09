import os
import sys

sys.path.append(os.path.join(".", "source", "_sphinxext"))

from xogeny.gen_utils import *

## Simple Examples
fovars = [Var("x", legend="x")]
add_case(["SimpleExample", "FirstOrder$"], res="FO", stopTime=10);
add_simple_plot(plot="FO", vars=fovars, title="Simulation of FirstOrder")

focvars = [Var("x", legend="x (FirstOrder)")]
foivars = [Var("x", legend="x (FirstOrderInitial)")]
add_case(["SimpleExample", "FirstOrderInitial"], stopTime=10, res="FOI")
add_compare_plot(plot="FOI",
                 res1="FOI", v1=foivars,
                 res2="FO", v2=focvars,
                 title="Specifying (non-zero) Initial Conditions")

add_case(["SimpleExample", "FirstOrderExperiment"], res="FOE")
add_simple_plot(plot="FOE", vars=fovars, title="Simulation Using Experiment Annotation")

fosvars = [Var("x", legend="x (FirstOrderSteady)")]
add_case(["SimpleExample", "FirstOrderSteady"], stopTime=10, res="FOS")
add_compare_plot(plot="FOS",
                 res1="FOS", v1=fosvars,
                 res2="FO", v2=focvars,
                 title="Steady State Solution (vs. Dynamic Response)")

## Cooling Example
add_case(["NewtonCoolingWithDefaults"], stopTime=1, res="NCWD")
add_simple_plot(plot="NCWD", vars=[Var("T")], title="Cooling to Ambient",
                legloc="upper right", ylabel="Temperature")

## RLC
add_case(["RLC1"], stopTime=2, res="RLC1")
add_simple_plot(plot="RLC1", vars=[Var("V", legend="Output Voltage (V)", style="-"),
                                   Var("Vb", legend="Battery Voltage (Vb)", style="-.")],
                ylabel="Voltage [V]",
                title="Circuit Response")

## RotationalSMD
sosvars = [Var("phi1", legend="Position of inertia 1 [rad]"),
           Var("phi2", legend="Position of inertia 2 [rad]"),
           Var("omega1", legend="Velocity of inertia 1 [rad/s]"),
           Var("omega2", legend="Velocity of inertia 2 [rad/s]")]
add_case(["SecondOrderSystemInitParams"], stopTime=5, res="SOSIP")
add_simple_plot(plot="SOSIP", vars=sosvars, title="Mechanical System Response")

add_case(["SecondOrderSystemInitParams"], stopTime=5, res="SOSIP1",
         mods={"phi1_init": 1.0})
add_simple_plot(plot="SOSIP1", vars=sosvars, title="Mechanical Response specifying phi1(0)")

## LotkaVolterra
lvvars = [Var("x", legend="Prey population"),
          Var("y", legend="Predator population")]

add_case(["ClassicModel$"], stopTime=140, res="LVCM")
add_simple_plot(plot="LVCM", vars=lvvars, title="Classic Lotka-Volterra")

add_case(["QuiescentModel$"], stopTime=140, res="LVQM")
add_simple_plot(plot="LVQM", vars=lvvars, title="Quiescent Model (trivial solution)")

add_case(["QuiescentModelUsingStart"], stopTime=140, res="LVQMUS")
add_simple_plot(plot="LVQMUS", vars=lvvars, ymax=25,
                title="Quiescent Model (using start values)")

## Cooling Revisited
ncdvars = [Var("T", legend="Temperature"),
           Var("T_inf", legend="Ambient Temperature")]
add_case(["NewtonCoolingDynamic"], stopTime=1, res="NCD")
add_simple_plot(plot="NCD", vars=ncdvars,
                title="Cooling to Time-Varying Ambient",
                legloc="upper right", ylabel="Temperature [K]")

add_case(["NewtonCoolingSteadyThenDynamic"], stopTime=1, res="NCSTD")
add_simple_plot("NCSTD", vars=ncdvars,
                title="Equilibrium Initialization",
                legloc="lower left", ylabel="Temperature [K]")

## Bouncing Ball
bbvars = [Var("h", legend="Height")]
add_case(["\.BouncingBall$"], stopTime=3, res="BB1")
add_simple_plot(plot="BB1", vars=bbvars,
                title="Simple Bouncing Ball Model",
                legloc="upper right", ylabel="Height [m]")
add_case(["\.BouncingBall$"], stopTime=5, res="BB2")
add_simple_plot(plot="BB2", vars=bbvars,
                title="Consequences of Numerical Event Detection",
                legloc="upper right", ylabel="Height [m]")
add_case(["Decay1$"], stopTime=5, res="Decay1", simfails=True)
add_simple_plot(plot="Decay1", vars=[Var("x")],
                title="Decay with Numerical Noise",
                legloc="upper right")
add_case(["Decay2$"], stopTime=5, res="Decay2", tol=1e-1, simfails=True)
add_simple_plot(plot="Decay2", vars=[Var("x")],
                title="Decay with Guard Condition",
                legloc="upper right")
add_case(["Decay3$"], stopTime=5, res="Decay3", tol=1e-6)
add_simple_plot(plot="Decay3", vars=[Var("x")],
                title="Decay without Issue",
                legloc="upper right")
add_case(["Decay4$"], stopTime=5, res="Decay4", tol=1e-3)
add_simple_plot(plot="Decay4", vars=[Var("x")],
                title="Chattering",
                legloc="upper right")
add_case(["Decay5$"], stopTime=5, res="Decay5", tol=1e-3)
add_simple_plot(plot="Decay5", vars=[Var("x")],
                title="No Chattering",
                legloc="upper right")

## Accuracy
avs = [Var("x", legend="Integrated value"),
       Var("y", legend="Reference value")]
#       Var("active", legend="Activation flag")]
add_case(["WithEvents$"], stopTime=7.0, res="WE", tol=1e-1)
add_case(["WithEvents$"], stopTime=7.0, res="WEf", tol=1e-1, mods={"freq": 5.0})
add_case(["WithNoEvents$"], stopTime=7.0, res="WNE", tol=1e-1)
add_case(["WithNoEvents$"], stopTime=7.0, res="WNEf", tol=1e-1, mods={"freq": 5.0})

add_simple_plot(plot="WE", vars=avs, title="Integration with Events",
                legloc="upper right")

add_simple_plot(plot="WEf", vars=avs, title="Integration with Events (Higher Frequency)",
                legloc="upper right")

add_simple_plot(plot="WNE", vars=avs, title="Integration without Events",
                legloc="upper right")

add_simple_plot(plot="WNEf", vars=avs, title="Integration without Events (Higher Frequency)",
                legloc="upper right")

## Switched RLC
srlc_vvars = [Var("Vs", legend="Source Voltage, Vs [V]"),
              Var("V", legend="Response Voltage, V [V]")]
srlc_ivars = [Var("i_R", legend="Resistor Current [A]"),
              Var("i_C", legend="Capacitor Current [A]"),
              Var("i_L", legend="Inductor Current [A]")]
add_case(["SwitchedRLC\.SwitchedRLC"], stopTime=2, res="SRLC")
add_simple_plot(plot="SRLCv", res="SRLC", vars=srlc_vvars,
                title="Switched RLC Voltage Response",
                legloc="lower right")
add_simple_plot(plot="SRLCi", res="SRLC", vars=srlc_ivars,
                title="Switched RLC Current Response",
                legloc="lower right")

# Speed Measurement
mvars = [Var("omega1"), Var("omega1_measured")]
add_case(["SampleAndHold"], stopTime=5, res="SampleAndHold", tol=1e-3)
add_simple_plot(plot="SampleAndHold", vars=mvars,
                title="Sample and Hold Speed Measurement",
                legloc="upper right")

add_case(["DiscreteBehavior", "IntervalMeasure"], stopTime=5, res="IntervalMeasure", tol=1e-3)
add_simple_plot(plot="IntervalMeasure", vars=mvars,
                title="Speed Estimation by Interval Measurement",
                legloc="upper right")

add_case(["DiscreteBehavior", "IntervalMeasure"], stopTime=5,
         res="IntervalMeasure_Coarse", tol=1e-3, mods={"teeth": 20})
add_simple_plot(plot="IntervalMeasure_Coarse", vars=mvars,
                title="Speed Estimation Using Fewer Teeth",
                legloc="upper right")
add_simple_plot(plot="IntervalMeasure_Coarse_phi", res="IntervalMeasure_Coarse",
                vars=[Var("phi1"), Var("next_phi"), Var("prev_phi")],
                title="Angle vs. Teeth Angles",
                legloc="upper right")

add_case(["CounterWithAlgorithm"], stopTime=5,
         res="SpeedCounter", tol=1e-3)
add_simple_plot(plot="SpeedCounter", vars=mvars,
                title="Speed Estimation by Counting",
                legloc="upper right")
add_simple_plot(plot="SpeedCounter_count", vars=[Var("count")], res="SpeedCounter",
                title="Speed Estimation by Counting",
                legloc="upper right")

# Hysteresis
add_case(["ChatteringControl"], stopTime=0.5,
         res="CC1", tol=1e-1)
add_simple_plot(plot="CC1", vars=[Var("T")],
                title="Temperature Control with Chattering",
                legloc="upper right")
add_simple_plot(plot="CC1_Q", vars=[Var("Q")], res="CC1",
                title="Heater Output",
                legloc="upper right")
add_case(["HysteresisControl$"], stopTime=5,
         res="Hyst", tol=1e-3)
add_simple_plot(plot="Hyst", vars=[Var("T")],
                title="Temperature Control with Hysteresis",
                legloc="upper right")
add_simple_plot(plot="Hyst_Q", vars=[Var("Q")], res="Hyst",
                title="Heater Output with Hysteresis",
                legloc="upper right")
add_case(["HysteresisControlWithAlgorithm"], stopTime=5,
         res="HystA", tol=1e-3)
add_simple_plot(plot="HystA", vars=[Var("T")],
                title="Temperature Control with Hysteresis",
                legloc="upper right")
add_simple_plot(plot="HystA_Q", vars=[Var("Q")], res="HystA",
                title="Heater Output with Hysteresis",
                legloc="upper right")

# Synchronous Systems
add_case(["IndependentSampling"], stopTime=1.0, res="SIS", tol=1e-1)
add_simple_plot(plot="SIS", vars=[Var("x"), Var("y")], res="SIS",
                title="Independently Sampled Signals",
                legloc="upper right")
add_simple_plot(plot="SIS_e", vars=[Var("e")], res="SIS",
                title="Error of Independently Sampled Signals",
                legloc="upper right")

add_case(["SynchronizedSampling"], stopTime=1.0, res="SSS", tol=1e-1)
add_simple_plot(plot="SSS", vars=[Var("e")],
                title="Synchronously Sampled Signals",
                legloc="upper right")

add_case(["SubsamplingWithIntegers"], stopTime=1.0, res="SSI", tol=1e-3)
add_simple_plot(plot="SSI", vars=[Var("x"), Var("y"), Var("z")],
                title="Synchronized Sampling and Subsampling",
                legloc="upper right")

# ABCD
add_case(["StateSpace", "FirstOrder$"], stopTime=1.0, res="FO_LTI", tol=1e-3)
add_simple_plot(plot="FO_LTI", vars=[Var("x[1]")],
                title="First Order Example in LTI Form",
                legloc="upper right")

add_case(["StateSpace", "NewtonCooling"], stopTime=1.0, res="NC_LTI", tol=1e-3)
add_simple_plot(plot="NC_LTI", vars=[Var("x[1]")],
                title="Cooling Example in LTI Form",
                legloc="upper right")

add_case(["StateSpace", "RLC"], stopTime=1.0, res="RLC_LTI", tol=1e-3)
add_simple_plot(plot="RLC_LTI", vars=[Var("x[1]", "x[2]")],
                title="RLC Circuit Example in LTI Form",
                legloc="upper right")

add_case(["StateSpace", "RotationalSMD$"], stopTime=1.0, res="Ro_LTI", tol=1e-3)
add_simple_plot(plot="Ro_LTI", vars=[Var("x[1]", "x[2]")],
                title="Rotational Example in LTI Form",
                legloc="upper right")

add_case(["StateSpace", "RotationalSMD_Concat"], stopTime=1.0, res="RoC_LTI", tol=1e-3)
add_simple_plot(plot="RoC_LTI", vars=[Var("x[1]", "x[2]")],
                title="Rotational Example in LTI Form",
                legloc="upper right")

add_case(["StateSpace", "LotkaVolterra"], stopTime=1.0, res="LV_ABCD", tol=1e-3)
add_simple_plot(plot="LV_ABCD", vars=[Var("x[1]", "x[2]")],
                title="Lotka-Volterra Example in LTI Form",
                legloc="upper right")

# One Dimensional Heat Transfer
rfl_vars = map(lambda x: Var("T["+str(x)+"]"), range(1,11))
add_case(["Rod_ForLoop"], stopTime=1.0, res="RFL", tol=1e-3)
add_simple_plot(plot="RFL", vars=rfl_vars,
                title="One Dimensional Heat Transfer Response",
                legloc="upper right")

add_case(["Reactions_NoArrays"], stopTime=10.0, res="RNA")
add_simple_plot(plot="RNA", vars=[Var("cA"), Var("cB"), Var("cX", scale=50.0, legend="cX*50")],
                title="Simulation of Chemical System without Arrays",
                legloc="upper right")

add_case(["Reactions_Array"], stopTime=10.0, res="RA")
add_simple_plot(plot="RA", vars=[Var("C[1]"), Var("C[2]"), Var("C[3]")],
                title="Simulation of Chemical System with Arrays",
                legloc="upper right")

species_name = lambda x: "C[ModelicaByExample.ArrayEquations.ChemicalReactions.Reactions_Enum.Species."+str(x)+"]"
add_case(["Reactions_Enum$"], stopTime=10.0, res="RE")
add_simple_plot(plot="RE",
                vars=[
                    Var(species_name("A"), legend="C[A]"),
                    Var(species_name("B"), legend="C[B]"),
                    Var(species_name("X"), scale=50, legend="C[X]*50")
                ],
                title="Simulation of Chemical System using Enumerations",
                legloc="upper right")

add_case(["Reactions_EnumMatrix"], stopTime=10.0, res="REM")
add_simple_plot(plot="REM",
                vars=[
                    Var(species_name("A"), legend="C[A]"),
                    Var(species_name("B"), legend="C[B]"),
                    Var(species_name("X"), scale=50, legend="C[X]*50")
                ],
                title="Simulation of Chemical System using Enumerations",
                legloc="upper right")

# Polynomial evaluation
add_case(["EvaluationTest1"], stopTime=10.0, res="Eval1")
add_case(["Differentiation2"], stopTime=10.0, res="Diff2")
add_simple_plot(plot="Eval1",
                vars=[Var("yf"), Var("yp")],
                title="Polynomial Evaluation",
                legloc="lower right")
add_simple_plot(plot="Diff2", res="Diff2",
                vars=[Var("yf"), Var("yp"), Var("d_yf"), Var("d_yp")],
                title="Polynomial and Derivative Evaluation")

# Interpolation
add_case(["IntegrateInterpolatedVector"], stopTime=7.0, res="IIV")
add_simple_plot(plot="IIV", legloc="upper left",
                vars=[Var("y", legend="y - interpolated data"),
                      Var("z", legend="z - integral of y")],
                title="Integration of Interpolated Function")

add_case(["IntegrateInterpolatedExternalVector"], stopTime=7.0, res="IIEV")
add_simple_plot(plot="IIEV", legloc="upper left",
                vars=[Var("y", legend="y - interpolated data"),
                      Var("z", legend="z - integral of y")],
                title="Integration of Interpolated Function using External Data")

# SiL
add_case(["HysteresisEmbeddedControl"], stopTime=10.0, res="SIL")
add_simple_plot(plot="SIL", vars=[Var("T"), Var("Tbar")],
                title="Embedded Hysteresis Control")

# Nonlinear
add_case(["ExplicitEvaluation"], stopTime=10.0, res="NLEE")
add_simple_plot(plot="NLEE", vars=[Var("y")],
                title="Evaluation of a Quadratic Polynomial")

add_case(["ImplicitEvaluation"], stopTime=239.0, res="NLIE")
add_simple_plot(plot="NLIE", vars=[Var("y")],
                title="Inversion of a Quadratic Polynomial")

# Heat transfer components
add_case(["Adiabatic"], stopTime=1.0, res="HTA");
add_simple_plot(plot="HTA", vars=[Var("cap.node.T")],
                title="Thermal capacitance with no heat transfer")

add_case(["CoolingToAmbient"], stopTime=1.0, res="HT_CTA");
add_simple_plot(plot="HT_CTA", vars=[Var("cap.node.T")],
                title="Thermal capacitance with convection")

add_case(["Examples.Cooling$"], stopTime=1.0, res="HT_C");
add_simple_plot(plot="HT_C", vars=[Var("cap.node.T")],
                title="Thermal capacitance with convection")

add_case(["ComplexNetwork"], stopTime=1.0, res="HT_CN");
add_simple_plot(plot="HT_CN", vars=[Var("cap1.node.T"), Var("cap2.node.T")],
                title="Thermal warmup of cap1 and cap2")

# Rotational components
smdvars = [Var("inertia1.phi", legend="Position of inertia 1 [rad]"),
           Var("inertia2.phi", legend="Position of inertia 2 [rad]"),
           Var("inertia1.w", legend="Velocity of inertia 1 [rad/s]"),
           Var("inertia2.w", legend="Velocity of inertia 2 [rad/s]")]
add_case(["Rotational\.Examples", "SMD$"], stopTime=5, res="SMD");
add_simple_plot(plot="SMD", vars=smdvars,
                title="Dual mass spring-mass-damper model");
add_case(["Rotational\.Examples", "SMD_WithBacklash"], stopTime=5, res="SMD_WB");
add_simple_plot(plot="SMD_WB", vars=smdvars,
                title="Spring-mass-damper model including backlash");
add_simple_plot(plot="SMD_WB_RT", vars=[Var("ground.flange_a.tau")], res="SMD_WB",
                title="Reaction torque at mechanical ground");
add_case(["Rotational\.Examples", "SMD_WithGroundedGear"], stopTime=5, res="SMD_GG");
add_simple_plot(plot="SMD_GG", vars=[Var("inertia3.phi", legend="Position of inertia 3 [rad]"),
                                     Var("inertia2.phi", legend="Position of inertia 2 [rad]"),
                                     Var("inertia3.w", legend="Velocity of inertia 3 [rad/s]"),
                                     Var("inertia2.w", legend="Velocity of inertia 2 [rad/s]")],
                title="Dual mass spring-mass-damper model");
add_case(["Rotational.\Examples", "SMD_GearComparison"], stopTime=2, res="SMD_GC");
add_simple_plot(plot="SMD_GC_g", res="SMD_GC",
                vars=[Var("inertia3.phi", legend="Position of inertia 3 [rad]"),
                      Var("inertia1.phi", legend="Position of inertia 1 [rad]"),
                      Var("inertia3.w", legend="Velocity of inertia 3 [rad/s]"),
                      Var("inertia1.w", legend="Velocity of inertia 1 [rad/s]")],
                title="Comparing explicitly and implicitly grounded gears");

add_simple_plot(plot="SMD_GC_u", res="SMD_GC",
                vars=[Var("inertia1.phi", legend="Position of inertia 1 [rad]"),
                      Var("inertia5.phi", legend="Position of inertia 5 [rad]"),
                      Var("inertia1.w", legend="Velocity of inertia 1 [rad/s]"),
                      Var("inertia5.w", legend="Velocity of inertia 5 [rad/s]")],
                title="Comparing grounded and ungrounded gears");
add_case(["Rotational.\Examples", "SMD_ConfigurableGear"], stopTime=5, res="SMD_CG");
add_simple_plot(plot="SMD_CG", vars=[Var("inertia4.phi", legend="Position of inertia 4 [rad]"),
                                     Var("inertia1.phi", legend="Position of inertia 1 [rad]"),
                                     Var("inertia4.w", legend="Velocity of inertia 4 [rad/s]"),
                                     Var("inertia1.w", legend="Velocity of inertia 1 [rad/s]")],
                title="Implicitly and explicitly grounded ConfigurableGear");

# Lotka-Volterra (components)
add_case(["ClassicLotkaVolterra"], stopTime=140, res="CLV");
add_simple_plot(plot="CLV", vars=[Var("rabbits.population", legend="Rabbit Population"),
                                  Var("foxes.population", legend="Fox Population")],
                title="Component-Oriented Lotka-Volterra");
add_case(["ThirdSpecies"], stopTime=140, res="ThirdS", tol=1e-3);
add_simple_plot(plot="ThirdS", vars=[Var("rabbits.population", legend="Rabbit Population"),
                                     Var("foxes.population", legend="Fox Population"),
                                     Var("wolves.population", legend="Wolf Population")],
                title="Interactions between rabbits, foxes and wolves");
add_case(["ThreeSpecies"], stopTime=140, res="ThreeS", tol=1e-3);
add_simple_plot(plot="ThreeS", vars=[Var("rabbits.population", legend="Rabbit Population"),
                                     Var("foxes.population", legend="Fox Population"),
                                     Var("wolves.population", legend="Wolf Population")],
                title="Equilibriums for rabbits, foxes and wolves");

# Speed measurement
add_case(["SpeedMeasurement", "Plant$"], stopTime=5, res="PBase", tol=1e-6);
add_simple_plot(plot="PBase", vars=[Var("inertia1.w", legend="Actual speed")],
                title="Baseline plant response");
add_case(["PlantWithSampleHold"], stopTime=5, res="PwSH", tol=1e-6);
add_simple_plot(plot="PwSH", vars=[Var("inertia1.w", legend="Actual speed (inertia1.w)"),
                                   Var("sampleHold.w", legend="Measured speed (sampleHold.w)")],
                title="Comparison of actual speed with sampled speed");
add_case(["PlantWithIntervalMeasure"], stopTime=5, res="PwIM", tol=1e-6);
add_simple_plot(plot="PwIM", vars=[Var("inertia1.w",
                                       legend="Actual speed (inertia1.w)"),
                                   Var("intervalMeasure.w",
                                       legend="Measured speed (intervalMeasure.w)")],
                title="Comparison of actual speed with approximation by interval measurement");
add_simple_plot(plot="PwIM_gaps", res="PwIM",
                vars=[Var("inertia1.phi", legend="Inertia position (inertia1.phi)"),
                      Var("intervalMeasure.next_phi", legend="Next forward angle"),
                      Var("intervalMeasure.prev_phi", legend="Next backward angle")],
                title="Comparison of actual speed with approximation by interval measurement");
add_case(["PlantWithIntervalMeasure"], stopTime=5, res="PwIMf", tol=1e-6,
         mods={"intervalMeasure.teeth": 20});
add_simple_plot(plot="PwIMf", vars=[Var("inertia1.w", legend="Actual speed (inertia1.w)"),
                                    Var("intervalMeasure.w",
                                        legend="Measured speed (intervalMeasure.w)")],
                title="Comparison of actual speed with approximation by interval measurement");
add_simple_plot(plot="PwIMf_gaps", res="PwIMf",
                vars=[Var("inertia1.phi", legend="Inertia position (intertia1.phi)"),
                      Var("intervalMeasure.next_phi", legend="Next forward angle"),
                      Var("intervalMeasure.prev_phi", legend="Next backward angle")],
                title="Comparison of actual speed with approximation by interval measurement");
add_case(["PlantWithPulseCounter"], stopTime=5, res="PwPC", tol=1e-3);
add_simple_plot(plot="PwPC", vars=[Var("inertia1.w", legend="Actual speed (inertia.w)"),
                                   Var("pulseCounter.w",
                                       legend="Measured speed (pulseCounter.w)")],
                title="Comparison of actual speed with approximation by pulse counting");

# Block diagrams
add_case(["BlockDiagrams", "NewtonCooling"], stopTime=1.0, res="BNC", tol=1e-3);
add_simple_plot(plot="BNC", vars=[Var("T.y", legend="Temperature (T.y)")],
                title="Temperature solution");
add_case(["BlockDiagrams", "MultiDomainControl"], stopTime=0.35, res="MDC", tol=1e-3);
add_simple_plot(plot="MDC", vars=[Var("sensor.y", legend="Temperature (sensor.y)")],
                title="Closed loop temperature response");
add_case(["BlockDiagrams", "MultiDomainControl"], stopTime=0.35, res="MDC_hg",
         mods={"k": 10.0}, tol=1e-3);
add_simple_plot(plot="MDC_hg", vars=[Var("sensor.y", legend="Temperature (sensor.y)")],
                title="Closed loop temperature response with high gain");

add_compare_plot(plot="MDC_heat", legloc="upper right",
                 res1="MDC", v1=[Var("heatSource.node.Q_flow",
                                     legend="Heat (low-gain scenario)")],
                 res2="MDC_hg", v2=[Var("heatSource.node.Q_flow",
                                        legend="Heat (high-gain scenario)")],
                 title="Comparison of required actuator heat output")

# Chemical components
abxvars = [Var("solution.C[ModelicaByExample.Components.ChemicalReactions.ABX.Species.X]",
               legend="X")]
#add_case(["ABX_System"], stopTime=10.0, res="ABX", tol=1e-3);
#add_simple_plot(plot="ABX",
#                vars=abxvars,
#                title="Concentrations of A, B and X");

# Subsystem models
add_case(["FlatSystemWithBacklash"], stopTime=2.0, res="FSWB", tol=1e-3);
add_case(["FlatSystemWithBacklash"], stopTime=2.0, res="FSWB_nolash", tol=1e-3,
         mods={"backlash.b": 0});

fswb_vars = [Var("inertia_a.w"), Var("inertia_b.w")]
add_compare_plot(plot="FSWB_comp", legloc="upper right",
                 res1="FSWB",
                 v1=[Var("inertia_a.w", legend="inertia_a.w (with lash)", style="-"),
                     Var("inertia_b.w", legend="inertia_b.w (with lash)", style="-")],
                 res2="FSWB_nolash",
                 v2=[Var("inertia_a.w", legend="inertia_a.w (without lash)", style="-"),
                     Var("inertia_b.w", legend="inertia_b.w (without lash)", style="-")],
                 title="Gear response, with and without backlash")

add_simple_plot(plot="FSWB", vars=fswb_vars,
                title="System schematic of gear system with backlash")

swb_vars = [Var("gearWithBacklash.inertia_a.w"),
            Var("gearWithBacklash.inertia_b.w")]
add_case(["BacklashExample"], stopTime=2.0, res="SWB", tol=1e-3);
add_simple_plot(plot="SWB", vars=swb_vars,
                title="Response of hierarchical gear system with backlash")

# Lotka-Volterra (migration)
regvars = [Var("A.rabbits.population", legend="Rabbits in A"),
           Var("B.rabbits.population", legend="Rabbits in B"),
           Var("C.rabbits.population", legend="Rabbits in C"),
           Var("D.rabbits.population", legend="Rabbits in D"),
           Var("A.foxes.population", legend="Foxes in A"),
           Var("B.foxes.population", legend="Foxes in B"),
           Var("C.foxes.population", legend="Foxes in C"),
           Var("D.foxes.population", legend="Foxes in D")]
add_case(["UnconnectedPopulations"], stopTime=160.0, res="Uncon", tol=1e-3);
add_simple_plot(plot="Uncon", vars=regvars, ncols=2, ymax=60,
                title="Comparison of regional populations")

add_case(["InitiallyDifferent"], stopTime=160.0, res="ID", tol=1e-3);
add_simple_plot(plot="ID", vars=regvars, ncols=2, ymax=85,
                title="Effect of different initial populations")

add_case(["WithMigration"], stopTime=240.0, res="WM", tol=1e-3);
add_simple_plot(plot="WM", vars=regvars, ncols=2, ymax=60,
                title="Effect of migration on regional populations")

# Power supply
add_case(["FlatCircuit"], stopTime=1.0, res="FC", tol=1e-6);
add_simple_plot(plot="FC", vars=[Var("load.v")], legloc="lower right",
                title="Flat power supply circuit");

sscvars = [Var("load.v")]
add_case(["SubsystemCircuit"], stopTime=1.0, res="SSC", tol=1e-6);
add_simple_plot(plot="SSC", vars=sscvars, legloc="lower right",
                title="System with power supply component")

add_case(["AdditionalLoad"], stopTime=1.0, res="SSC_AL", tol=1e-6);
add_simple_plot(plot="SSC_AL", vars=sscvars, legloc="lower right",
                title="Power supply component with additional load")

add_case(["AdditionalLoad"], stopTime=1.0, res="SSC_ALC", tol=1e-6,
         mods={"power_supply.C": 1e-1});
add_simple_plot(plot="SSC_ALC", vars=sscvars, legloc="lower right",
                title="Power supply component with additional load")

add_case(["AdditionalLoad"], stopTime=1.0, res="SSC_ALC2", tol=1e-6,
         mods={"power_supply.C": 100});
add_simple_plot(plot="SSC_ALC2", vars=sscvars, legloc="lower right",
                title="Effect of very large capacitance")

# Rod models
add_case(["FlatRod"], stopTime=1.5, res="FR", tol=1e-3)
add_simple_plot(plot="FR", vars=[Var("sensor.T")], title="Sensor measurement")

add_case(["SegmentComparison"], stopTime=1.5, res="SegC", tol=1e-3)
add_simple_plot(plot="SegC",
                vars=[Var("rod3.sensor.T", legend="sensor.T, n=3"),
                      Var("rod6.sensor.T", legend="sensor.T, n=6"),
                      Var("rod10.sensor.T", legend="sensor.T, n=10"),
                      Var("rod100.sensor.T", legend="sensor.T, n=100"),
                      Var("rod200.sensor.T", legend="sensor.T, n=200")],
                title="Comparison of segmentation")

# Pendulum
#add_case(["Pendula", "System"], stopTime=108, res="Harm", tol=1e-6)
#add_simple_plot(plot="Harm",
#                vars=[Var("pendulum[1].revolute.phi"),
#                      Var("pendulum[1].revolute.phi")],
#                title="Pendulum angles")

# Sensor comparison
scvars = [Var("inertia1.w", legend="Shaft speed"),
          Var("speedSensor.w", legend="Measured speed"),
          Var("feedback.u1", legend="Desired speed")]
add_case(["SensorComparison", "FlatSystem$"], stopTime=5, res="AFS", tol=1e-3)
add_simple_plot(plot="AFS", vars=scvars, title="Response using ideal sensor")

add_case(["SensorComparison", "FlatSystem_"], stopTime=5, res="AFS_SH", tol=1e-3)
add_simple_plot(plot="AFS_SH", vars=scvars, title="Response using a sample and hold sensor")

ascvars = [Var("plant.inertia1.w", legend="Shaft speed"),
           Var("sensor.w", legend="Measured speed"),
           Var("controller.setpoint", legend="Desired speed")]

add_case(["SensorComparison", "[^_]Variant1$"], stopTime=5, res="SV1", tol=1e-6)
add_simple_plot(plot="SV1", vars=ascvars, title="Response with hold time of 0.01")

add_case(["SensorComparison", "Variant1_"], stopTime=5, res="SV1U", tol=1e-6)
add_simple_plot(plot="SV1U", vars=ascvars, title="Response with hold time of 0.036")

add_case(["SensorComparison", "[^_]Variant2$"], stopTime=5, res="SV2", tol=1e-6)
add_simple_plot(plot="SV2", vars=ascvars, title="Response using PID control")

add_case(["SensorComparison", "Variant2_"], stopTime=5, res="SV2T", tol=1e-6)
add_simple_plot(plot="SV2T", vars=ascvars, title="Response using a tuned PID controller")

# Thermal Control

tcbvars = [Var("sensor.room.T", legend="Room Temperature"),
           Var("sensor.temperature", legend="Measured Temperature"),
           Var("controller.feedback.u2", legend="Desired Temperature")]

tcevars = [Var("sensor.room.T", legend="Room Temperature (sensor.room.T)"),
           Var("controller.bus.temperature", legend="Measured Temperature (controller.bus.temp)"),
           Var("controller.feedback.u2", legend="Desired Temperature")]

add_case(["ThermalControl", "BaseModel"], stopTime=50, res="TCB", tol=1e-3)
add_simple_plot(plot="TCB", vars=tcbvars, legloc="lower right",
                title="Response using PI controller")
add_simple_plot(plot="TCBh", res="TCB", vars=[Var("plant.furnace.Q_flow")],
                title="Furnace heat using PI controller")

add_case(["ThermalControl", "ExpandableModel"], stopTime=50, res="TCE", tol=1e-3)
add_simple_plot(plot="TCE", vars=tcevars, legloc="lower right",
                title="Response using PI controller in expandable architecture")

tcebbvars = [Var("sensor.room.T", legend="Room Temperature (sensor.room.T)"),
           Var("controller.bus.temperature", legend="Measured Temperature (controller.bus.temp)"),
           Var("controller.setpoint_signal.y", legend="Desired Temperature")]

add_case(["ThermalControl", "OnOffVariant"], stopTime=50, res="TCE_BB", tol=1e-3)
add_simple_plot(plot="TCE_BB", vars=tcebbvars, legloc="lower right",
                title="Response using PI bang-bang control")

add_simple_plot(plot="TCE_BBh", res="TCE_BB", vars=[Var("controller.bus.heat_command")],
                legloc="lower right",
                title="Actuator duty cycle using bang-bang control")

add_case(["ThermalControl", "HysteresisVariant"], stopTime=50, res="TCE_Hy", tol=1e-3)
add_simple_plot(plot="TCE_Hy", vars=tcebbvars, legloc="lower right",
                title="Response using PI bang-bang control with hysteresis")

add_simple_plot(plot="TCE_Hyh", res="TCE_Hy", vars=[Var("controller.bus.heat_command")],
                legloc="lower right",
                title="Actuator duty cycle using bang-bang control with hysteresis")

generate()
