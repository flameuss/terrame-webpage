-- @example Predator-Prey Oscillations on the Kaibab Plateau.
-- Ford, F. A. (1999). Modeling the environment: an introduction to system
-- dynamics models of environmental systems. Island Press.

import("sci")

local deerKilledPerPredatorPerYear = Spline{
	points = DataFrame{
		x = {0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 100},
		y = {0, 15, 25, 30, 35, 40, 45, 50, 55, 60, 60,  60}
	}
}

local deerNetBirthRate = Spline{
	points = DataFrame{
		x = { 0.3,  0.4, 0.5, 0.6, 0.7, 0.8,  0.9, 1.0},
		y = {-0.4, -0.2, 0.0, 0.2, 0.4, 0.45, 0.5, 0.5}
	}
}

local predatorsNetBirthRate = Spline{
	points = DataFrame{
		x = { 0.00, 10.00, 20.00, 30.00, 40.00, 50.00, 60.00, 70.00, 80.00},
		y = {-0.60, -0.45, -0.30, -0.15, 0.00,   0.15,  0.30,  0.40,  0.45}
	}
}

PredatorPreyFord = Model{
	deer = 4000, -- population of deer
	predator = 46, -- number of predators,
	finalTime = 1932,
	init = function(model)
		model.prey = function(self)
			return self.deer / 80
		end

		model.chart = Chart{
			target = model,
			select = {"predator", "prey"},
			title = "Predator and Prey Populations"
		}

		model.timer = Timer{
			Event{start = 1901, action = function()
				local deer_density = model.deer / 800
				local dkpppy = deerKilledPerPredatorPerYear:value(deer_density)

				local ffnm = 1 -- fraction forage need met

				model.deer = model.deer + model.deer * deerNetBirthRate:value(ffnm) - model.predator * dkpppy

				--  the density needs to be recomputed before updating the amount of predators
				deer_density = model.deer / 800
				dkpppy = deerKilledPerPredatorPerYear:value(deer_density)
				model.predator = model.predator + model.predator * predatorsNetBirthRate:value(dkpppy)

			end},
			Event{start = 1900, action = model.chart}
		}
	end
}

PredatorPreyFord:run()

