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
    (self[:class] ||= "") << " #{n}"
    self
  end
  
  def style
    @style ||= Style.new
  end
  
  def to_s
    self[:style] = style!.to_s
    res = (@b ? instance_exec(@b.binding, &@b) : nil)
    (@children ||= [])
    @children << res unless res.is_a?(Node) || !res || res.is_a?(Array)
    "<#{tag} #{attributes.map do |k,v| "#{k}=#{v.is_a?(String) ? "'#{v.strip}'" : v}".strip end.join(" ")}>"+
    @children.map do |c| c.to_s end.join("\n")+
    (tag.to_s.downcase != "br" ? "</#{tag}>" : "")
  end

  def << e
    (@children ||= []) << e
  end

  def + o
    to_s+o.to_s
  end
end

def ele t,*o,&b; Node.new(t,*o,&b); end

class Node
  attr_reader :children
  [:div,:para,:pre,:code, :small, :head, :title, :meta,:h1,:h2,:h3, :u, :a, :b, :em, :span,:img,:form,:input,:select,:option,:textarea,:header,:grid,:table,:td,:tr,:script,:style,:hr,:content,:article,:footer].each do |t|
    define_method t do |*o,&b|
      (@children ||= []) << e=ele(t,*o,&b)
      @children.last
    end
  end
  
  def list *o,&b
    self << e=List.new(*o,&b)
    e
  end
  
  def style! h=nil
    return (self[:style] ||= Style.new) if !h
    s = (self[:style] ||= Style.new)
    h.each_pair do |k,v| 
      s[k.to_s]=v
    end
    return self
  end
end

class Style < Hash
  def to_s
    
    map do |k,v|
      "#{k}: #{v};"
    end.join("\n")
    
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
  def initialize *o,&b
    t=:div
    h=(o[0] ||= {})
    
    data    = h.delete :data
    columns = h.delete :columns
    header  = h.delete :header
    grd = h.has_key?(:grow_rows)
    gr = h.delete(:grow_rows)
    grow_rows = grd && (gr == true) 
    
    bb = proc do
      instance_exec &b
      this=self    
      self << (FlexRow.new() {
        this.header.each_with_index do |v,i|
          e=this.render(self, v, -1,i).style!(flex: (columns[i] || 0), "flex-shrink": 0)
          e.style! "background-color": "darkblue", color: :azure
          self << e
        end
      }.style! flex: 0)
      self << (
        FlexRow.new() {
          self << (FlexTable.new() {
			this.data.each_with_index do |r,i|
			  row() {
				r.each_with_index do |cell,ii|
				  
				  self << (this.render(self,cell ,i ,ii).style!(flex: (columns[ii] || 0), "flex-shrink": 0))
				end
			  }.style! flex: this.grow_rows? ? 1 : 0, "border-bottom": "solid 1px rosybrown"
			end
		  }.style!(flex: 1))
		}.style! flex: 1,overflow: :auto, position: :relative
      )
      ""
    end
     
    super *o,&bb
    
    style! flex: 1
    
    @header  = header || []
    @columns = columns || []
    @data    = data    || []
  
    @grow_rows = grow_rows
  end
  
  attr_accessor :grow_rows
  
  def grow_rows?
    !!@grow_rows
  end
  
  def header; @header; end
  attr_reader :data,:columns

  def render t=nil, d=nil,r=nil,c=nil, &b
    return (@render = b) if b
    t.instance_exec(d,r,c, &@render) if @render
  end

  def to_s
    super
  end
end
