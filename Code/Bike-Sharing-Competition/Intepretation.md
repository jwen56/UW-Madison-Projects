In constructing a predictive model for the number of bicycle rentals, we selected a range of factors, each chosen for its potential impact on rental behavior. These factors cover everything from temporal elements, to environmental conditions, to more complex interactions between these variables.

**Time Factors**

Hour (hour): Includes its direct effect and transformations (such as sine sin_hour, cosine cos_hour transformations, quadratic I(hour^2), cubic I(hour^3), quartic I(hour^4) terms, and logarithmic transformation log(hour + 1)), capturing the cyclical and nonlinear relationship with daily rental activity.
Hour Grouping (hour_group): Divides the day into "morning", "afternoon", "evening", and "night" to refine the rental demand in different time slots.
Day Number (daynum): Tracks long-term trends, reflecting how rental patterns evolve over time.

**Environmental Conditions**

Feels-like Temperature (atemp) and Humidity (humidity): Directly measure weather comfort, influencing the likelihood of renting a bike.
Season (seasonname) and Weather Conditions (weathername): Consider the impact of seasonal changes and various weather conditions on rental counts, indicating that certain seasons and weather types are more conducive to cycling.
Note: monthname was excluded from the model in favor of seasonname to better capture broad climatic phases and avoid unnecessary complexity introduced by month-by-month analysis.

**Interactions Between Variables**

Temperature and Time (hour*atemp): Explore how temperature affect rental counts at different times of the day.
Working Day and Temperature (workingday*atemp), Working Day and Humidity (workingday*humidity): Distinguish the rental behavior on working days and non-working days under different weather conditions.
More Complex Interactions (e.g., hour*atemp*humidity): Capture the complex interplay between time, weather, and human behavior in determining rental demand.

**Key Data Processing Step**

Elimination of Negative Rental Counts: Ensures the logical integrity of the dataset since rental counts cannot be negative.
