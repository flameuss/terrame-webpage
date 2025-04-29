
-- @example Running the disease model varying the probability of infecting
-- a connection from 0.05 to 1.

import("logo")
import("calibration")

mr = MultipleRuns{
	model = Disease,
	showProgress = false,
	parameters = {
		probability = Choice{min = 0.05, max = 1, step = 0.05},
	},
}

chart = Chart{
	target = mr.output,
	select = {"susceptible", "infected", "recovered"}, -- as default it should be the "output"
	xAxis = "probability" -- as default it should be the only parameter (if only one) - "probability"
}

