-- Horus full screen 480 x 272
-- Zone sizes WxH(wo menu / w menu):
-- 2x4 = 160x32
-- 2x2 = 225x122/98
-- 2x1 = 225x252/207
-- 2+1 = 192x152 & 180x70
-- 1x1 = 460/390x252/217/172
--       w390 x h172
--Heights: 32,70,98,122,172,207,217,252

local offset = 73

local options = {
	{ "RPM", SOURCE, 1 },
	{ "Min", VALUE, 0 },
	{ "Max", VALUE, 15000 }
}

local function create(zone, options)
	local context = { zone=zone, options=options }
	local RPMimageFile = "/WIDGETS/RPM/RPMd172b.png"
	context.hRPM = Bitmap.open(RPMimageFile)
	return context
end

local function drawRPMGauge(context)
	if context.zone.w == 390 then
		lcd.drawRectangle(context.zone.x, context.zone.y, context.zone.w, context.zone.h)
		lcd.drawBitmap(context.hRPM, context.zone.x, context.zone.y)
	end

	local RPMValue = getValue(context.options.RPM)
	if RPMValue == nil then return end  -- fix: was checking wrong variable

	if RPMValue > context.options.Max then
		RPMValue = context.options.Max
	elseif RPMValue < context.options.Min then
		RPMValue = context.options.Min
	end

	local degrees = ((10000.0 - RPMValue) / 1000.0) * 29.5

	local Pi = math.pi
	local x1 = math.floor(167 + offset)
	local y1 = math.floor(134)
	local x2 = math.floor(167 + offset + (math.sin(degrees / 180 * Pi) * 60))
	local y2 = math.floor(134 + (math.cos(degrees / 180 * Pi) * 60))

	-- Workaround RC8 horizontal line bug
	if y1 == y2 and x2 < x1 then
		x1, x2 = x2, x1
		y1, y2 = y2, y1
	end

	lcd.setColor(CUSTOM_COLOR, lcd.RGB(255, 255, 255))
	lcd.setColor(WARNING_COLOR, lcd.RGB(255, 0, 0))

	if context.zone.w == 390 then
		lcd.drawLine(x1-4, y1-1, x2, y2-1, SOLID, CUSTOM_COLOR)
		lcd.drawLine(x1-3, y1-1, x2, y2-1, SOLID, CUSTOM_COLOR)
		lcd.drawLine(x1-2, y1-1, x2, y2-1, SOLID, CUSTOM_COLOR)
		lcd.drawLine(x1+2, y1+1, x2, y2+1, SOLID, CUSTOM_COLOR)
		lcd.drawLine(x1+3, y1+1, x2, y2+1, SOLID, CUSTOM_COLOR)
		lcd.drawLine(x1+4, y1+1, x2, y2+1, SOLID, CUSTOM_COLOR)
		lcd.drawLine(x1-1, y1-1, x2, y2-1, SOLID, CUSTOM_COLOR)
		lcd.drawLine(x1,   y1,   x2, y2,   SOLID, CUSTOM_COLOR)
		lcd.drawLine(x1+1, y1+1, x2, y2+1, SOLID, CUSTOM_COLOR)
	end

	local flags1 = RIGHT + TEXT_COLOR

	if context.zone.w == 390 then
		lcd.drawSource(340 + offset, 70, context.options.RPM, flags1)
		lcd.drawFilledRectangle(163 - 1 + offset, 130, 12, 12, CUSTOM_COLOR, 2)
		lcd.drawNumber(context.zone.x + offset + (context.zone.h/2) + 7 - (#tostring(RPMValue) * 13), 180, RPMValue, DBLSIZE + CUSTOM_COLOR)
	end

	if context.zone.h == 70 then
		lcd.drawNumber(context.zone.x + offset - 30 + context.zone.w / 4 - (#tostring(RPMValue) * 10), context.zone.y + 90, RPMValue, DBLSIZE + CUSTOM_COLOR)
	end
end

local function update(context, options)
	context.options = options
end

local function refresh(context)
	drawRPMGauge(context)
end

return { name="RPMGauge", options=options, create=create, update=update, refresh=refresh }
