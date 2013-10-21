from xogeny.plot_utils import render_twoup_plot

render_twoup_plot("BasicEquations_RLC_RLC1",
                  {"title": "Voltage": "vars": ["V"]},
                  {"title": "Currents": "vars": ["i_L", "i_C", "i_R"]})
