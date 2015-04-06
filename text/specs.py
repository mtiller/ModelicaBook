import os
import sys

sys.path.append(os.path.join(".", "source", "_sphinxext"))

import gettext
try:
    language = os.environ['BOOK_LANG']
    t = gettext.translation('specs', os.path.abspath('./locale'), [language])
    _ = t.ugettext
except Exception as err:
    _ = lambda x: x

from xogeny.gen_utils import *

## Simple Examples
fovars = [Var("x", legend=_("x"))]
add_case(["SimpleExample", "FirstOrder$"], res="FO", stopTime=10);
add_simple_plot(plot="FO", vars=fovars, title=_("Simulation of FirstOrder"))

focvars = [Var("x", legend=_("x (FirstOrder)"))]
foivars = [Var("x", legend=_("x (FirstOrderInitial)"))]
add_case(["SimpleExample", "FirstOrderInitial"], stopTime=10, res="FOI")
add_compare_plot(plot="FOI",
                 res1="FOI", v1=foivars,
                 res2="FO", v2=focvars,
                 title=_("Specifying (non-zero) Initial Conditions"))

add_case(["SimpleExample", "FirstOrderExperiment"], res="FOE")
add_simple_plot(plot="FOE", vars=fovars, title=_("Simulation Using Experiment Annotation"))

fosvars = [Var("x", legend=_("x (FirstOrderSteady)"))]
add_case(["SimpleExample", "FirstOrderSteady"], stopTime=10, res="FOS")
add_compare_plot(plot="FOS",
                 res1="FOS", v1=fosvars,
                 res2="FO", v2=focvars,
                 title=_("Steady State Solution (vs. Dynamic Response)"))

## Cooling Example
add_case(["NewtonCoolingWithDefaults"], stopTime=1, res="NCWD")
add_simple_plot(plot="NCWD", vars=[Var("T")], title=_("Cooling to Ambient"),
                legloc="upper right", ylabel=_("Temperature"))

## RLC
add_case(["RLC1"], stopTime=2, res="RLC1")
add_simple_plot(plot="RLC1", vars=[Var("V", legend=_("Output Voltage (V)"), style="-"),
                                   Var("Vb", legend=_("Battery Voltage (Vb)"), style="-.")],
                ylabel=_("Voltage [V]"),
                title=_("Circuit Response"))

## RotationalSMD
sosvars = [Var("phi1", legend=_("Position of inertia 1 [rad]")),
           Var("phi2", legend=_("Position of inertia 2 [rad]")),
           Var("omega1", legend=_("Velocity of inertia 1 [rad/s]")),
           Var("omega2", legend=_("Velocity of inertia 2 [rad/s]"))]
add_case(["SecondOrderSystemInitParams"], stopTime=5, res="SOSIP")
add_simple_plot(plot="SOSIP", vars=sosvars, title=_("Mechanical System Response"))

add_case(["SecondOrderSystemInitParams"], stopTime=5, res="SOSIP1",
         mods={_("phi1_init"): 1.0})
add_simple_plot(plot="SOSIP1", vars=sosvars, title=_("Mechanical Response specifying phi1(0)"))

## LotkaVolterra
lvvars = [Var("x", legend=_("Prey population")),
          Var("y", legend=_("Predator population"))]

add_case(["ClassicModel$"], stopTime=140, res="LVCM")
add_simple_plot(plot="LVCM", vars=lvvars, title=_("Classic Lotka-Volterra"))

add_case(["QuiescentModel$"], stopTime=140, res="LVQM")
add_simple_plot(plot="LVQM", vars=lvvars, title=_("Quiescent Model (trivial solution)"))

add_case(["QuiescentModelUsingStart"], stopTime=140, res="LVQMUS")
add_simple_plot(plot="LVQMUS", vars=lvvars, ymax=25,
                title=_("Quiescent Model (using start values)"))

## Cooling Revisited
ncdvars = [Var("T", legend=_("Temperature")),
           Var("T_inf", legend=_("Ambient Temperature"))]
add_case(["NewtonCoolingDynamic"], stopTime=1, res="NCD")
add_simple_plot(plot="NCD", vars=ncdvars,
                title=_("Cooling to Time-Varying Ambient"),
                legloc="upper right", ylabel=_("Temperature [K]"))

add_case(["NewtonCoolingSteadyThenDynamic"], stopTime=1, res="NCSTD")
add_simple_plot(_("NCSTD"), vars=ncdvars,
                title=_("Equilibrium Initialization"),
                legloc="lower left", ylabel=_("Temperature [K]"))

