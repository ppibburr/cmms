require 'sinatra'
require './push'

def routes &b
  $routes[site=File.basename(File.dirname(caller[0].split(":")[0]))] = b  
end

Dir.glob('./sites/*/site.rb').each do |f|
  require f
end


($routes ||= {}).each_pair do |site,b|
  get "/#{site}" do
    page("./sites/#{site}/main.rb", site: site, request: Marshal.dump(request), params: params.to_json)
  end

  instance_exec site,&b
end

def page(file, site: nil, request: Marshal.dump(nil), params: {})
  unless File.exist?(file)
    file = "./pages/#{File.basename(file)}"
  end
  
  IO.popen('ruby ./mk_page.rb') do |io,_|
    io.puts({file: file, site: site, request: request, params: params}.to_json)
    return io.read
  end 
end

require 'open3'
def view(file, site: nil, request: Marshal.dump(nil), params: {})
file=file+".rb"
  unless File.exist?(file)
    file = "./views/#{File.basename(file)}"
  end
  
  Open3.popen3('ruby ./render.rb') do |i,o,_|
    i.puts({file: file, site: site, request: request, params: params}.to_json)
    return o.read
  end 
end

