$: << File.expand_path(File.join(File.dirname(__FILE__), ".."))
require 'base64'
require 'ntml/builder'

class Node
  def id; self["id"] end
  def id= i; self["id"] = i end
  def classname; self["class"]; end
  def classname= n; self["class"] = n; end
  attr_accessor :attributes, :tag
  def initialize tag, attr = {}, &b
    @attributes = {}
    @tag = tag
    attr.each do |k,v| self[k]=v end
    
    if self.class.classname
      self.class.ancestors.each do |a|
        add_class a.classname if a.respond_to?(:classname) && a.classname 
      end
    end
    
    @b=b
  end
  
  def []= k,v
    attributes[k.to_s] = v
    attributes.delete k if !v
    v
  end
  
  def [] k
    attributes[k.to_s]
  end
  
  def add_class n
    (self[:class] ||= "")
    self[:class] = self[:class].split(" ").reverse().push(n).reverse.join(" ")
    self
  end
  
  def style
    @style ||= Style.new
  end
  
  def to_s
    (self[:style] ||="")
    res = (@b ? instance_exec(@b.binding, &@b) : nil)
    (self[:style] ||="") << ";"+style!.to_s
    (@children ||= [])
    @children << res unless res.is_a?(Node) || !res || res.is_a?(Array)
    "<#{tag} #{attributes.map do |k,v| "#{k}=#{v.is_a?(String) ? "'#{v.strip}'" : v}".strip end.join(" ")}>"+
    @children.map do |c| c.to_s end.join("\n")+
    (tag.to_s.downcase != "br" ? "</#{tag}>" : "")
  end

  def << e
    (@children ||= [])
    @children << e unless @children.index(e) if e.is_a?(Node)
  end

  def + o
    to_s+o.to_s
  end
  
  [:border,:border_color,:border_radius,:border_style,:z_index,:color,:background_color,:flex_direction,:flex,:min_height,:max_height,:display,:margin,:padding,:position,:top,:left,:right,:bottom].each do |m|
    define_method m do |*o|
      (@style||=Style.new)[m.to_s.split("_").join("-")] = o.join(" ")
      self
    end
  end
  
  def self.style h=nil
    (@style||=Style.new)
    return @style unless h
    h.each_pair {|k,v|
      @style[k] = v
    }
  end
  
  def self.classname n=nil
    return @classname unless n
    @classname = n
  end

  attr_reader :children
  [:div,:para,:pre,:code, :small, :body,:head, :button,:title, :link, :label,:meta, :datalist,:option,:h1,:h2,:h3, :u, :a, :b, :em, :span,:img,:form,:input,:select,:option,:textarea,:header,:grid,:table,:td,:tr,:script,:style,:hr,:content,:article,:footer].each do |t|
    define_method t do |*o,&b|
      (@children ||= []) << e=ele(t,*o,&b)
      @children.last
    end
  end
  
  def list *o,&b
    self << e=List.new(*o,&b)
    e
  end

  def data_view *o,&b
    self << e=DataView.new(*o,&b)
    e
  end
  
  def style! h=nil
    return (@style ||= Style.new) if !h
    (@style ||= Style.new)
    h.each_pair do |k,v| 
      @style[k.to_s]=v
    end
    
    return self
  end
end

class DataView < Node
  def initialize root, o={}, &b
    @init = b
    @data = o.delete(:data)
    @container = o.delete(:container)
    super root, o do
     
    end
    add_class 'data-view'
  end

  def render item=nil
    if !item
      do_init()
    else
      do_item(item)
    end
  end
  
  def do_init()
    instance_exec &@init
        
    data.each do |item|
      render item  
    end
  end
  
  def do_item(item)
    this = self;cb=@item
    container(class: 'data-view-container') {
      instance_exec(this, [item].flatten, &cb).each_with_index do |h,i|
        self << this.contain(self, h,i)
      end
    }
  end

  def item &b
    @item = b
    self
  end
  
  def data d=nil
    return @data unless d
    @data = d
  end
  
  def container h={}, &b
    send(@container, h, &b)
  end
  
  def contain parent, h, i
    return h if h.is_a?(Node)
    parent.div() {h}
  end
  
  def to_s
    render
    super
  end
end

class List2 < DataView
  rule '.list', 
    display:        :flex,
    flex_direction: :column,
    flex:           1
  rule '.list-row',
    background_color: :azure,
    border: 'solid 1px teal'    
  rule'.list-row-item',
    color: 0x1f1f7b.hex
  rule '.list-header',
    background_color: 0x000.hex
  rule '.list-header-item',
    color: :blue,
    border: 'solid 1px blue'

  
  
  attr_reader :columns, :headers
  def initialize o={}, &b
    @columns = o.delete :columns
    @headers  = o.delete :headers
    
    @header = proc do
      @headers.map do |h| div() {h} end
    end
    
    o[:container] = :div
    
    super(:div, o) do
      instance_exec &b
      do_header()
    end
    
    add_class 'list flex-column'
  end
  
  def header &b
    @header = b
    self
  end
  
  def do_header()
    this = self; cb=@header 
    container() {
      style! flex: 0
      add_class 'flex-row list-header'
      instance_exec(this, @headers, &cb).each_with_index do |h,i|
        self << this.contain(self,h,i).add_class("list-header-item")
      end
    }
  end  
  
  def container h={}, &b 
    c = super(h) do
      add_class'flex-row list-row'
      self.style! display: :flex, flex: 0
      instance_exec &b
    end
  end
  
  def contain parent, n, i
    c=n
    unless n.is_a?(Node)
      c = parent.span() {n}
    end
    c.add_class "flex-row-item list-row-item"
    c.style! flex: columns[i], min_width: 20.px
  end
