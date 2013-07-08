basePath = '../';

files = [
  JASMINE,
  JASMINE_ADAPTER,
  'app/lib/angular/angular.js',
  'test/lib/angular/angular-mocks.js',
  'app/js/BWL/base.js.coffee',
  'app/lib/ender/ender.js',
  'app/lib/i18next/release/i18next-1.6.3.js',
  'app/js/BWL/data_access.js.coffee',
  'app/js/**/*.js.coffee',
  'test/unit/**/*.js.coffee'
];

autoWatch = true;

browsers = ['Chrome'];

junitReporter = {
  outputFile: 'test_out/unit.xml',
  suite: 'unit'
};
