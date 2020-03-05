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

rule '.date',
  font_size: :small

class Order < View
  def initialize *o,&b
    super :div,*o do
      this=self
      o = $store.get(:workorders, _id: this.params[:item])
      span() {"Work Order #{this.params[:item]}"} 
      span(class: 'date') {o['time']}
    
      self << list
    end
  end
  
  def list
      this = self
      List2.new(headers: ["",""], columns: [0,0,1]) {
        data($store.get(:workorders,order: this.params[:item].to_i)['tasks'].map do |t| [t] end)
   
      }.header() {
        ["Craft", "Interval", "Description"]
      }.item() { |l,i|
        t=i=i[0]
       
        t = $store.get(:tasks, _id: i) unless i.is_a?(Hash)
        [span(class: 'task-craft') {t['craft']}, span(class: 'task-int') {t['interval']}, span(class: 'task-desc') {t['description']}]
      }  
  end
  
  def render *o
    list.render(*o)
  end
end

Order.new params: params, site: site, page: params[:page], request: request, view: params[:view]
