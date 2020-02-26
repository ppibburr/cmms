require './site'
require './build'
render = ARGV.shift
data   = nil
if ARGV[0] =~ /\-\-render\=(.*)/
  ARGV.shift
  data=JSON.parse($1)
end
page, site, request = ARGV
r=JRequest.new(JSON.parse(request||'{}'))
case render
when "--page"
  pg = page page, site: site, request: r
  puts pg.to_s
when "--view"
  vw = view page, site: site, request: r
  if !data
    puts vw.to_s
  else
    puts vw.render(data) if data
  end
end