end


class FlexRow < Node
  def initialize *o,&b
    super :div, *o,&b
    add_class "flex-row"
  end
end

class FlexTable < Node
  def initialize *o,&b
    super :div, *o,&b
    add_class "flex-table"
  end
  
  def row *o,&b
    self << r=FlexRow.new(*o,&b)
    r
  end
  
  def header *o,&b
    e=row(*o,*b).add_class "flex-table-header"
    children.delete e
    @h=e
  end
  
  def to_s
    @h.style! flex:0 if @h
    @h.to_s+super
  end
end

class List < FlexTable
  attr_accessor :row_height, :colors
  def initialize *o,&b
    t=:div
    h=(o[0] ||= {})
    
    data    = h.delete :data
    columns = h.delete :columns
    header  = h.delete :header
    @colors = [:white, :aliceblue]#elete :colors
    @row_height  = h.delete :row_height || :auto
    grd = h.has_key?(:grow_rows)
    gr = h.delete(:grow_rows)
    grow_rows = grd && (gr == true) 
    
    bb = proc do
      instance_exec &b
      this=self    
      self << (FlexRow.new() {
        this.header.each_with_index do |v,i|
         
            e=this.render(self, v, -1,i).style!(flex: (columns[i] || 0), "flex-shrink": 0)
            e.style! "background-color": "darkblue", "padding-left":2.px
            e.add_class "list-header"
            self << e
          
        end
      }.style!(flex: 0, "min-height": "fit-content"))
      self << (
        FlexRow.new() {
          self << (FlexTable.new() {
			this.data.each_with_index do |r,i|
			 _r=row(class:'row') {
				r.each_with_index do |cell,ii|
				  
				  self << (this.render(self,cell ,i ,ii).style!(flex: (columns[ii] || 0), "flex-shrink": 0,"padding-left":2.px))
				end
			  }.style! flex: this.grow_rows? ? 1 : 0, "border-bottom": "solid 1px aliceblue",height: this.row_height
			  if this.colors
			    if i.even?
			    #  _r.style! "background-color": (this.colors[1] || this.colors[0])
			    else
			    #  _r.style! "background-color": this.colors[0]
			    end
			  end
			  ""
			end
		  }.style!(flex: 1, overflow: :auto, position: :auto))
		}.style!(flex: 1,height:100.px,"flex-basis": :auto)
      )
      
      ""
    end
     
    super *o,&bb
    
    style! flex: 1
    
    @header  = header || []
    @columns = columns || []
    @data    = data    || []
  
    @grow_rows = grow_rows
    add_class 'list'
  end
  
  attr_accessor :grow_rows
  
  def grow_rows?
    !!@grow_rows
  end
  
  def header; @header;
  end
 
  attr_reader :data,:columns

  def render t=nil, d=nil,r=nil,c=nil, &b
    return (@render = b) if b
    
    @render ||= proc do |*o|
      span() {o[0]}
    end
    
    t.instance_exec(d,r,c, &@render)
  end

  def to_s
    super
  end
end

class DataList < Node
  attr_accessor :options, :value, :filter
  def initialize *o, &b
    label = o[0].delete :label
    @options = o[0].delete :options
    @value = o[0].delete :value
    @filter = o[0].delete :filter
    o[0][:id] ||= "data-list-#{t=Time.now.to_f.to_s.split(".").join+rand(10000).to_s}"
    super :div, *o do
      this = self
     
     
     
      l="dl-#{t ||= this[:id]}"
      
      div() {

        input(onkeydown: "handle_filter(\"#{this.filter}\")", list: l, id: "input-#{t}", placeholder: label, value: this.value || "").style! flex:1, width:20.px
           
        datalist(id: l) {
          this.options.each do |o|
            option(value: o)
          end
        }
      }.style! display: :flex, flex:1
            
      instance_exec b.binding, &b if b
    end
    
    style! flex: 1
  end
end

require 'open3'
require 'json'

def rbml view, data

  build = File.expand_path(File.dirname(__FILE__)+"/build.rb")
  viewf = File.expand_path(File.dirname(__FILE__)+"/views/"+view)
  Open3.popen3("RUBYOPT=-W0 ruby -rjson -r#{build} #{viewf}") do |i,o,e,w|
    i.puts d=data.to_json
    succ = o.read
    err = e.read.split("\n")
 
    if err.empty?
      succ
    elsif view != "error.rb"
      begin
        rbml("error.rb", {"error": err[0], "backtrace": err[1..-1], "object": {view: view, data: data}})
      rescue => ee
        "<div style='background-color: white;color:black;'>"+
        err[0]+
        err[1..-1].reverse.join("<br>")+
        "</div>"
      end
    else
      "<div style='background-color: white;color:black;'>"+
      err[0]+
      err[1..-1].reverse.join("<br>")+
      "</div>"
    end 
  end
rescue => err
      "<div style='background-color: white;color:black;'>"+
      err.to_s+
      err.backtrace.reverse.join("<br>")+
      "</div>"
end




def ele t,*o,&b; Node.new(t,*o,&b); end
def html o={},&b
  ele :html, o, &b
end

def ele t,*o,&b; Node.new(t,*o,&b); end

def html o={},&b
  ele :html, o, &b
end

class Html < Node
  def initialize *o,&b
    super :html, *o,&b
    this=self
    @head=ele(:head) do
      this.do_head
    end
    @children ||= []
    @children.unshift @head     
  end
  def head &b
    p :head
    (@head_cba||=[]) << b
  end
  
  def do_head
  p :do 
    @head_cba.each do |b|
      @head.instance_exec &b
    end
  end
end

