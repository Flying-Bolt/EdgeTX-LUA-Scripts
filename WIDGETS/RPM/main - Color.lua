-- Horus full screen 480 x 272
-- Zone sizes WxH(wo menu / w menu):
-- 2x4 = 160x32
-- 2x2 = 225x122/98
-- 2x1 = 225x252/207
-- 2+1 = 192x152 & 180x70
-- 1x1 = 460/390x252/217/172
--       w390 x h172
--Heights: 32,70,98,122,172,207,217,252

RPMvalue = 0

local options = {
	{ "RPM", SOURCE, 1 },
	{ "Min", VALUE, 0 },
	{ "Max", VALUE, 15000 }
}

function create(zone, options)
	local context = { zone=zone, options=options }
	RPMimageFile = "/WIDGETS/RPM/RPMb172.png"
	hRPM = Bitmap.open(RPMimageFile)
	return context
end

function drawRPMGauge(context)
	
	if context.zone.w == 390 then 
	lcd.drawRectangle(context.zone.x, context.zone.y,context.zone.w,context.zone.h)
    lcd.drawBitmap(hRPM, context.zone.x + 12, context.zone.y)
	end
	--value = 550
	
	RPMValue = getValue(context.options.RPM)
  if(RPMvalue == nil) then
		return
	end
	
		
	if RPMValue > context.options.Max then
		RPMValue = context.options.Max
	elseif RPMValue < context.options.Min then
		RPMValue = context.options.Min
	end
	   
	degrees = ((10000.0- RPMValue)/1000.0) * 29.5;
	
	--10000	0,6
	--9000	30,0
	--8000	59,4
	--7000	88,9
	--6000	118,3
	--5000	147,8
	--4000	177,2
	--3000	206,7
	--2000	236,1
	--1000	265,6
	--   0	295,0
	
	Pi=3.14159
	
	x1 = math.floor(167) 
	y1 = math.floor(134) 
	x2 = math.floor(167 + (math.sin(degrees/180 * Pi) * (60)))
	y2 = math.floor(134 + (math.cos(degrees/180 * Pi) * (60)))
    		
	--Work arround RC8 horizontal line bug
	if y1 == y2 and x2 < x1 then
		xt = x1
		yt = y1
		x1 = x2
		y1 = y2
		x2 = xt
		y2 = yt
	end

	--lcd.setColor(CUSTOM_COLOR, lcd.RGB(255,255,255))
	lcd.setColor(CUSTOM_COLOR, lcd.RGB(0,0,0))
	lcd.setColor(WARNING_COLOR, lcd.RGB(255,0,0))

	
	if context.zone.w == 390 then 

	lcd.drawLine(x1-4, y1-1, x2, y2-1, SOLID, CUSTOM_COLOR)
	lcd.drawLine(x1-3, y1-1, x2, y2-1, SOLID, CUSTOM_COLOR)
	lcd.drawLine(x1-2, y1-1, x2, y2-1, SOLID, CUSTOM_COLOR)
	lcd.drawLine(x1+2, y1+1, x2, y2+1, SOLID, CUSTOM_COLOR)
	lcd.drawLine(x1+3, y1+1, x2, y2+1, SOLID, CUSTOM_COLOR)
	lcd.drawLine(x1+4, y1+1, x2, y2+1, SOLID, CUSTOM_COLOR)
		
	lcd.drawLine(x1-1, y1-1, x2, y2-1, SOLID, CUSTOM_COLOR)
	lcd.drawLine(x1, y1, x2, y2, SOLID, CUSTOM_COLOR)
	lcd.drawLine(x1+1, y1+1, x2, y2+1, SOLID, CUSTOM_COLOR)
    
	end
	
	flags1 = RIGHT + TEXT_COLOR
	flags2 = RIGHT + TEXT_BGCOLOR

		
     if context.zone.w == 390 then
	 lcd.drawSource(340, 70, context.options.RPM, flags1)
	 lcd.drawFilledRectangle(163 - 1, 130 , 12, 12, CUSTOM_COLOR, 2)
	 --lcd.drawFilledRectangle(context.zone.x + (context.zone.h/2) + 6, y1-8, 12, 12, CUSTOM_COLOR, 2)
	 
	 lcd.drawNumber(context.zone.x + (context.zone.h/2) + 7 - (#tostring(RPMValue) * 13), 180, RPMValue, DBLSIZE + CUSTOM_COLOR );
	 --lcd.drawNumber(140, 180, RPMValue, DBLSIZE + CUSTOM_COLOR + LEFT );
	 end
	 
     if context.zone.h == 70 then
	   lcd.drawNumber(context.zone.x - 30 +  context.zone.w / 4 - (#tostring(RPMValue) * 10), context.zone.y + 90, RPMValue, DBLSIZE + CUSTOM_COLOR );
	 end
end

function update(context, options)
	context.options = options
end

function refresh(context)
	drawRPMGauge(context)
end

return { name="RPMGauge", options=options, create=create, update=update, refresh=refresh }
