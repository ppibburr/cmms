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

class Page
  attr_reader :page,:site,:request, :file
  def initialize(page,site,request)
    @page=@page; @site = site,@request=JRequest.new(request)
    
	@file = file?(page)   
  end
  
  def file?(page = @page)
    file = "./sites/#{site}/"+page+".rb"
	unless File.exist?(file)
  	  file = "./pages/#{File.basename(file)}"

	  unless File.exist?(file)
	    file = file?('error')
	    request.params["type"] = 404
	  end 
	end   
	
	file
  end
  
  def content!
    renders=self
    file = @file 
    eval(open(file).read, binding, file, 1).to_s
  end
  
  def to_s
    common = "./sites/#{site}/common.rb"
    common = "./common.rb" if !File.exist?(common)
    renders=self
    eval(open(common).read, binding, common, 1).to_s
  end
end

def page(page, site: nil, request: nil)
  pg = Page.new page, site,request
end

def view(view, site: nil, request: nil)
  file = "./sites/#{site}/views/#{view}.rb"
  unless File.exist?(file)
    file = "./views/#{File.basename(file)}"
  
    unless File.exist?(file)
      open(file)
    end
  end
  

  eval(open(file).read, binding, file, 1)
end


class String
  def read;self;end
end

class JRequest
  attr_reader :real
  def initialize req
    @real = req
    if real.is_a?(Hash)
      extend WrapsHash
      real[:params] = real.delete("params") || {}
    else
      extend WrapsRack
    end
  end
  
  module WrapsHash
    [:accept_encoding,:params, :accept_language, :authority, :base_url, :body, :content_charset, :content_length, :content_type, :cookies, :delete?, :form_data?, :fullpath, :get?, :head?, :host, :host_with_port, :ip, :link?, :logger, :media_type, :media_type_params, :multithread?, :options?, :parseable_data?, :patch?, :path, :path_info, :path_info=, :port, :post?, :put?, :query_string, :referer, :request_method, :scheme, :script_name, :script_name=, :session, :session_options, :ssl?, :trace?, :trusted_proxy?, :unlink?, :url, :user_agent].each do |m|
      if m.to_s =~ /(.*)\=/
        define_method m do |v|
          real[$1.to_sym]=v 
        end
      elsif m.to_s =~ /(.*)\?/
        define_method m do
          !!real[$1.to_sym]
        end
      else
        define_method m do
          real[m.to_sym]
        end
      end
    end
  end
  
  module WrapsRack
    [:accept_encoding, :accept_language, :params, :authority, :base_url, :body, :content_charset, :content_length, :content_type, :cookies, :delete?, :form_data?, :fullpath, :get?, :head?, :host, :host_with_port, :ip, :link?, :logger, :media_type, :media_type_params, :multithread?, :options?, :parseable_data?, :patch?, :path, :path_info, :path_info=, :port, :post?, :put?, :query_string, :referer, :request_method, :scheme, :script_name, :script_name=, :session, :session_options, :ssl?, :trace?, :trusted_proxy?, :unlink?, :url, :user_agent].each do |m|
      define_method m do |*o,&b|
        @real.send(m,*o,&b)
      end
    end
  end
end
require './build'

get "/:site/:page" do
  page(params[:page], site: params[:site], request: request).to_s
end

post "/:site/:page/render/:view" do
  view(params[:view], site: params[:site], request: request).to_s  
end

post "/:site/:page/:view/render" do
  view(params[:view], site: params[:site], request: request).render(JSON.parse(request.body.read)).to_s
end


