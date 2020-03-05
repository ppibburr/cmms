

def view(view, site: nil, request: nil, params: {})
  file = "./sites/#{site}/views/#{view}.rb"
  unless File.exist?(file)
    file = "./views/#{view}.rb"
  
    unless File.exist?(file)
      open(file)
    end
  end
  

  if is_a?(Node)
   
  else
    class << self; def << *o; return *o; end;end
  end
  
  eval(open(file).read, send(:binding), file, 1)   
end
