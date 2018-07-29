tmr.alarm(1, 1000, tmr.ALARM_SINGLE, function()
  dofile('config.lua')
  dofile('wifi.lua')
  dofile('control.lua')
end)

