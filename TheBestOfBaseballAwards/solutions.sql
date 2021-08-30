SELECT * FROM people LIMIT 5;
SELECT * FROM batting LIMIT 5;
SELECT * FROM pitching LIMIT 5;
SELECT * FROM teams LIMIT 5;

-- HEAVIEST HITTERS:
-- This award goes to the team with the highest average weight of its batters on a given year.
SELECT t.name,  b.yearid, AVG(p.weight) as avg_weight
FROM batting as b
JOIN teams as t
	ON b.teamid = t.teamid
JOIN people as p
	ON b.playerid = p.playerid
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 1; -- This award goes to the 2009 Chicago White Sox (221.33 lbs)!!

-- SHORTEST SLUGGERS:
-- This award goes to the team with the smallest average height of its batters on a given year. 
-- This query should look very similar to the one you wrote to find the heaviest teams. 
SELECT t.name,  b.yearid, AVG(p.height) as avg_height
FROM batting as b
JOIN teams as t
	ON b.teamid = t.teamid
JOIN people as p
	ON b.playerid = p.playerid
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 1; -- This award goes to the 2006 Chicago White Sox (74.78 in)!!

-- BIGGEST SPENDERS:
-- This award goes to the team with the largest total salary of all players in a given year
SELECT t.name, t.yearid, SUM(s.salary) as total_salary
FROM teams as t
JOIN salaries as s
	ON t.teamid = s.teamid
  AND t.yearid = s.yearid
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 1; -- This award goes to the 2013 New York Yankees ($231,978,886)!!

-- MOST BANG FOR THEIR BUCK IN 2010:
-- This award goes to the team that had the smallest “cost per win” in 2010. Cost per win is 
-- determined by the total salary of the team divided by the number of wins in a given year. 
-- Note that we decided to look at just teams in 2010 because when we found this award looking 
-- across all years, we found that due to inflation, teams from the 1900s spent much less money 
-- per win. We thought that looking at all teams in just the year 2010 gave a more interesting statistic.
SELECT t.name, t.yearid, ROUND(SUM(s.salary) / t.w) as cost_per_win
FROM teams as t
JOIN salaries as s
	ON t.teamid = s.teamid
  AND t.yearid = s.yearid
WHERE t.yearid = 2010
GROUP BY 1, 2, t.w
ORDER BY 3 DESC
LIMIT 1; -- This award goes to the New York Yankees ($2,171,930 per win)!!

-- PRICIEST STARTER:
-- This award goes to the pitcher who, in a given year, cost the most money per game in which they were 
-- the starting pitcher. Note that many pitchers only started a single game, so to be eligible for this 
-- award, you had to start at least 10 games.
SELECT p.namegiven, t.yearid, s.salary, pit.gs, ROUND(s.salary / pit.gs) as cost_per_game_starting
FROM people as p
JOIN pitching as pit
	ON p.playerid = pit.playerid
JOIN salaries as s
	ON pit.playerid = s.playerid
  AND pit.yearid = s.yearid
JOIN teams as t
	ON s.teamid = t.teamid
  AND s.yearid = t.yearid
WHERE pit.gs >= 10
GROUP BY 1, 2, s.salary, pit.gs
ORDER BY 5 DESC
LIMIT 1; -- This award goes to Colbert Michael in 2015 ($1,958,333 per game started)!!

-- BEAN MACHINE:
-- This award goes to the pitcher most likely to hit a batter with a pitch
SELECT p.playerid, p.namegiven, SUM(pit.hbp) as total_beans
FROM people as p
JOIN pitching as pit
	ON p.playerid = pit.playerid
WHERE pit.hbp IS NOT NULL
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 1; -- This award goes to August (277 total beans)!!

-- CANADIAN ACE:
-- This award goes to the pitcher with the lowest ERA who played for a team whose
-- stadium is in Canada
SELECT p.playerid, p.namegiven, pit.era
FROM teams as t
JOIN pitching as pit
	ON t.teamid = pit.teamid
JOIN people as p
	ON pit.playerid = p.playerid
JOIN homegames as h
	ON pit.team_id = h.team_id
JOIN parks as pk
	ON h.parkkey = pk.parkkey
WHERE pk.country = 'CA'
	AND pit.era != 0
GROUP BY 1, 2, 3
ORDER BY pit.era ASC
LIMIT 1; -- The award goes to Joaquin Antonio (0.38)!!

-- THE WORST OF THE BEST: BATTING AVERAGE
-- This award goes to a batter in the Hall of Fame who has the lowest career
-- batting average.
SELECT p.playerid, p.namegiven, AVG(CAST(b.H AS REAL) / b.AB) as batting_avg_career
FROM people as p
JOIN batting as b
	ON p.playerid = b.playerid
JOIN halloffame as h
	ON b.playerid = h.playerid
WHERE b.AB > 0
	AND h.inducted = 'Y'
GROUP BY 1, 2
HAVING AVG(CAST(b.H AS REAL) / b.AB) > 0
ORDER BY 3
LIMIT 1; -- THe award goes to Thomas Charles (0.038)!!
  
-- THE WORST OF THE BEST: RUNS ALLOWED
-- This award goes to a pitcher in the Hall of Fame who has the most runs allowed.
SELECT p.playerid, p.namegiven, SUM(pit.R) as total_runs_allowed
FROM people as p
JOIN pitching as pit
	ON p.playerid = pit.playerid
JOIN halloffame as h
	ON pit.playerid = h.playerid
WHERE h.inducted = 'Y'
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 1; -- The award goes to James Francis(3352)!!


