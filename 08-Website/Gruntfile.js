
module.exports = function (grunt) {
    grunt.loadNpmTasks("grunt-contrib-clean");
    grunt.loadNpmTasks("grunt-contrib-copy");
    grunt.initConfig({
        copy: {
            "normalize": {
                files: [
                    {   expand: true, flatten: false, cwd: "node_modules/normalize.css",
                        src: "normalize.css", dest: "lib/normalize/" }
                ]
            },
            "fontawesome": {
                files: [
                    {   expand: true, flatten: false, cwd: "node_modules/@fortawesome/fontawesome-free/css",
                        src: "all.min.css", dest: "lib/fontawesome/",
                        rename: (src, dest) => src + "fontawesome.css",
                    }, {
                        expand: true, flatten: false, cwd: "node_modules/@fortawesome/fontawesome-free/webfonts",
                        src: "fa-*", dest: "lib/fontawesome/",
                        rename: (src, dest) => src + dest.replace(/fa-/, "fontawesome-")
                    }
                ],
                options: {
                    encoding: null,
                    process: (content, srcpath) => {
                        if (srcpath.match(/all\.min\.css/))
                            content = content.toString().replace(/\.\.\/webfonts\/fa-/g, "fontawesome-")
                        return content
                    }
                }
            },
            "typopro": {
                files: [
                    {   expand: true, flatten: false, cwd: "node_modules/typopro-web/web",
                        src: "TypoPRO-SourceSansPro/**", dest: "lib/typopro/" }
                ]
            }
        },
        clean: {
            clean:     [ "lib" ],
            distclean: [ "node_modules" ]
        }
    });
    grunt.registerTask("default", [ "copy" ]);
};

