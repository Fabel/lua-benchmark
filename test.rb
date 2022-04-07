require 'rufus-lua'
require 'benchmark'Screenshot 2022-04-07 at 21.15.22.png
require 'pry'
require 'keisan'

n = 500000

lua = Rufus::Lua::State.new
calculator = Keisan::Calculator.new

# one of way to make sandbox
# lua.eval(%{
#   arg=nil
#   debug.debug=nil
#   debug.getfenv=getfenv
#   debug.getregistry=nil
#   dofile=nil
#   io={write=io.write}
#   loadfile=nil
#   os = {time = os.time}
#   package.loaded.io=io
#   package.loaded.package=nil
#   package=nil
#   require=nil
# })


Benchmark.bm(7) do |x|
  x.report('ruby') { n.times { a = 1 + 1 } }
  x.report('lua') { n.times { lua.eval('a = 1 + 1')} }
  x.report('keisan') { n.times { calculator.evaluate("a = 1 + 1")} }
end

lua.close
