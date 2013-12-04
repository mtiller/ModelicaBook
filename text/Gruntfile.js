var targets = {
    'Makefile': {
        'options': {
            'data': {
		"results": [{"id": "Bar"}, {"id": "Fuz"}]
            }
        },
        'files': {
            'Makefile.inc': ['templates/Makefile.tpl']
        }
    }
}

module.exports = function(grunt) {
    grunt.loadNpmTasks('grunt-template');

    grunt.initConfig({
        'template': targets
    });
    grunt.registerTask('default', ['template']);
};
