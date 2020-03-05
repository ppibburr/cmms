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
