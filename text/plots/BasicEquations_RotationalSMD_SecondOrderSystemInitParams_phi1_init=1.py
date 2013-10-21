from xogeny.plot_utils import render_simple_plot

render_twoup_plot("BasicEquations_RLC_RLC1",
                  {"title": "Positions", "vars": ["phi1", "phi2"]},
                  {"title": "Velocities", "vars": ["omega1", "omega2"]})
