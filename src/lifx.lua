local lifx = {}

local light = nil
local baseurl = nil
local sending = false
local defaultDuration = 200

local function requestCallback(code, data, callback)
  sending = false
  if DEBUG then
    if (code < 0) then
      print("HTTP request failed")
    else
      print(code, data)
    end
  end
  callback()
end

local function sendBrightness(brightness, dur, l, callback)
  if sending then
    if DEBUG then print('sending in progress') end
    return nil
  end
  local duration = dur or defaultDuration
  local tmplight = l or light
  http.request(
    baseurl .. '/lights/' .. tmplight,
    'PATCH',
    'Content-Type: application/json\r\n',
    '{"brightness": '.. brightness ..', "duration": '.. dur ..'}',
    function(c, d) requestCallback(c, d, callback); end)
end

local function sendPower(power, dur, l, callback)
  if sending then
    if DEBUG then print('sending in progress') end
    local_cb()
    return nil
  end
  sending = true
  local duration = dur or defaultDuration
  local tmplight = l or light
  http.request(
    baseurl .. '/lights/' .. tmplight,
    'PATCH',
    'Content-Type: application/json\r\n',
    '{"power": '.. power ..', "duration": '.. dur ..'}',
    function(c, d) requestCallback(c, d, callback); end)
end

function lifx.init(url, l, timer_id)
  baseurl = url
  light = l
  local tid = timer_id or 4
  tmr.alarm(tid, 1000, tmr.ALARM_AUTO, function() sending = false; end)
  return true
end

-- turn the light on
function lifx.lightOn(l, callback)
  sendPower(1, defaultDuration, l, callback)
end

-- turn the light off
function lifx.lightOff(l, callback)
  sendPower(0, 0, l, callback)
end

-- lightsd code, value 0 - 100
function lifx.setBrightness(value, duration, light, callback)
  sendBrightness(value, duration, light, callback)
end

return lifx