## Bouncing Ball
bbvars = [Var("h", legend=_("Height"))]
add_case(["\.BouncingBall$"], stopTime=3, res="BB1")
add_simple_plot(plot="BB1", vars=bbvars,
                title=_("Simple Bouncing Ball Model"),
                legloc="upper right", ylabel=_("Height [m]"))
add_case(["\.BouncingBall$"], stopTime=5, res="BB2")
add_simple_plot(plot="BB2", vars=bbvars,
                title=_("Consequences of Numerical Event Detection"),
                legloc="upper right", ylabel=_("Height [m]"))
add_case(["Decay1$"], stopTime=5, res="Decay1", simfails=True)
add_simple_plot(plot="Decay1", vars=[Var("x")],
                title=_("Decay with Numerical Noise"),
                legloc="upper right")
add_case(["Decay2$"], stopTime=5, res="Decay2", tol=1e-1, simfails=True)
add_simple_plot(plot="Decay2", vars=[Var("x")],
                title=_("Decay with Guard Condition"),
                legloc="upper right")
add_case(["Decay3$"], stopTime=5, res="Decay3", tol=1e-6)
add_simple_plot(plot="Decay3", vars=[Var("x")],
                title=_("Decay without Issue"),
                legloc="upper right")
add_case(["WithChatter$"], stopTime=2, res="WC", tol=1e-1)
add_simple_plot(plot="WC", vars=[Var("x"), Var("$cpuTime", legend=_("CPU Time"))],
                title=_("Chattering"), ymin=-1,
                legloc="upper right")
add_case(["WithoutChatter$"], stopTime=2, res="WOC", tol=1e-1)
add_simple_plot(plot="WOC", vars=[Var("x"), Var("$cpuTime", legend=_("CPU Time"))],
                title=_("No Chattering"), ymin=-1,
                legloc="upper right")

## Accuracy
avs = [Var("x", legend=_("Integrated value")),
       Var("y", legend=_("Reference value"))]
#       Var("active", legend=_("Activation flag"))]
add_case(["WithEvents$"], stopTime=7.0, res="WE", tol=1e-1)
add_case(["WithEvents$"], stopTime=7.0, res="WEf", tol=1e-1, mods={"freq": 5.0})
add_case(["WithNoEvents$"], stopTime=7.0, res="WNE", tol=1e-1)
add_case(["WithNoEvents$"], stopTime=7.0, res="WNEf", tol=1e-1, mods={"freq": 5.0})

add_simple_plot(plot="WE", vars=avs, title=_("Integration with Events"),
                legloc="upper right")

add_simple_plot(plot="WEf", vars=avs, title=_("Integration with Events (Higher Frequency)"),
                legloc="upper right")

add_simple_plot(plot="WNE", vars=avs, title=_("Integration without Events"),
                legloc="upper right")

add_simple_plot(plot="WNEf", vars=avs, title=_("Integration without Events (Higher Frequency)"),
                legloc="upper right")

## Switched RLC
srlc_vvars = [Var("Vs", legend=_("Source Voltage, Vs [V]")),
              Var("V", legend=_("Response Voltage, V [V]"))]
srlc_ivars = [Var("i_R", legend=_("Resistor Current [A]")),
              Var("i_C", legend=_("Capacitor Current [A]")),
              Var("i_L", legend=_("Inductor Current [A]"))]
add_case(["SwitchedRLC\.SwitchedRLC"], stopTime=2, res="SRLC")
add_simple_plot(plot="SRLCv", res="SRLC", vars=srlc_vvars,
                title=_("Switched RLC Voltage Response"),
                legloc="lower right")
add_simple_plot(plot="SRLCi", res="SRLC", vars=srlc_ivars,
                title=_("Switched RLC Current Response"),
                legloc="lower right")

# Speed Measurement
mvars = [Var("omega1"), Var("omega1_measured")]
add_case(["SampleAndHold"], stopTime=5, res="SampleAndHold", tol=1e-3)
add_simple_plot(plot="SampleAndHold", vars=mvars,
                title=_("Sample and Hold Speed Measurement"),
                legloc="upper right")

add_case(["DiscreteBehavior", "IntervalMeasure"], stopTime=5, res="IntervalMeasure", tol=1e-3)
add_simple_plot(plot="IntervalMeasure", vars=mvars,
                title=_("Speed Estimation by Interval Measurement"),
                legloc="upper right")

add_case(["DiscreteBehavior", "IntervalMeasure"], stopTime=5,
         res="IntervalMeasure_Coarse", tol=1e-3, mods={_("teeth"): 20})
add_simple_plot(plot="IntervalMeasure_Coarse", vars=mvars,
                title=_("Speed Estimation Using Fewer Teeth"),
                legloc="upper right")
