exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      joinTo: 'js/app.js',
      order: {
        before: [
          /^bower_components/,
          /^web\/static\/vendor/
        ]
      }
    },
    stylesheets: {
      joinTo: 'css/app.css'
    },
    templates: {
      joinTo: 'js/app.js'
    }
  },

  conventions: {
    // This option sets where we should place non-css and non-js assets in.
    // By default, we set this to "/web/static/assets". Files in this directory
    // will be copied to `paths.public`, which is "priv/static" by default.
    assets: /^(web\/static\/assets)/
    // vendor: []
  },

  paths: {
    watched: [
      "deps/phoenix/web/static",
      "deps/phoenix_html/web/static",
      "web/static",
      "test/static"
    ],
    public: "priv/static"
  },

  plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [/web\/static\/vendor/]
    },
    elmBrunch: {
      // elmFolder: 'web/static/elm',
      mainModules: [
        'web/static/elm/Gaze/System.elm',
        'web/static/elm/Gaze.elm'
      ]
      // outputFolder: 'priv/static/js'
    },
  },

  modules: {
    autoRequire: {
      "js/app.js": ["web/static/js/app"]
    }
  },
};
