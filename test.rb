require 'rufus-lua'
require 'benchmark'
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

y = 2

Benchmark.bm(12) do |bm|
  bm.report('ruby') { n.times {
    x = 10*y
    a = 3*x + 1
  } }
  bm.report('lua') { n.times {
    lua.eval(%{
      x = 10 * 2
      a = x*3 + 1
    })}
  }
  bm.report('lua func') {
    f = lua.eval(%{
      return function (y)
        x = 10 * y
        return x*3 + 1
      end
    })
    n.times {
      f.call(y)
    }
  }
  bm.report('keisan') { n.times {
    calculator.evaluate("x = 10*y", y: y)}
    calculator.evaluate("a = 3*x + 1")
  }
  bm.report('keisan func') {
    calculator.evaluate('f(y) = {x = 10*y;3*x + 1}')
    n.times {
      calculator.evaluate("f(y)", y: y)
    }
  }
end

lua.close
