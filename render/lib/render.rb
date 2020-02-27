$: << File.join(File.expand_path(File.dirname(__FILE__)), '..','..', 'ntml', 'lib')
$: << File.join(File.expand_path(File.dirname(__FILE__)), '..','..', 'site', 'lib')
$: << File.join(File.expand_path(File.dirname(__FILE__)))

require 'ntml'
require 'site/request'
require 'render/page'
require 'render/view'
