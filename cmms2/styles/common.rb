def $CSS.to_s
  map do |r, s|
    "#{r} {"+
    s.to_s+
    "}\n"
  end.join("\n")
end

rule "body",
  margin: 0,
  padding: 0,
  min_width: 100.vw,
  max_width: 100.vw,
  max_height: 100.vh

rule '.main', 
  margin: :auto,
  min_width: 82.vw,
  max_width: 82.vw,
  max_height: 88.vh,
  min_height: 88.vh,
  margin_top: 5.vh,
  background_color: 0xfafbfc.hex, 
  box_shadow:  [10.px, 10.px, 8.px, 0x282020.hex],
  border_top:  [:solid, 1.px, 0xcecece.hex],
  border_left: [:solid, 1.px, 0xcecece.hex]
   
rule 'body',
  #/*text-align: -webkit-center;*/
  background_color: 0xb7b7b7.hex,
  color: 0x2d3033.hex,
  font_weight: 500,
  line_height: 1.6,
  font_size: 0.7125.rem,
  max_width: 100.pct,
  text_rendering: :optimizeLegibility,
  '-webkit-font-smoothing': :antialiased,
  '-moz-osx-font-smoothing': :grayscale,
  color: 'var(--color-charcoal)',
  font_family: [:Montserrat, :Helvetica, 'sans-serif'], 
  display: :flex

rule '.popup',
  flex:0,
  min_height: 78.vh,
  max_height: 78.vh,
  margin: [12.vh, 11.vw],
  width: 78.vw,
  border: :ridge,
  border_radius: 0.1.em,
  background_color: :aliceblue,
  box_shadow: [10.px, 10.px, 8.px, 0x282020.hex]

rule '#popup',      
  display: :none,
  position: :relative,
  left: -600.px,
  background: :blue,
  '-webkit-animation': [:slide, 0.2.s, :forwards],
  '-webkit-animation-delay': 1.s,
  animation: [:slide, 0.5.s, :forwards],
  animation_delay: 0.0.s,
  height: 100.vh,
  width: 100.vw,
  position: :fixed,
  top: 0, #/*left: 0;*/
  background_color: [39, 55, 77, 0.59].rgba,
  z_index: 100            
  
rule '@-webkit-keyframes slide',
  '100%': { left: 0 }

rule '@keyframes slide',
  '100%': {left:0}

rule '#popup:target',
  display: :block;
