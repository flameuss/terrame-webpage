-- @example Small example with spline.

import("sci")

-- relation btw
waterSurface = Spline {
	points = DataFrame{
		x = {0, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000},
		y = {0, 24.7, 35.3, 48.6, 54.3, 57.2, 61.6, 66.0, 69.9}
	},
	steps = 1
}

spline = Model{
	data      = 0.0,
	surface   = 0.0,
	finalTime = 80,

	init = function(model)
		model.chart = Chart{
			target = model,
			select = {"surface", "data"}
		}

		model.timer = Timer{
			Event{action = function(ev)
				local time = ev:getTime()
				model.surface = waterSurface:value (100 * time)
				model.data    = waterSurface:value (1000 * math.floor (time/10))
			end},
			Event{action = model.chart}
		}
	end
}

spline:run()

