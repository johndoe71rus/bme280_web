do
--
bmx280 = {}

function round (num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

--alt = 178
i2c.setup(0, 5, 4, i2c.SLOW) 
bmx280.mode = bme280.setup()
  
function timer()
 if bmx280.mode then
  bmx280.temp, bmx280.pres, bmx280.humi = bme280.read()
  if bmx280.temp and bmx280.pres then    
   bmx280.temp = bmx280.temp/100.
   bmx280.pres = round((bmx280.pres/1333.),2)
  else 
   bmx280.mode = nil 
  end
  if bmx280.mode == 2 and bmx280.humi then 
   bmx280.humi = round((bmx280.humi/1000.),2)
--   print("bme280")
--  else
--   print("bmp280")
  end
 else
  bmx280.mode = bme280.setup()
  print("no device")
 end
 print(bmx280.mode, bmx280.temp, bmx280.pres, bmx280.humi)
end

mytimer = tmr.create()
mytimer:register(50000, tmr.ALARM_AUTO, timer)
mytimer:interval(30000) -- actually, 3 seconds is better!
mytimer:start()
end
