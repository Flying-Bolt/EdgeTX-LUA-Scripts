-- Horus full screen 480 x 272
-- Zone sizes WxH(wo menu / w menu):
-- 2x4 = 160x32
-- 2x2 = 225x122/98
-- 2x1 = 225x252/207
-- 2+1 = 192x152 & 180x70
-- 1x1 = 460/390x252/217/172
--       w390 x h172
--Heights: 32,70,98,122,172,207,217,252

PAvalue = 0

local options = {
	{ "PA", SOURCE, 1 },
	{ "Min", VALUE, 0 },
	{ "Max", VALUE, 15000 }
}

function create(zone, options)
	local context = { zone=zone, options=options }
	PAimageFile = "/WIDGETS/Druck/PAc172.png"
	hPA = Bitmap.open(PAimageFile)
	return context
end

function drawPAGauge(context)
	
	if context.zone.w == 390 then 
	lcd.drawRectangle(context.zone.x, context.zone.y,context.zone.w,context.zone.h)
    lcd.drawBitmap(hPA, context.zone.x + 12, context.zone.y)
	end
	--value = 550
	
	PAvalue = getValue(context.options.PA)
  if(PAvalue == nil) then
		return
	end
	
		
	if PAvalue > context.options.Max then
		PAvalue = context.options.Max
	elseif PAvalue < context.options.Min then
		PAvalue = context.options.Min
	end
	   
	degrees = ((10000.0- PAvalue)/1000.0) * 30 - 30;
	
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
	
	x1 = math.floor(252) 
	y1 = math.floor(200) 
	x2 = math.floor(252 + (math.sin(degrees/180 * Pi) * (100)))
	y2 = math.floor(200 + (math.cos(degrees/180 * Pi) * (100)))
    		
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
	 lcd.drawFilledRectangle(252 - 6, 195 , 12, 12, CUSTOM_COLOR, 2)
	 lcd.drawSource(410, 60, context.options.PA, flags1)	
	--lcd.drawFilledRectangle(context.zone.x + (context.zone.h/2) + 6, y1-8, 12, 12, CUSTOM_COLOR, 2)
	 
	 lcd.drawNumber(252 + 9 - (#tostring(PAvalue) * 13), 140, PAvalue, DBLSIZE + CUSTOM_COLOR );
	 --lcd.drawNumber(140, 180, PAvalue, DBLSIZE + CUSTOM_COLOR + LEFT );
	 end
	 
     if context.zone.h == 70 then
	   lcd.drawNumber(context.zone.x - 30 +  context.zone.w / 4 - (#tostring(PAvalue) * 10), context.zone.y + 90, PAvalue, DBLSIZE + CUSTOM_COLOR );
	 end
end

function update(context, options)
	context.options = options
end

function refresh(context)
	drawPAGauge(context)
end

return { name="PAGauge", options=options, create=create, update=update, refresh=refresh }