add_simple_plot(plot="IntervalMeasure_Coarse_phi", res="IntervalMeasure_Coarse",
                vars=[Var("phi1"), Var("next_phi"), Var("prev_phi")],
                title=_("Angle vs. Teeth Angles"),
                legloc="upper right")

add_case(["CounterWithAlgorithm"], stopTime=5,
         res="SpeedCounter", tol=1e-3)
add_simple_plot(plot="SpeedCounter", vars=mvars,
                title=_("Speed Estimation by Counting"),
                legloc="upper right")
add_simple_plot(plot="SpeedCounter_count", vars=[Var("count")], res="SpeedCounter",
                title=_("Speed Estimation by Counting"),
                legloc="upper right")

# Hysteresis
add_case(["ChatteringControl"], stopTime=0.5,
         res="CC1", tol=1e-1)
add_simple_plot(plot="CC1", vars=[Var("T")],
                title=_("Temperature Control with Chattering"),
                legloc="upper right")
add_simple_plot(plot="CC1_Q", vars=[Var("Q")], res="CC1",
                title=_("Heater Output"),
                legloc="upper right")
add_case(["HysteresisControl$"], stopTime=5,
         res="Hyst", tol=1e-3)
add_simple_plot(plot="Hyst", vars=[Var("T")],
                title=_("Temperature Control with Hysteresis"),
                legloc="upper right")
add_simple_plot(plot="Hyst_Q", vars=[Var("Q")], res="Hyst",
                title=_("Heater Output with Hysteresis"),
                legloc="upper right")
add_case(["HysteresisControlWithAlgorithm"], stopTime=5,
         res="HystA", tol=1e-3)
add_simple_plot(plot="HystA", vars=[Var("T")],
                title=_("Temperature Control with Hysteresis"),
                legloc="upper right")
add_simple_plot(plot="HystA_Q", vars=[Var("Q")], res="HystA",
                title=_("Heater Output with Hysteresis"),
                legloc="upper right")

# Synchronous Systems
add_case(["IndependentSampling"], stopTime=1.0, res="SIS", tol=1e-1)
add_simple_plot(plot="SIS", vars=[Var("x"), Var("y")], res="SIS",
                title=_("Independently Sampled Signals"),
                legloc="upper right")
add_simple_plot(plot="SIS_e", vars=[Var("e")], res="SIS",
                title=_("Error of Independently Sampled Signals"),
                legloc="upper right")

add_case(["SynchronizedSampling"], stopTime=1.0, res="SSS", tol=1e-1)
add_simple_plot(plot="SSS", vars=[Var("e")],
                title=_("Synchronously Sampled Signals"),
                legloc="upper right")

add_case(["SubsamplingWithIntegers"], stopTime=1.0, res="SSI", tol=1e-3)
add_simple_plot(plot="SSI", vars=[Var("x"), Var("y"), Var("z")],
                title=_("Synchronized Sampling and Subsampling"),
                legloc="upper right")

# ABCD
add_case(["StateSpace", "FirstOrder$"], stopTime=1.0, res="FO_LTI", tol=1e-3)
add_simple_plot(plot="FO_LTI", vars=[Var("x[1]")],
                title=_("First Order Example in LTI Form"),
                legloc="upper right")

add_case(["StateSpace", "NewtonCooling"], stopTime=1.0, res="NC_LTI", tol=1e-3)
add_simple_plot(plot="NC_LTI", vars=[Var("x[1]")],
                title=_("Cooling Example in LTI Form"),
                legloc="upper right")

add_case(["StateSpace", "RLC"], stopTime=1.0, res="RLC_LTI", tol=1e-3)
add_simple_plot(plot="RLC_LTI", vars=[Var("x[1]", _("x[2]"))],
                title=_("RLC Circuit Example in LTI Form"),
                legloc="upper right")

add_case(["StateSpace", "RotationalSMD$"], stopTime=1.0, res="Ro_LTI", tol=1e-3)
add_simple_plot(plot="Ro_LTI", vars=[Var("x[1]", _("x[2]"))],
                title=_("Rotational Example in LTI Form"),
                legloc="upper right")

add_case(["StateSpace", "RotationalSMD_Concat"], stopTime=1.0, res="RoC_LTI", tol=1e-3)
add_simple_plot(plot="RoC_LTI", vars=[Var("x[1]", _("x[2]"))],
                title=_("Rotational Example in LTI Form"),
                legloc="upper right")

add_case(["StateSpace", "LotkaVolterra"], stopTime=1.0, res="LV_ABCD", tol=1e-3)
add_simple_plot(plot="LV_ABCD", vars=[Var("x[1]", _("x[2]"))],
                title=_("Lotka-Volterra Example in LTI Form"),
                legloc="upper right")

