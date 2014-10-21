'use strict';

Package.describe({
  name: 'fds:forms',
  summary: "[DON'T USE] Forms framework built with dataflow",
  version: '0.0.0',
  git: 'https://github.com/foxdog-studios/meteor-forms.git'
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@0.9.4');
  api.use(
    [
      'coffeescript',
      'reactive-var',
      'tracker',
      'underscore',
      'fds:jison-build',
    ],
    'client'
  );
  api.addFiles(
    [
      'client/lib/decimal.jison',
      'client/lib/export.js',
        'client/lib/decimal_string.coffee',
        'client/lib/node.coffee',
        'client/lib/node_computer.coffee',
        'client/lib/node_computation.coffee',
    ],
    'client'
  );
  api.export('Forms', 'client');
});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('coffeescript');
  api.use('fds:forms');
});

