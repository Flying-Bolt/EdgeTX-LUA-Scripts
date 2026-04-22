-- Horus full screen 480 x 272
-- Zone sizes WxH(wo menu / w menu):
-- 2x4 = 160x32
-- 2x2 = 225x122/98
-- 2x1 = 225x252/207
-- 2+1 = 192x152 & 180x70
-- 1x1 = 460/390x252/217/172
--       w390 x h172
--Heights: 32,70,98,122,172,207,217,252

local options = {
	{ "Voltage", SOURCE, 1 },
	{ "Ampere", SOURCE, 1 },
	{ "Min", VALUE, 0 },
	{ "Max", VALUE, 15000 }
}

local function create(zone, options)
	local context = { zone=zone, options=options }
	local VAimageFile = "/WIDGETS/VAMeter/VAMetterII.png"
	context.hVA = Bitmap.open(VAimageFile)
	return context
end

local function round(num, decimals)
	local mult = 10^(decimals)
	return math.floor(num * mult + 0.5) / mult
end

local function drawVAGauge(context)
	local xoffset = 1
	if context.zone.w == 390 then
		lcd.drawRectangle(context.zone.x, context.zone.y, context.zone.w, context.zone.h)
		lcd.drawBitmap(context.hVA, context.zone.x + 12, context.zone.y)
	end

	local Vvalue = getValue(context.options.Voltage)
	if Vvalue == nil then return end

	local Avalue = getValue(context.options.Ampere)
	if Avalue == nil then return end

	if Vvalue > context.options.Max then
		Vvalue = context.options.Max
	elseif Vvalue < context.options.Min then
		Vvalue = context.options.Min
	end
	if Avalue > context.options.Max then
		Avalue = context.options.Max
	elseif Avalue < context.options.Min then
		Avalue = context.options.Min
	end

	local Pi = math.pi

	Avalue = Avalue / 10.0

	local degrees = 270.5 - 90 * Avalue / 9

	local x1  = math.floor(244 + xoffset)
	local y1  = math.floor(172)
	local x2  = math.floor(244 + xoffset + (math.sin(degrees / 180 * Pi) * 88))
	local y2  = math.floor(172 + (math.cos(degrees / 180 * Pi) * 88))

	degrees = 90 + 90 * Vvalue / 18

	local x1a = math.floor(256 + xoffset)
	local y1a = math.floor(172)
	local x2a = math.floor(256 + xoffset + (math.sin(degrees / 180 * Pi) * 88))
	local y2a = math.floor(172 + (math.cos(degrees / 180 * Pi) * 88))

	-- Workaround RC8 horizontal line bug
	if y1 == y2 and x2 < x1 then
		x1, x2 = x2, x1
		y1, y2 = y2, y1
	end
	if y1a == y2a and x2a < x1a then
		x1a, x2a = x2a, x1a
		y1a, y2a = y2a, y1a
	end

	lcd.setColor(CUSTOM_COLOR,      lcd.RGB(255, 255, 255))
	lcd.setColor(TEXT_DISABLE_COLOR, lcd.RGB(150, 150, 150))
	lcd.setColor(WARNING_COLOR,     lcd.RGB(255, 255, 255))

	if context.zone.w == 390 then
		lcd.drawLine(x1-4, y1-1, x2,  y2-1, SOLID, CUSTOM_COLOR)
		lcd.drawLine(x1-3, y1-1, x2,  y2-1, SOLID, CUSTOM_COLOR)
		lcd.drawLine(x1-2, y1-1, x2,  y2-1, SOLID, CUSTOM_COLOR)
		lcd.drawLine(x1+2, y1+1, x2,  y2+1, SOLID, CUSTOM_COLOR)
		lcd.drawLine(x1+3, y1+1, x2,  y2+1, SOLID, CUSTOM_COLOR)
		lcd.drawLine(x1+4, y1+1, x2,  y2+1, SOLID, CUSTOM_COLOR)
		lcd.drawLine(x1-1, y1-1, x2,  y2-1, SOLID, CUSTOM_COLOR)
		lcd.drawLine(x1,   y1,   x2,  y2,   SOLID, CUSTOM_COLOR)
		lcd.drawLine(x1+1, y1+1, x2,  y2+1, SOLID, CUSTOM_COLOR)

		lcd.drawLine(x1a-4, y1a-1, x2a, y2a-1, SOLID, WARNING_COLOR)
		lcd.drawLine(x1a-3, y1a-1, x2a, y2a-1, SOLID, WARNING_COLOR)
		lcd.drawLine(x1a-2, y1a-1, x2a, y2a-1, SOLID, WARNING_COLOR)
		lcd.drawLine(x1a+2, y1a+1, x2a, y2a+1, SOLID, WARNING_COLOR)
		lcd.drawLine(x1a+3, y1a+1, x2a, y2a+1, SOLID, WARNING_COLOR)
		lcd.drawLine(x1a+4, y1a+1, x2a, y2a+1, SOLID, WARNING_COLOR)
		lcd.drawLine(x1a-1, y1a-1, x2a, y2a-1, SOLID, WARNING_COLOR)
		lcd.drawLine(x1a,   y1a,   x2a, y2a,   SOLID, WARNING_COLOR)
		lcd.drawLine(x1a+1, y1a+1, x2a, y2a+1, SOLID, WARNING_COLOR)
	end

	if context.zone.w == 390 then
		lcd.drawFilledRectangle(244 + xoffset - 6, 172 - 6, 12, 12, CUSTOM_COLOR,  2)
		lcd.drawFilledRectangle(256 + xoffset - 6, 172 - 6, 12, 12, WARNING_COLOR, 2)
		lcd.drawText(310 - #tostring(Vvalue) + xoffset, 184, round(Vvalue, 1) .. "V", DBLSIZE + WARNING_COLOR)
		lcd.drawText(130 - #tostring(Avalue) + xoffset, 184, round(Avalue, 2) .. "A", DBLSIZE + WARNING_COLOR)
	end
end

local function update(context, options)
	context.options = options
end

local function refresh(context)
	drawVAGauge(context)
end

return { name="VAGauge", options=options, create=create, update=update, refresh=refresh }