# One Dimensional Heat Transfer
rfl_vars = map(lambda x: Var("T["+str(x)+_("]")), range(1,11))
add_case(["Rod_ForLoop"], stopTime=1.0, res="RFL", tol=1e-3)
add_simple_plot(plot="RFL", vars=rfl_vars,
                title=_("One Dimensional Heat Transfer Response"),
                legloc="upper right")

add_case(["Reactions_NoArrays"], stopTime=10.0, res="RNA")
add_simple_plot(plot="RNA", vars=[Var("cA"), Var("cB"), Var("cX", scale=50.0, legend=_("cX*50"))],
                title=_("Simulation of Chemical System without Arrays"),
                legloc="upper right")

add_case(["Reactions_Array"], stopTime=10.0, res="RA")
add_simple_plot(plot="RA", vars=[Var("C[1]"), Var("C[2]"), Var("C[3]")],
                title=_("Simulation of Chemical System with Arrays"),
                legloc="upper right")

species_name = lambda x: _("C[ModelicaByExample.ArrayEquations.ChemicalReactions.Reactions_Enum.Species.")+str(x)+_("]")
add_case(["Reactions_Enum$"], stopTime=10.0, res="RE")
add_simple_plot(plot="RE",
                vars=[
                    Var(species_name(_("A")), legend=_("C[A]")),
                    Var(species_name(_("B")), legend=_("C[B]")),
                    Var(species_name(_("X")), scale=50, legend=_("C[X]*50"))
                ],
                title=_("Simulation of Chemical System using Enumerations"),
                legloc="upper right")

add_case(["Reactions_EnumMatrix"], stopTime=10.0, res="REM")
add_simple_plot(plot="REM",
                vars=[
                    Var(species_name(_("A")), legend=_("C[A]")),
                    Var(species_name(_("B")), legend=_("C[B]")),
                    Var(species_name(_("X")), scale=50, legend=_("C[X]*50"))
                ],
                title=_("Simulation of Chemical System using Enumerations"),
                legloc="upper right")

# Polynomial evaluation
add_case(["EvaluationTest1"], stopTime=10.0, res="Eval1")
add_case(["Differentiation2"], stopTime=10.0, res="Diff2")
add_simple_plot(plot="Eval1",
                vars=[Var("yf"), Var("yp")],
                title=_("Polynomial Evaluation"),
                legloc="lower right")
add_simple_plot(plot="Diff2", res="Diff2",
                vars=[Var("yf"), Var("yp"), Var("d_yf"), Var("d_yp")],
                title=_("Polynomial and Derivative Evaluation"))

# Interpolation
add_case(["IntegrateInterpolatedVector"], stopTime=7.0, res="IIV")
add_simple_plot(plot="IIV", legloc="upper left",
                vars=[Var("y", legend=_("y - interpolated data")),
                      Var("z", legend=_("z - integral of y"))],
                title=_("Integration of Interpolated Function"))

add_case(["IntegrateInterpolatedExternalVector"], stopTime=7.0, res="IIEV")
add_simple_plot(plot="IIEV", legloc="upper left",
                vars=[Var("y", legend=_("y - interpolated data")),
                      Var("z", legend=_("z - integral of y"))],
                title=_("Integration of Interpolated Function using External Data"))

# SiL
add_case(["HysteresisEmbeddedControl"], stopTime=10.0, res="SIL")
add_simple_plot(plot="SIL", vars=[Var("T"), Var("Tbar")],
                title=_("Embedded Hysteresis Control"))

# Nonlinear
add_case(["ExplicitEvaluation"], stopTime=10.0, res="NLEE")
add_simple_plot(plot="NLEE", vars=[Var("y")],
                title=_("Evaluation of a Quadratic Polynomial"))

add_case(["ImplicitEvaluation"], stopTime=239.0, res="NLIE")
add_simple_plot(plot="NLIE", vars=[Var("y")],
                title=_("Inversion of a Quadratic Polynomial"))

# Heat transfer components
add_case(["Adiabatic"], stopTime=1.0, res="HTA");
add_simple_plot(plot="HTA", vars=[Var("cap.node.T")],
                title=_("Thermal capacitance with no heat transfer"))

add_case(["CoolingToAmbient"], stopTime=1.0, res="HT_CTA");
add_simple_plot(plot="HT_CTA", vars=[Var("cap.node.T")],
                title=_("Thermal capacitance with convection"))

add_case(["Examples.Cooling$"], stopTime=1.0, res="HT_C");
add_simple_plot(plot="HT_C", vars=[Var("cap.node.T")],
                title=_("Thermal capacitance with convection"))

