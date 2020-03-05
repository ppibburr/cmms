$: << File.join(File.expand_path(File.dirname(__FILE__)), '..','..', 'ntml', 'lib')
$: << File.join(File.expand_path(File.dirname(__FILE__)), '..','..', 'site', 'lib')
$: << File.join(File.expand_path(File.dirname(__FILE__)))
$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', '..', 'web', 'lib')

require 'ntml'
require 'web/push'
require 'web/request'
require 'render/page'
require 'render/view'
