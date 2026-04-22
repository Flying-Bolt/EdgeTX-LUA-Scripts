-- Horus full screen 480 x 272
-- Zone sizes WxH(wo menu / w menu):
-- 2x4 = 160x32
-- 2x2 = 225x122/98
-- 2x1 = 225x252/207
-- 2+1 = 192x152 & 180x70
-- 1x1 = 460/390x252/217/172
--       w390 x h172
--Heights: 32,70,98,122,172,207,217,252

local TemperaturValueMax = 20
local ImageMax

local options = {
	{ "TempA", SOURCE, 1 },
	{ "TempB", SOURCE, 1 },
	{ "Min", VALUE, 20, -1024, 1024 },
	{ "Max", VALUE, 150, -1024, 1024 }
}

local function create(zone, options)
	local context = { zone=zone, options=options }
	local imageFile = "/WIDGETS/Temp/t" .. context.zone.h .. ".png"
	context.back = Bitmap.open(imageFile)
	if context.zone.w == 390 then
		local imageFileMax = "/WIDGETS/Temp/tma" .. context.zone.h .. ".png"
		ImageMax = Bitmap.open(imageFileMax)
	end
	return context
end

local function drawTempGauge(context)
	if context.zone.w == 390 then
		lcd.drawRectangle(context.zone.x, context.zone.y, context.zone.w, context.zone.h)
		lcd.drawBitmap(ImageMax, context.zone.w/2 + context.zone.x + 11, context.zone.y)
		lcd.drawBitmap(context.back, context.zone.x + 12, context.zone.y)
	else
		lcd.drawBitmap(context.back, context.zone.x, context.zone.y)
	end

	local value = getValue(context.options.TempA)
	TemperaturValueMax = getValue(context.options.TempB)

	if value == nil then return end

	local TemperaturValue = value

	if TemperaturValue > context.options.Max then
		TemperaturValue = context.options.Max
	elseif TemperaturValue < context.options.Min then
		TemperaturValue = context.options.Min
	end

	local degrees = 5.0 - (TemperaturValue / 50)

	local x1  = math.floor(context.zone.x + (context.zone.h/2)) + 12
	local y1  = math.floor(context.zone.y + (context.zone.h/2)) - 10
	local x2  = math.floor(context.zone.x + (context.zone.h/2) + (math.sin(degrees) * (context.zone.h/2.3))) + 12
	local y2  = math.floor(context.zone.y + (context.zone.h/2) + (math.cos(degrees) * (context.zone.h/2.3)))

	degrees = 5.0 - (TemperaturValueMax / 50)

	local x1a = math.floor(context.zone.w/2 + context.zone.h/2 + context.zone.x) + 11
	local y1a = math.floor(context.zone.y + (context.zone.h/2)) - 10
	local x2a = math.floor(context.zone.w/2 + context.zone.h/2 + context.zone.x + (math.sin(degrees) * (context.zone.h/2.3))) + 11
	local y2a = math.floor(context.zone.y + (context.zone.h/2) + (math.cos(degrees) * (context.zone.h/2.3)))

	-- Workaround RC8 horizontal line bug
	if y1 == y2 and x2 < x1 then
		x1, x2 = x2, x1
		y1, y2 = y2, y1
	end

	lcd.setColor(CUSTOM_COLOR, lcd.RGB(255, 255, 255))
	lcd.setColor(WARNING_COLOR, lcd.RGB(255, 0, 0))

	if context.zone.w == 390 then
		lcd.drawLine(x1-4, y1-1, x2,  y2-1, SOLID, CUSTOM_COLOR)
		lcd.drawLine(x1-3, y1-1, x2,  y2-1, SOLID, CUSTOM_COLOR)
		lcd.drawLine(x1-2, y1-1, x2,  y2-1, SOLID, CUSTOM_COLOR)
		lcd.drawLine(x1+2, y1+1, x2,  y2+1, SOLID, CUSTOM_COLOR)
		lcd.drawLine(x1+3, y1+1, x2,  y2+1, SOLID, CUSTOM_COLOR)
		lcd.drawLine(x1+4, y1+1, x2,  y2+1, SOLID, CUSTOM_COLOR)

		lcd.drawLine(x1a-4, y1a-1, x2a, y2a-1, SOLID, WARNING_COLOR)
		lcd.drawLine(x1a-3, y1a-1, x2a, y2a-1, SOLID, WARNING_COLOR)
		lcd.drawLine(x1a-2, y1a-1, x2a, y2a-1, SOLID, WARNING_COLOR)
		lcd.drawLine(x1a-1, y1a-1, x2a, y2a-1, SOLID, WARNING_COLOR)
		lcd.drawLine(x1a,   y1a,   x2a, y2a,   SOLID, WARNING_COLOR)
		lcd.drawLine(x1a+1, y1a+1, x2a, y2a+1, SOLID, WARNING_COLOR)
		lcd.drawLine(x1a+2, y1a+1, x2a, y2a+1, SOLID, WARNING_COLOR)
		lcd.drawLine(x1a+3, y1a+1, x2a, y2a+1, SOLID, WARNING_COLOR)
		lcd.drawLine(x1a+4, y1a+1, x2a, y2a+1, SOLID, WARNING_COLOR)
	end

	lcd.drawLine(x1-1, y1-1, x2, y2-1, SOLID, CUSTOM_COLOR)
	lcd.drawLine(x1,   y1,   x2, y2,   SOLID, CUSTOM_COLOR)
	lcd.drawLine(x1+1, y1+1, x2, y2+1, SOLID, CUSTOM_COLOR)

	local flags1 = RIGHT + TEXT_COLOR
	local flags2 = RIGHT + TEXT_BGCOLOR

	if context.zone.w < 100 then
		flags1 = flags1 + SMLSIZE
		flags2 = flags2 + SMLSIZE
	end

	if context.zone.w > context.zone.h * 1.6 or context.zone.h > 100 then
		lcd.drawSource(context.zone.x + context.zone.w/2 + 25, context.zone.y + 1,                context.options.TempA, flags1)
		lcd.drawSource(context.zone.x + context.zone.w/2 + 25, context.zone.y + context.zone.h - 20, context.options.TempB, flags2)
	end

	lcd.drawFilledRectangle(context.zone.w/2 + context.zone.h/2 + context.zone.x + 5, y1-6, 12, 12, CUSTOM_COLOR, 2)
	lcd.drawFilledRectangle(context.zone.x + (context.zone.h/2) + 6,                  y1-6, 12, 12, CUSTOM_COLOR, 2)

	if context.zone.w == 390 then
		lcd.drawNumber(context.zone.x + (context.zone.h/2) + 12 - (#tostring(TemperaturValue) * 10),                          context.zone.y + 90, TemperaturValue,    DBLSIZE + CUSTOM_COLOR)
		lcd.drawNumber(context.zone.w/2 + context.zone.h/2 + context.zone.x + 11 - (#tostring(TemperaturValueMax) * 10), context.zone.y + 90, TemperaturValueMax, DBLSIZE + CUSTOM_COLOR)
	end

	if context.zone.h == 70 then
		lcd.drawNumber(context.zone.x - 30 + context.zone.w / 4 - (#tostring(TemperaturValue) * 10), context.zone.y + 90, TemperaturValue, DBLSIZE + CUSTOM_COLOR)
	end
end

local function update(context, options)
	context.options = options
end

local function refresh(context)
	drawTempGauge(context)
end

local function reset(context)
	TemperaturValueMax = 0
end

return { name="TempGauge", options=options, create=create, update=update, refresh=refresh, reset=reset }
