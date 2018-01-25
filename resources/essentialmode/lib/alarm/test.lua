-- test alarm

require "alarm"

version = "alarm library for " .. _VERSION .. " / May 2012"

------------------------------------------------------------------------------
print(version)

------------------------------------------------------------------------------
print ""
print "timeout..."

function timeout(t, f, ...)
    alarm(t, function() error "timeout!" end)
    print(pcall(f, ...))
    alarm()
end

timeout(1, function(N) for i = 1, N do end return "ok", N end, 1e6)
timeout(1, function(N) for i = 1, N do end return "ok", N end, 1e9)

------------------------------------------------------------------------------
print ""
print "timer..."

function timer(s, f)
    local a = function() f() alarm(s) end
    alarm(s, a)
end

a = 0
b = 0
function myalarm()
    print("in alarm!", os.date "%T", math.floor(100 * a / N) .. "%", b, a)
    b = 0
end

N = 3e7
timer(2, myalarm)
print("start   ", os.date "%T", math.floor(100 * a / N) .. "%", b, a)
for i = 1, N do
    a = a + 1
    b = b + 1
    math.sin(a) -- waste some time...
end
print("finish  ", os.date "%T", math.floor(100 * a / N) .. "%", b, a)

------------------------------------------------------------------------------
print ""
print(version)
