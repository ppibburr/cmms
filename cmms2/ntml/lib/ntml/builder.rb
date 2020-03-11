class Numeric
  [:vw,:vh,:px,:em,:rem,:s].each do |m|
    define_method m do
      "#{self}#{m}"
    end
  end
  
  def pct
    "#{self}%"
  end
  
  def hex
    "#"+to_i.to_s(16)
  end
end

class String
  def read;self;end
end

class Array
  def rgba
    "rgba(#{self.join(",")})"
  end
end


class Style < Hash
  def to_s
    map do |k,v|
      if !v.is_a?(Hash)
        v=v.join(" ") if v.is_a?(Array)
        "#{k.to_s.gsub("_",'-')}: #{v};"
      else
        "#{k} {#{Style.new.merge(v).to_s}}"
      end
    end.join("")
  end
  
  def [] k
    super(k.to_s.gsub("_","-"))
  end
  
  def []= k,v
    if !v
      return delete(k.to_s.gsub("_","-"))
    end
    super(k.to_s.gsub("_","-"), v)
  end  
  
  def delete k
    super k.to_s.gsub("_", '-')
  end
  
  def keys
    super.map do |k| k.to_s.gsub("-", '_').to_sym end
  end
  
  def has_key? k; keys.index(k.to_s.gsub("-",'_').to_sym); end
  
  def each_pair &b
    super do |k,v|
      b.call(k.to_s.gsub("-",'_').to_sym) if b 
    end
  end
  
  def each &b
    each_pair do |k,v|
      b.call [k,v] if b
    end 
  end
  
  def map &b
    keys.map do |k| b.call [k, self[k]] if b end
  end
  
  def merge o
    o.each_pair do |k,v| self[k] = v end
    self
  end
end


def rule r, h={}
  s=(($CSS ||= {})[r] ||= Style.new())
  h.each_pair do |k,v|
    s[k.to_s.gsub("_",'-')] = v
  end

  s
end

rule '.flex-column',
  display: :flex,
  flex_direction: :column,
  flex: 1,
  height: 20.px
rule '.flex-row',
  display: :flex,
  flex_direction: :row,
  flex: 1
rule '.flex',
  flex: 1    
  
rule '.viewport',
  padding:0,
  margin:0,
  min_height: 100.vh,
  max_height: 100.vh,
  min_width:  100.vw,
  max_width:  100.vw   


