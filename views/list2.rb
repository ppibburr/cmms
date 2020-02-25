def $CSS.to_s
  map do |r, s|
    "#{r} {"+
    s.to_s+
    "}\n"
  end.join("\n")
end

q=Node.new(:html, class: 'viewport') {
  style() {$CSS.to_s}
  body(class: 'viewport') {
    self << List2.new(headers: ["Col 0", "Col 1"], columns: [0,1]) {
      data([[1,2],[1,2]])
    }.header() {|list, headers|
      ["one","two","three"] 
    }.item() {|list, item|
      item.map do |i|
        span() {i}.style! color: :red
      end
    }
  }
}

puts q

__END__