add_case(["ComplexNetwork"], stopTime=1.0, res="HT_CN");
add_simple_plot(plot="HT_CN", vars=[Var("cap1.node.T"), Var("cap2.node.T")],
                title=_("Thermal warmup of cap1 and cap2"))

# Rotational components
smdvars = [Var("inertia1.phi", legend=_("Position of inertia 1 [rad]")),
           Var("inertia2.phi", legend=_("Position of inertia 2 [rad]")),
           Var("inertia1.w", legend=_("Velocity of inertia 1 [rad/s]")),
           Var("inertia2.w", legend=_("Velocity of inertia 2 [rad/s]"))]
add_case(["Rotational\.Examples", "SMD$"], stopTime=5, res="SMD");
add_simple_plot(plot="SMD", vars=smdvars,
                title=_("Dual mass spring-mass-damper model"));
add_case(["Rotational\.Examples", "SMD_WithBacklash"], stopTime=5, res="SMD_WB");
add_simple_plot(plot="SMD_WB", vars=smdvars,
                title=_("Spring-mass-damper model including backlash"));
add_simple_plot(plot="SMD_WB_RT", vars=[Var("ground.flange_a.tau")], res="SMD_WB",
                title=_("Reaction torque at mechanical ground"));
add_case(["Rotational\.Examples", "SMD_WithGroundedGear"], stopTime=5, res="SMD_GG");
add_simple_plot(plot="SMD_GG", vars=[Var("inertia3.phi", legend=_("Position of inertia 3 [rad]")),
                                     Var("inertia2.phi", legend=_("Position of inertia 2 [rad]")),
                                     Var("inertia3.w", legend=_("Velocity of inertia 3 [rad/s]")),
                                     Var("inertia2.w", legend=_("Velocity of inertia 2 [rad/s]"))],
                title=_("Dual mass spring-mass-damper model"));
add_case(["Rotational.\Examples", "SMD_GearComparison"], stopTime=2, res="SMD_GC");
add_simple_plot(plot="SMD_GC_g", res="SMD_GC",
                vars=[Var("inertia3.phi", legend=_("Position of inertia 3 [rad]")),
                      Var("inertia1.phi", legend=_("Position of inertia 1 [rad]")),
                      Var("inertia3.w", legend=_("Velocity of inertia 3 [rad/s]")),
                      Var("inertia1.w", legend=_("Velocity of inertia 1 [rad/s]"))],
                title=_("Comparing explicitly and implicitly grounded gears"));

add_simple_plot(plot="SMD_GC_u", res="SMD_GC",
                vars=[Var("inertia1.phi", legend=_("Position of inertia 1 [rad]")),
                      Var("inertia5.phi", legend=_("Position of inertia 5 [rad]")),
                      Var("inertia1.w", legend=_("Velocity of inertia 1 [rad/s]")),
                      Var("inertia5.w", legend=_("Velocity of inertia 5 [rad/s]"))],
                title=_("Comparing grounded and ungrounded gears"));
add_case(["Rotational.\Examples", "SMD_ConfigurableGear"], stopTime=5, res="SMD_CG");
add_simple_plot(plot="SMD_CG", vars=[Var("inertia4.phi", legend=_("Position of inertia 4 [rad]")),
                                     Var("inertia1.phi", legend=_("Position of inertia 1 [rad]")),
                                     Var("inertia4.w", legend=_("Velocity of inertia 4 [rad/s]")),
                                     Var("inertia1.w", legend=_("Velocity of inertia 1 [rad/s]"))],
                title=_("Implicitly and explicitly grounded ConfigurableGear"));

# Lotka-Volterra (components)
add_case(["ClassicLotkaVolterra"], stopTime=140, res="CLV");
add_simple_plot(plot="CLV", vars=[Var("rabbits.population", legend=_("Rabbit Population")),
                                  Var("foxes.population", legend=_("Fox Population"))],
                title=_("Component-Oriented Lotka-Volterra"));
add_case(["ThirdSpecies"], stopTime=140, res="ThirdS", tol=1e-3);
add_simple_plot(plot="ThirdS", vars=[Var("rabbits.population", legend=_("Rabbit Population")),
                                     Var("foxes.population", legend=_("Fox Population")),
                                     Var("wolves.population", legend=_("Wolf Population"))],
                title=_("Interactions between rabbits, foxes and wolves"));
add_case(["ThreeSpecies"], stopTime=140, res="ThreeS", tol=1e-3);
add_simple_plot(plot="ThreeS", vars=[Var("rabbits.population", legend=_("Rabbit Population")),
                                     Var("foxes.population", legend=_("Fox Population")),
                                     Var("wolves.population", legend=_("Wolf Population"))],
                title=_("Equilibriums for rabbits, foxes and wolves"));

