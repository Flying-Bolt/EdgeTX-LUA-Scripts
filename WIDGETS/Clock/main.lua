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
	{ "TimerOne", SOURCE, 1 },
	{ "TimerTwo", SOURCE, 1 },
	{ "Min", VALUE, 0 },
	{ "Max", VALUE, 15000 }
}

local function create(zone, options)
	local context = { zone=zone, options=options }
	local ClockimageFile = "/WIDGETS/Clock/ClocksA172.png"
	context.hClock = Bitmap.open(ClockimageFile)
	return context
end

local function drawClocks(context)
	if context.zone.w == 390 then
		lcd.drawRectangle(context.zone.x, context.zone.y, context.zone.w, context.zone.h)
		lcd.drawBitmap(context.hClock, context.zone.x, context.zone.y)
	end

	lcd.setColor(CUSTOM_COLOR, lcd.RGB(255,255,255))
	lcd.setColor(TEXT_DISABLE_COLOR, lcd.RGB(150,150,150))
	lcd.setColor(WARNING_COLOR, lcd.RGB(255,255,255))

	local myTMR1 = getValue(context.options.TimerOne)
	if myTMR1 == nil then return end

	local myTMR2 = getValue(context.options.TimerTwo)
	if myTMR2 == nil then return end

	if context.zone.w == 390 then
		lcd.drawSource(65, 210, context.options.TimerOne, RIGHT + TEXT_DISABLE_COLOR + SMLSIZE)
		lcd.drawSource(442, 210, context.options.TimerTwo, RIGHT + TEXT_DISABLE_COLOR + SMLSIZE)

		lcd.drawText(105, 150, "FLIGHT", MIDSIZE + TEXT_DISABLE_COLOR)
		lcd.drawText(315, 150, "ON", MIDSIZE + TEXT_DISABLE_COLOR)

		lcd.drawTimer(105, 110, myTMR1, DBLSIZE + CUSTOM_COLOR)
		lcd.drawTimer(290, 110, myTMR2, DBLSIZE + CUSTOM_COLOR)
	end
end

local function update(context, options)
	context.options = options
end

local function refresh(context)
	drawClocks(context)
end

return { name="Clocks", options=options, create=create, update=update, refresh=refresh }
