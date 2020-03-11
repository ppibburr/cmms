$store ||= Store.new('hanley-cmms')
class View < Node
  attr_reader :params, :request, :site, :page
  def initialize tag, *o, site: nil, page: nil, request: nil, params: {}, view: nil, &b
    @params=params
    @request = request
    @site = site
    @page = page
    super tag,*o,&b
  end
  
  def render *o
    ""
  end
end



class Inventory < View
  def initialize *o,&b
    super :div,*o do
      add_class 'flex-column'
      this=self
      p :inventory, _id: this.params[:item]
      o = $store.get(:inventory, _id: this.params[:item])

s={}
def s.rule r, h={}
  s=((self)[r] ||= Style.new())
  h.each_pair do |k,v|
    s[k.to_s.gsub("_",'-')] = v
  end

  s
end  
s.rule '.wo-date',
  font_size: 1.1.em,
  font_weight: :bold

s.rule ".inv-desc",
  background_color: :whitesmoke,
  font_size: 1.2.em
def s.to_s
  map do |r, s|
    "#{r} {"+
    s.to_s+
    "}\n"
  end.join("\n")
end
style {
  s.to_s
}
      div() {
        input(type: :text, placeholder: 'location', value: o['location']) 
        input(type: :text, placeholder: 'manufacturer', value: o['manufacturer'])
        input(type: :text, placeholder: 'model', value: o['model_no'])
      }
      div() {
        input(type: :text, placeholder: 'price', value: o['price']) 
        input(type: :text, placeholder: 'min', value: o['min'])
        input(type: :text, placeholder: 'quantity', value: o['quantity'])  
      }

      textarea(class: 'inv-desc') {o['description']}.style! flex:1

      span() {"$#{o['quantity'] * o['price']} worth on hand"}
    end
  end
end

Inventory.new(params: params, site: site, page: params[:page], request: request, view: params[:view]).style! flex:1
