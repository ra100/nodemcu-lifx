local ip = wifi.sta.getip()
if not ip == nil then
  print('Found IP:' .. ip)
end
if wifi.sta.status() == wifi.STA_GOTIP then
  print('WiFi already connected')
  return
end

local station_cfg={}
station_cfg.ssid=SSID
station_cfg.pwd=PASSWORD
station_cfg.save=true
if ip == nil and IP == '' then
  wifi.setmode(wifi.STATION)
  wifi.setphymode(wifi.PHYMODE_N)
  wifi.sta.config(station_cfg)
  wifi.sleeptype(wifi.LIGHT_SLEEP)
  wifi.sta.autoconnect(1)
  wifi.sta.connect()
else
  wifi.setmode(wifi.STATION)
  wifi.sta.config(station_cfg)
  wifi.sleeptype(wifi.LIGHT_SLEEP)
  wifi.sta.connect()
  wifi.sta.setip({ip=IP,netmask="255.255.255.0",gateway=GETEWAYIP})
end
