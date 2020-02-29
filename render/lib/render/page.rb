class Page
  attr_reader :page,:site,:request, :file
  def initialize(page,site,request)
    @page=@page; @site = site;@request=JRequest.new(request)
    #p init: page
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
  
  def content! &b
    renders=self
    file = @file 
    eval(open(file).read, b.send(:binding), file, 1)
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
