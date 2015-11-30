require 'bundler'
Bundler.require

run Opal::Server.new { |s|
  s.append_path 'app'
  s.append_path 'node_modules'

  s.debug = true
  s.main = 'application'
  s.index_path = 'index.html.haml'
}

