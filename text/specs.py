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
add_simple_plot(plot="RLC1", vars=[Var("V", legend="Output Voltage [V]", style="-"),
                                   Var("Vb", legend="Battery Voltage [V]", style="-.")],
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
add_simple_plot(plot="SOSIP1", vars=sosvars, title="Mechanical Response; phi1(0)=0")

## LotkaVolterra
lvvars = [Var("x", legend="Prey population"),
          Var("y", legend="Predator population")]

add_case(["ClassicModel$"], stopTime=140, res="LVCM")
add_simple_plot(plot="LVCM", vars=lvvars, title="Classic Lotka-Volterra")

add_case(["QuiescientModel$"], stopTime=140, res="LVQM")
add_simple_plot(plot="LVQM", vars=lvvars, title="Queiscient Model (trivial solution)")

add_case(["QuiescientModelUsingStart"], stopTime=140, res="LVQMUS")
add_simple_plot(plot="LVQMUS", vars=lvvars,
                title="Queiscient Model (using start values)")

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


## Switched RLC
srlc_vvars = [Var("Vs", legend="Source Voltage [V]"),
              Var("V", legend="Response Voltage [V]")]
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
#rfl_vars = map(lambda x: Var("x["+str(x)+"]"), range(1,11))
#add_case(["Rod_ForLoop"], stopTime=1.0, res="RFL", tol=1e-3)
#add_simple_plot(plot="RFL", vars=rfl_vars,
#                title="One Dimensional Heat Transfer Response",
#                legloc="upper right")

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

generate()
