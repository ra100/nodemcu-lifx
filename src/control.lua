local lifx = require "lifx"
local hcsr04 = require "hcsr04"
local val = 0
local prev = -1 -- previous distance value

function measure_callback(dist)
  if DEBUG then
    print("measure " .. dist)
  end
  if (math.abs(dist - prev) < 0.2) then
    if DEBUG then
      print("distance detected")
    end
    local d = (prev + dist) / 2
    if d > MINDIST and d < (MAXRANGE + MAXDIST) then
      if d > MAXDIST then
        val = 100
      else
        val = ((d - MINDIST) / RANGE) * 100
      end
      if DEBUG then
        print("Brightness " .. val)
      end
      lifx.setBrightness(
        val,
        FADETIME,
        LIGHT,
        function()
          tmr.alarm(1, REFRESH, tmr.ALARM_SINGLE, startTimer)
        end
      )
      return nil
    elseif d < MINDIST and d > 0 then
      if DEBUG then
        print("Light Off")
      end
      lifx.lightOff(
        LIGHT,
        function()
          tmr.alarm(1, REFRESH, tmr.ALARM_SINGLE, startTimer)
        end
      )
      return nil
    end
  end
  prev = dist
  tmr.alarm(1, 100, tmr.ALARM_SINGLE, startTimer)
end

function startTimer()
  if DEBUG then
    print("Timer started, heap " .. node.heap())
  end
  -- if node.heap() < 4000 then collectgarbage() end
  hcsr04(TRIG, ECHO, AVG, MEASURE_TIMER, measure_callback)
end

if wifi.sta.status() == wifi.STA_GOTIP then
  lifx.init(BASEURL, LIGHT, 4, startTimer)
  startTimer()
else
  wifi.eventmon.register(
    wifi.eventmon.STA_GOT_IP,
    function()
      wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, "unreg")
      if DEBUG then
        print(wifi.sta.getip())
      end
      lifx.init(BASEURL, LIGHT, 4, startTimer)
      startTimer()
    end
  )
end
