-- View that adds descriptive columns to the penalties table:
-- classifies each kick by result (goal/miss),
-- type (elimination/no elimination),
-- and accuracy (on/off target).

CREATE OR REPLACE VIEW penalties_view AS
SELECT *,
       CASE WHEN goal = 1 THEN 'goal' ELSE 'miss' END AS score,
       CASE WHEN elimination = 1 THEN 'elimination kick' ELSE 'no elimination' END AS elimination_kick,
       CASE WHEN ontarget = 1 THEN 'on target' ELSE 'off target' END AS on_target
FROM penalties;

-------------------------------------------------------------------------------------------------------

-- Query that calculates each team's goal success rate (%)
-- defined as goals divided by shots on target, sorted highest to lowest.

SELECT 
  Team,
  ROUND(SUM(Goal)::decimal / NULLIF(SUM(OnTarget), 0) * 100, 2) AS team_goal_success
FROM penalties
GROUP BY Team
ORDER BY team_goal_success DESC;

-------------------------------------------------------------------------------------------------------

-- Query that counts penalties by kick direction and ball height (zone),
-- showing the most frequent combinations first.

SELECT 
  Kick_Direction,
  Ball_Height,
  COUNT(*) AS total
FROM penalties
GROUP BY Kick_Direction, Ball_Height
ORDER BY total DESC;

-------------------------------------------------------------------------------------------------------

-- Query that compares footedness (left/right) in penalties:
-- shows total kicks, total goals, and goal success rate (%).

SELECT 
  foot,
  COUNT(*) AS total_kicks,
  SUM(Goal) AS total_goals,
  ROUND(SUM(Goal)::decimal / NULLIF(COUNT(*), 0) * 100, 2) AS success_rate
FROM penalties
GROUP BY Foot;

-------------------------------------------------------------------------------------------------------

-- Query that returns the first missed penalty in each game
-- using DISTINCT ON with Game_id and Penalty_Number.

SELECT DISTINCT ON (Game_id)
  Game_id, 
  Penalty_Number,
  Team, 
  score
FROM penalties_view
WHERE Goal = 0
ORDER BY Game_id, Penalty_Number ASC;

