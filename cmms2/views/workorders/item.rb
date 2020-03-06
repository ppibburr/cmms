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



class Order < View
  def initialize *o,&b
    super :div,*o do
      add_class 'flex-column'
      this=self
      o = $store.get(:workorders, _id: this.params[:item])

s={}
def s.rule r, h={}
  s=((self)[r] ||= Style.new())
  h.each_pair do |k,v|
    s[k.to_s.gsub("_",'-')] = v
  end

  s
end  
s.rule '.wo-date',
  font_size: :smaller,
  font_weight: :bold

s.rule ".wo-desc",
  background_color: :whitesmoke
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
        span() {"Date: "}
        span(class: 'wo-date') {o['time'].strftime("%m - %d - %y")}.style! display: :inline
      }
      pre(class: 'wo-desc') {o['description']}.style! flex:1
      self << list
      span() {"There are: #{o['tasks'].length} tasks"}
    end
  end
  
  def list
      this = self
      List2.new(headers: ["","","",""], columns: [0,0,0,1]) {
        data($store.get(:workorders,_id: this.params[:item])['tasks'].map do |t| [t] end)
   
      }.header() {
        ["Equip","Interval", "Craft", "Description"]
      }.item() { |l,i|
        t=i=i[0]
       
        t = $store.get(:tasks, _id: i) unless i.is_a?(Hash)
        eq = $store.get(:equipment, _id: t['equipment'])
        [span(class: 'task-equip') {eq['order']}, span(class: 'task-int') {t['interval']}, span(class: 'task-craft') {t['craft']}, span(class: 'task-desc') {t['description']}]
      }.style! flex:3  
  end
  
  def render *o
    list.render(*o)
  end
end

Order.new(params: params, site: site, page: params[:page], request: request, view: params[:view]).style! flex:1
