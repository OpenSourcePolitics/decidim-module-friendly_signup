# frozen_string_literal: true

require "decidim/dev/common_rake"
require "fileutils"

# fix: https://github.com/decidim/decidim/blob/f2360320143222a53858f9d7a8bbddc9cad218aa/babel.config.json
def fix_babel_configs(path)
  Dir.chdir(path) do
    puts "Fixing JS dependencies in 'babel.config.json'..."
    File.write("babel.config.json", "
{
  'presets': [
    [
      '@babel/preset-env', {
        'forceAllTransforms': true,
        'useBuiltIns': 'entry',
        'corejs': 3,
        'modules': false
      }
    ],
    ['@babel/preset-react']
  ],
  'plugins': [
    '@babel/plugin-transform-classes',
    [
      '@babel/plugin-transform-runtime',
      {
        'helpers': false,
        'regenerator': true,
        'corejs': false
      }
    ],
    ['@babel/plugin-transform-regenerator', { 'async': false }]
  ]
}")
    puts "Successfully modified !

You must now run to finish installing development_app:

cd development_app && yarn install && bundle exec bin/webpack
"
  end
end

desc "Generates a dummy app for testing"
task :test_app do
  generate_decidim_app(
    "spec/decidim_dummy_app",
    "--app_name",
    "#{base_app_name}_test_app",
    "--path",
    "../..",
    "--recreate_db",
    "--skip_gemfile",
    "--skip_spring",
    "--skip_webpack_install",
    "--demo",
    "--force_ssl",
    "false",
    "--locales",
    "en,ca,es"
  )
  fix_babel_configs("spec/decidim_dummy_app")
end

desc "Generates a development app."
task :development_app do
  Bundler.with_original_env do
    generate_decidim_app(
      "development_app",
      "--app_name",
      "#{base_app_name}_development_app",
      "--path",
      "..",
      "--recreate_db",
      "--seed_db",
      "--demo",
      "--skip_webpack_install",
      "--profiling",
      "--locales",
      "en,ca,es",
      "--dev_ssl"
    )
  end

  fix_babel_configs("development_app")
end