# Speed measurement
add_case(["SpeedMeasurement", "Plant$"], stopTime=5, res="PBase", tol=1e-6);
add_simple_plot(plot="PBase", vars=[Var("inertia1.w", legend=_("Actual speed"))],
                title=_("Baseline plant response"));
add_case(["PlantWithSampleHold"], stopTime=5, res="PwSH", tol=1e-6);
add_simple_plot(plot="PwSH", vars=[Var("inertia1.w", legend=_("Actual speed (inertia1.w)")),
                                   Var("sampleHold.w", legend=_("Measured speed (sampleHold.w)"))],
                title=_("Comparison of actual speed with sampled speed"));
add_case(["PlantWithIntervalMeasure"], stopTime=5, res="PwIM", tol=1e-6);
add_simple_plot(plot="PwIM", vars=[Var("inertia1.w",
                                       legend=_("Actual speed (inertia1.w)")),
                                   Var("intervalMeasure.w",
                                       legend=_("Measured speed (intervalMeasure.w)"))],
                title=_("Comparison of actual speed with approximation by interval measurement"));
add_simple_plot(plot="PwIM_gaps", res="PwIM",
                vars=[Var("inertia1.phi", legend=_("Inertia position (inertia1.phi)")),
                      Var("intervalMeasure.next_phi", legend=_("Next forward angle")),
                      Var("intervalMeasure.prev_phi", legend=_("Next backward angle"))],
                title=_("Comparison of actual speed with approximation by interval measurement"));
add_case(["PlantWithIntervalMeasure"], stopTime=5, res="PwIMf", tol=1e-6,
         mods={_("intervalMeasure.teeth"): 20});
add_simple_plot(plot="PwIMf", vars=[Var("inertia1.w", legend=_("Actual speed (inertia1.w)")),
                                    Var("intervalMeasure.w",
                                        legend=_("Measured speed (intervalMeasure.w)"))],
                title=_("Comparison of actual speed with approximation by interval measurement"));
add_simple_plot(plot="PwIMf_gaps", res="PwIMf",
                vars=[Var("inertia1.phi", legend=_("Inertia position (intertia1.phi)")),
                      Var("intervalMeasure.next_phi", legend=_("Next forward angle")),
                      Var("intervalMeasure.prev_phi", legend=_("Next backward angle"))],
                title=_("Comparison of actual speed with approximation by interval measurement"));
add_case(["PlantWithPulseCounter"], stopTime=5, res="PwPC", tol=1e-3);
add_simple_plot(plot="PwPC", vars=[Var("inertia1.w", legend=_("Actual speed (inertia.w)")),
                                   Var("pulseCounter.w",
                                       legend=_("Measured speed (pulseCounter.w)"))],
                title=_("Comparison of actual speed with approximation by pulse counting"));

# Block diagrams
add_case(["BlockDiagrams", "NewtonCooling"], stopTime=1.0, res="BNC", tol=1e-3);
add_simple_plot(plot="BNC", vars=[Var("T.y", legend=_("Temperature (T.y)"))],
                title=_("Temperature solution"));
add_case(["BlockDiagrams", "MultiDomainControl"], stopTime=0.35, res="MDC", tol=1e-3);
add_simple_plot(plot="MDC", vars=[Var("sensor.y", legend=_("Temperature (sensor.y)"))],
                title=_("Closed loop temperature response"));
add_case(["BlockDiagrams", "MultiDomainControl"], stopTime=0.35, res="MDC_hg",
         mods={_("k"): 10.0}, tol=1e-3);
add_simple_plot(plot="MDC_hg", vars=[Var("sensor.y", legend=_("Temperature (sensor.y)"))],
                title=_("Closed loop temperature response with high gain"));

add_compare_plot(plot="MDC_heat", legloc="upper right",
                 res1="MDC", v1=[Var("heatSource.node.Q_flow",
                                     legend=_("Heat (low-gain scenario)"))],
                 res2="MDC_hg", v2=[Var("heatSource.node.Q_flow",
                                        legend=_("Heat (high-gain scenario)"))],
                 title=_("Comparison of required actuator heat output"))

# Chemical components
abxvars = [Var("solution.C[ModelicaByExample.Components.ChemicalReactions.ABX.Species.X]",
               legend=_("X"))]
#add_case(["ABX_System"], stopTime=10.0, res="ABX", tol=1e-3);
#add_simple_plot(plot="ABX",
#                vars=abxvars,
#                title=_("Concentrations of A, B and X"));

