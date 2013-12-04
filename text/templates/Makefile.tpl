<% _.forEach(results, function(result) { %>
results/<%= result.id %>_res.mat: results/<%= result.id %>.mos
	    (cd results; omc ./<%= result.id %>.mos)
<% }); %>
