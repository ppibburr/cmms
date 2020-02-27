

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