# Subsystem models
add_case(["FlatSystemWithBacklash"], stopTime=2.0, res="FSWB", tol=1e-3);
add_case(["FlatSystemWithBacklash"], stopTime=2.0, res="FSWB_nolash", tol=1e-3,
         mods={_("backlash.b"): 0});

fswb_vars = [Var("inertia_a.w"), Var("inertia_b.w")]
add_compare_plot(plot="FSWB_comp", legloc="upper right",
                 res1="FSWB",
                 v1=[Var("inertia_a.w", legend=_("inertia_a.w (with lash)"), style="-"),
                     Var("inertia_b.w", legend=_("inertia_b.w (with lash)"), style="-")],
                 res2="FSWB_nolash",
                 v2=[Var("inertia_a.w", legend=_("inertia_a.w (without lash)"), style="-"),
                     Var("inertia_b.w", legend=_("inertia_b.w (without lash)"), style="-")],
                 title=_("Gear response, with and without backlash"))

add_simple_plot(plot="FSWB", vars=fswb_vars,
                title=_("System schematic of gear system with backlash"))

swb_vars = [Var("gearWithBacklash.inertia_a.w"),
            Var("gearWithBacklash.inertia_b.w")]
add_case(["BacklashExample"], stopTime=2.0, res="SWB", tol=1e-3);
add_simple_plot(plot="SWB", vars=swb_vars,
                title=_("Response of hierarchical gear system with backlash"))

# Lotka-Volterra (migration)
regvars = [Var("A.rabbits.population", legend=_("Rabbits in A")),
           Var("B.rabbits.population", legend=_("Rabbits in B")),
           Var("C.rabbits.population", legend=_("Rabbits in C")),
           Var("D.rabbits.population", legend=_("Rabbits in D")),
           Var("A.foxes.population", legend=_("Foxes in A")),
           Var("B.foxes.population", legend=_("Foxes in B")),
           Var("C.foxes.population", legend=_("Foxes in C")),
           Var("D.foxes.population", legend=_("Foxes in D"))]
add_case(["UnconnectedPopulations"], stopTime=160.0, res="Uncon", tol=1e-3);
add_simple_plot(plot="Uncon", vars=regvars, ncols=2, ymax=60,
                title=_("Comparison of regional populations"))

add_case(["InitiallyDifferent"], stopTime=160.0, res="ID", tol=1e-3);
add_simple_plot(plot="ID", vars=regvars, ncols=2, ymax=85,
                title=_("Effect of different initial populations"))

add_case(["WithMigration"], stopTime=240.0, res="WM", tol=1e-3);
add_simple_plot(plot="WM", vars=regvars, ncols=2, ymax=60,
                title=_("Effect of migration on regional populations"))

# Power supply
add_case(["FlatCircuit"], stopTime=1.0, res="FC", tol=1e-6);
add_simple_plot(plot="FC", vars=[Var("load.v")], legloc="lower right",
                title=_("Flat power supply circuit"));

sscvars = [Var("load.v")]
add_case(["SubsystemCircuit"], stopTime=1.0, res="SSC", tol=1e-6);
add_simple_plot(plot="SSC", vars=sscvars, legloc="lower right",
                title=_("System with power supply component"))

add_case(["AdditionalLoad"], stopTime=1.0, res="SSC_AL", tol=1e-6);
add_simple_plot(plot="SSC_AL", vars=sscvars, legloc="lower right",
                title=_("Power supply component with additional load"))

add_case(["AdditionalLoad"], stopTime=1.0, res="SSC_ALC", tol=1e-6,
         mods={_("power_supply.C"): 1e-1});
add_simple_plot(plot="SSC_ALC", vars=sscvars, legloc="lower right",
                title=_("Power supply component with additional load"))

add_case(["AdditionalLoad"], stopTime=1.0, res="SSC_ALC2", tol=1e-6,
         mods={_("power_supply.C"): 100});
add_simple_plot(plot="SSC_ALC2", vars=sscvars, legloc="lower right",
                title=_("Effect of very large capacitance"))

# Rod models
add_case(["FlatRod"], stopTime=1.5, res="FR", tol=1e-3)
add_simple_plot(plot="FR", vars=[Var("sensor.T")], title=_("Sensor measurement"))

add_case(["SegmentComparison"], stopTime=1.5, res="SegC", tol=1e-3)
add_simple_plot(plot="SegC",
                vars=[Var("rod3.sensor.T", legend=_("sensor.T, n=3")),
                      Var("rod6.sensor.T", legend=_("sensor.T, n=6")),
                      Var("rod10.sensor.T", legend=_("sensor.T, n=10")),
                      Var("rod100.sensor.T", legend=_("sensor.T, n=100")),
                      Var("rod200.sensor.T", legend=_("sensor.T, n=200"))],
                title=_("Comparison of segmentation"))

