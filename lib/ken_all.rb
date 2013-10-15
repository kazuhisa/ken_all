require 'rubygems'
require 'open-uri'
require 'tempfile'
begin
  require 'zip' # rubyzip >= 1.0.0
rescue LoadError
  require 'zip/zip' # rubyzip < 1.0.0
end
require 'csv'
require 'curses'
require 'activerecord-import'
require 'ken_all/visualizer'
require 'ken_all/engine'
require 'ken_all/import'
require 'ken_all/merge_box'
require 'ken_all/post'