# Pendulum
#add_case([_("Pendula"), _("System")], stopTime=108, res="Harm", tol=1e-6)
#add_simple_plot(plot="Harm",
#                vars=[Var("pendulum[1].revolute.phi"),
#                      Var("pendulum[1].revolute.phi")],
#                title=_("Pendulum angles"))

# Sensor comparison
scvars = [Var("inertia1.w", legend=_("Shaft speed")),
          Var("speedSensor.w", legend=_("Measured speed")),
          Var("feedback.u1", legend=_("Desired speed"))]
add_case(["SensorComparison", "FlatSystem$"], stopTime=5, res="AFS", tol=1e-3)
add_simple_plot(plot="AFS", vars=scvars, title=_("Response using ideal sensor"))

add_case(["SensorComparison", "FlatSystem_"], stopTime=5, res="AFS_SH", tol=1e-3)
add_simple_plot(plot="AFS_SH", vars=scvars, title=_("Response using a sample and hold sensor"))

ascvars = [Var("plant.inertia1.w", legend=_("Shaft speed")),
           Var("sensor.w", legend=_("Measured speed")),
           Var("controller.setpoint", legend=_("Desired speed"))]

add_case(["SensorComparison", "[^_]Variant1$"], stopTime=5, res="SV1", tol=1e-6)
add_simple_plot(plot="SV1", vars=ascvars, title=_("Response with hold time of 0.01"))

add_case(["SensorComparison", "Variant1_"], stopTime=5, res="SV1U", tol=1e-6)
add_simple_plot(plot="SV1U", vars=ascvars, title=_("Response with hold time of 0.036"))

add_case(["SensorComparison", "[^_]Variant2$"], stopTime=5, res="SV2", tol=1e-6)
add_simple_plot(plot="SV2", vars=ascvars, title=_("Response using PID control"))

add_case(["SensorComparison", "Variant2_"], stopTime=5, res="SV2T", tol=1e-6)
add_simple_plot(plot="SV2T", vars=ascvars, title=_("Response using a tuned PID controller"))

# Thermal Control

tcbvars = [Var("sensor.room.T", legend=_("Room Temperature")),
           Var("sensor.temperature", legend=_("Measured Temperature")),
           Var("controller.feedback.u2", legend=_("Desired Temperature"))]

tcevars = [Var("sensor.room.T", legend=_("Room Temperature (sensor.room.T)")),
           Var("controller.bus.temperature", legend=_("Measured Temperature (controller.bus.temp)")),
           Var("controller.feedback.u2", legend=_("Desired Temperature"))]

add_case(["ThermalControl", "BaseModel"], stopTime=50, res="TCB", tol=1e-3)
add_simple_plot(plot="TCB", vars=tcbvars, legloc="lower right",
                title=_("Response using PI controller"))
add_simple_plot(plot="TCBh", res="TCB", vars=[Var("plant.furnace.Q_flow")],
                title=_("Furnace heat using PI controller"))

add_case(["ThermalControl", "ExpandableModel"], stopTime=50, res="TCE", tol=1e-3)
add_simple_plot(plot="TCE", vars=tcevars, legloc="lower right",
                title=_("Response using PI controller in expandable architecture"))

tcebbvars = [Var("sensor.room.T", legend=_("Room Temperature (sensor.room.T)")),
           Var("controller.bus.temperature", legend=_("Measured Temperature (controller.bus.temp)")),
           Var("controller.setpoint_signal.y", legend=_("Desired Temperature"))]

add_case(["ThermalControl", "OnOffVariant"], stopTime=50, res="TCE_BB", tol=1e-3)
add_simple_plot(plot="TCE_BB", vars=tcebbvars, legloc="lower right",
                title=_("Response using PI bang-bang control"))

add_simple_plot(plot="TCE_BBh", res="TCE_BB", vars=[Var("controller.bus.heat_command")],
                legloc="lower right",
                title=_("Actuator duty cycle using bang-bang control"))

add_case(["ThermalControl", "HysteresisVariant"], stopTime=50, res="TCE_Hy", tol=1e-3)
add_simple_plot(plot="TCE_Hy", vars=tcebbvars, legloc="lower right",
                title=_("Response using PI bang-bang control with hysteresis"))

add_simple_plot(plot="TCE_Hyh", res="TCE_Hy", vars=[Var("controller.bus.heat_command")],
                legloc="lower right",
                title=_("Actuator duty cycle using bang-bang control with hysteresis"))

generate()
