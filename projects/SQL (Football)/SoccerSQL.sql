-- EURO 2016
-- (SOCCER_DB Database)
-- 1. Business scenario Q1
-- Stadium Analysis
-- As a sports event organiser planning the next major soccer tournament, you're benchmarking
-- against the EURO cup 2016 to gauge logistical scale and preparations.
-- How many unique stadiums were used in the EURO cup 2016?

WITH cte_venue AS (
    SELECT COUNT(DISTINCT mm.venue_id) AS count_unique_stadiums
    FROM match_mast mm
    LEFT JOIN soccer_venue sv ON sv.venue_id = mm.venue_id
), cte_nums_of_games_each_stadium AS (
    SELECT sv.venue_name,
        COUNT(sv.venue_name) AS count_each_stadiums
    FROM match_mast mm
    LEFT JOIN soccer_venue sv ON sv.venue_id = mm.venue_id
    GROUP BY sv.venue_name
)


SELECT *
FROM cte_venue;



-- 2. Business scenario Q2
-- Targeted Sports Marketing
-- As a sports marketing consultant, a top sports brand seeks your expertise for a campaign
-- targeting countries from the EURO cup 2016 to promote a new soccer merchandise line.
-- How many unique countries participated in the EURO cup 2016?

SELECT COUNT(DISTINCT country_name) AS unique_countries_at_euro
FROM soccer_country;



-- 3. Business scenario Q3
-- Analysis of On-Time Thrills: Goals Scored within 90 Minutes
-- As a sports analyst for a broadcasting company, you're sourcing data for a feature on the
-- EURO cup 2016's thrilling goals scored during regular playtime.
-- How many goals were scored within the standard 90-minute play during the EURO cup 2016?


WITH cte_scenario3 AS (
    SELECT CASE WHEN goal_time > 90 THEN '>90min_goal' ELSE '<90min_goal' END AS goal_time
    FROM goal_details
)

SELECT goal_time,
       COUNT(goal_time) AS cnt_goal
FROM cte_scenario3
GROUP BY goal_time;



-- 4. Business scenario Q4
-- Decisive Outcomes Analysis for Promotional Campaigns
-- As a data analyst for a sports betting firm, you're extracting insights for promotional campaigns,
-- focusing on matches with definitive outcomes to predict high engagement.
-- How many matches from the EURO cup 2016 had a decisive winner?


SELECT COUNT(*) AS cnt_decisive_winner
FROM match_details
WHERE win_lose = 'W';



-- 5. Business scenario Q5
-- Clear Winners and Match Views
-- As a strategist for a sports streaming platform, you're optimising the content library, noting that
-- match highlights with clear winners garner more views.
-- From the EURO cup 2016, how many matches ended in a draw?


SELECT COUNT(*) / 2  AS cnt_decisive_winner
FROM match_details
WHERE win_lose = 'D';



-- 6. Business scenario Q6
-- EURO 2016 Kick-off Date
-- Imagine you are a project manager at a digital marketing agency. A major sportswear brand
-- approaches your agency to create a retrospective digital campaign celebrating the 10th
-- anniversary of the EURO cup 2016. To anchor the campaign's timeline and build anticipation,
-- the brand wants to highlight key moments starting from the very first day of the tournament.
-- Based on historical records, on which date did the EURO cup 2016 officially kick off? This
-- information will serve as the starting point for the digital campaign's timeline and narrative.


SELECT TOP 1 play_date AS start_date
FROM match_mast
ORDER BY  play_date;



-- 7. Business scenario Q7
-- Analysis of Own Goals
-- Imagine you are a sports journalist preparing a feature article on unexpected moments in
-- soccer history. Own goals, being rare and often game-changing, are of particular interest. As
-- part of this feature, you're focusing on major tournaments like the EURO cup 2016 to highlight
-- the frequency and impact of such moments.
-- Based on the records from the EURO cup 2016, how many own goals were unintentionally
-- scored by players into their team's net? This data will provide insights into the unpredictability
-- of the sport and serve as a key highlight for your article.


SELECT COUNT(*) AS cnt_own_goal
FROM goal_details
WHERE goal_type = 'O';


-- 8. Business scenario Q8
-- Decisive Group Stage Matches
-- As a sports data analyst at a TV network, you're assessing high-stakes group stage matches
-- to optimize future broadcasting schedules.
-- From the EURO cup 2016, how many group stage matches had a decisive winner?


SELECT COUNT(*) AS cnt_decisive_winner
FROM match_details
WHERE win_lose = 'W' AND
    play_stage = 'G';


-- 9. Business scenario Q9
-- Analysis of Penalty Shootouts
-- As a content director at a sports platform, you're curating a compilation of gripping penalty
-- shootouts from the EURO cup 2016. How many matches in the EURO cup 2016 concluded in
-- a penalty shootout?

SELECT COUNT(*) AS cnt_penalties
FROM match_mast
WHERE decided_by = 'P';


-- 10.Business scenario Q10
-- Analysis of Round of 16 Penalties
-- As a sports commentator, you're researching intense moments from the EURO cup 2016's
-- Round of 16 stage, particularly penalty shootouts. How many Round of 16 matches in the
-- EURO cup 2016 were decided by penalties?

SELECT COUNT(*) AS cnt_penalties
FROM match_mast
WHERE decided_by = 'P'
AND play_stage = 'R';



-- 11. Business scenario Q11
-- Analysis of Regular Play Goals
-- Collaborating with a mobile app developer creating a soccer trivia game, you're sourcing data
-- on goals scored during regular play in the EURO cup 2016. How many goals were scored
-- within the standard 90-minute play for each match in the EURO cup 2016?

SELECT mm.match_no,
       COALESCE(gd.goals_within_90_minute, 0) AS goals_within_90_minute
FROM match_mast mm
LEFT JOIN (
    SELECT match_no, COUNT(goal_time) AS goals_within_90_minute
    FROM goal_details
    WHERE goal_time <= 90
    GROUP BY match_no
) gd ON mm.match_no = gd.match_no;


-- 12. Business scenario Q12
-- Matches Without First-Half Stoppage
-- Assisting a soccer coach, you're analysing matches from the EURO cup 2016 where the first
-- half had no stoppage time. Which matches had no first-half stoppage time, and how many
-- goals were scored during their regular play?

WITH cte_goals_per_match AS (
    SELECT match_no,
           COUNT(match_no) AS cnt_goals
    FROM goal_details
    GROUP BY match_no
)

SELECT mm.match_no,
       COALESCE(cnt_goals, 0) AS total_goals
FROM match_mast mm
LEFT JOIN cte_goals_per_match gd ON mm.match_no = gd.match_no
WHERE stop1_sec < 60;


-- 13. Business scenario Q13
-- Goalless Group Stage Matches
-- For a startup focusing on soccer betting, you're extracting data on goalless draws during group
-- stages from the EURO cup 2016. How many groups stage matches in the EURO cup 2016
-- ended in a goalless draw?

WITH cte_goals_per_match AS (
    SELECT match_no,
           COUNT(match_no) AS cnt_goals
    FROM goal_details
    GROUP BY match_no
)

SELECT *
FROM match_mast mm
LEFT JOIN cte_goals_per_match gd ON mm.match_no = gd.match_no
WHERE play_stage = 'G'
AND results = 'DRAW' AND
    cnt_goals IS NULL;


-- 14.Business scenario Q14
-- Narrow Victories
-- Crafting a "Narrow Victories" series, you're identifying matches from the EURO cup 2016
-- where a team won by just one goal, excluding penalty shootouts. How many matches ended
-- with a one-goal margin, excluding those decided by penalties?


SELECT COUNT(*) AS ended_with_one_goal_margin
FROM match_details md1
JOIN match_details md2 ON md1.match_no = md2.match_no
WHERE md1.decided_by <> 'P'
AND md1.ID <> md2.ID
AND md1.goal_score = md2.goal_score - 1;



-- 15. Business scenario Q15
-- Analysis of Total Substitutions
-- Analysing player fatigue for a national team's EURO cup preparation, you're examining
-- substitution data from the EURO cup 2016. How many player substitutions occurred
-- throughout the EURO cup 2016?

SELECT COUNT(*) AS total_substitutions
FROM player_in_out
WHERE in_out = 'I';



-- 16.Business scenario Q16
-- Regular Play Substitutions
-- For a football club prepping for the EURO cup, you're analysing substitution patterns during
-- regular playtime from the EURO cup 2016. How many player substitutions occurred within the
-- standard 90-minute play in the EURO cup 2016?


SELECT COUNT(*) AS total_substitutions_standard_90_minute_play
FROM player_in_out
WHERE in_out = 'I'
AND play_schedule = 'NT';


-- 17. Business scenario Q17
-- Stoppage Time Substitutions
-- Studying player management during high-pressure moments, you're extracting data on
-- substitutions made during stoppage time from the EURO cup 2016. How many player
-- substitutions took place during stoppage time in the EURO cup 2016?


SELECT COUNT(*) AS total_substitutions_stoppage_time
FROM player_in_out
WHERE in_out = 'I'
AND play_schedule = 'ST';


-- 18. Business scenario Q18
-- Analysing First-Half Substitution Patterns
-- For a national football team's strategy formulation, you're analysing first-half substitution
-- patterns from the EURO cup 2016. How many player substitutions were made during the first
-- half of matches in the EURO cup 2016?


SELECT COUNT(*) AS total_substitutions_first_half
FROM player_in_out
WHERE in_out = 'I'
AND time_in_out < 45
AND play_schedule = 'NT';


-- 19.Business scenario Q19
-- Goalless Draws
-- Supporting a media agency's documentary, you're highlighting defensive skills by analysing
-- goalless draws in the EURO cup 2016. How many matches in the EURO cup 2016 ended in
-- a goalless draw?


SELECT COUNT(*) / 2 AS cnt_matches_ended_with_0_goals
FROM match_details md1
JOIN match_details md2 ON md1.match_no = md2.match_no
WHERE md1.decided_by <> 'P'
AND md1.ID <> md2.ID
AND md1.goal_score = md2.goal_score
AND md1.goal_score = 0;


-- 20. Business scenario Q20
-- Extra Time Substitutions
-- Studying player fatigue during extended playtimes for the next EURO cup, you're examining
-- extra time substitutions from the EURO cup 2016. How many player substitutions occurred
-- during extra time in the EURO cup 2016?


SELECT COUNT(*) AS total_substitutions_first_half
FROM player_in_out
WHERE in_out = 'I'
AND play_schedule = 'ET';


-- 21. Business scenario Q21
-- Substitution Breakdown by Stage
-- Aiding a football team's EURO cup preparation, you're breaking down when substitutions
-- occurred during the EURO cup 2016. Provide a breakdown of player substitutions by play
-- stage from the EURO cup 2016.



WITH cnt_substitutions AS (
    SELECT match_no,
           COUNT(match_no) AS total_substitutions_per_amtch
    FROM player_in_out
    WHERE in_out = 'I'
    GROUP BY match_no
), final_t AS (
    SELECT cs.match_no,
           play_stage,
           total_substitutions_per_amtch
    FROM match_mast mm
    JOIN cnt_substitutions cs ON mm.match_no = cs.match_no
)

SELECT play_stage,
       SUM(total_substitutions_per_amtch) AS total_subs_per_stage
FROM final_t
GROUP BY play_stage
ORDER BY total_subs_per_stage ASC;



-- 22. Business scenario Q22
-- Spot-kick Shots
-- Preparing goalkeepers for potential penalty shootouts, you're analysing penalty shots taken
-- during the EURO cup 2016. How many shots were taken during penalty shootouts in the
-- EURO cup 2016?

SELECT COUNT(*) AS total_shots_in_euro
FROM penalty_shootout;


-- 23.Business scenario Q23
-- Successful Penalty Shots
-- Training goalkeepers, you're studying the success rate of penalty takers from the EURO cup
-- 2016. How many penalty shots during shootouts resulted in goals in the EURO cup 2016?


SELECT COUNT(*) AS total_goals_score_penalty_euro
FROM penalty_shootout
WHERE score_goal = 'Y';


-- 24. Business scenario Q24
-- Missed or Saved Penalty Shots
-- For a football club's EURO cup preparation, you're extracting data on missed or saved penalty
-- shots from the EURO cup 2016. How many penalty shots were either missed or saved by the
-- goalkeeper during the EURO cup 2016 shootouts?


SELECT COUNT(*) AS total_goals_score_penalty_euro
FROM penalty_shootout
WHERE score_goal = 'N';


-- 25. Business scenario Q25
-- Players in Penalty Shootouts
-- To inform potential shootout strategies, you're reviewing which players took penalty shots
-- during the EURO cup 2016. List players and their respective countries, showcasing the
-- number of shots each took during the EURO cup 2016 shootouts.


SELECT pm.player_name,
        sc.country_name,
        COUNT(*) OVER(PARTITION BY pm.player_name) AS total_goals_score_penalty
FROM penalty_shootout ps
JOIN soccer_country sc ON ps.team_id = sc.country_id
LEFT JOIN player_mast pm ON pm.player_id = ps.player_id



-- 26. Business scenario Q26
-- Analysing Team-wise Penalty Frequencies
-- As the tactical analyst for a football federation, you are reviewing past tournaments to
-- strategize for upcoming matches. Understanding the penalty-taking frequency of different
-- teams from the EURO cup 2016 can provide insights into their potential strategies and key
-- players. From the EURO cup 2016 data, how many penalty shots did each team take during
-- shootouts?

WITH cte_penalty_shootout AS (
    SELECT *,
           CASE WHEN score_goal = 'Y' THEN 1 ELSE 0 END AS scr_goal
    FROM penalty_shootout
)
-- SELECT *
-- FROM cte_penalty_shootout

SELECT sc.country_name,
        COUNT(*) AS total_penalty_country_take,
        SUM(scr_goal) AS total_goals_country
FROM cte_penalty_shootout cps
JOIN soccer_country sc ON cps.team_id = sc.country_id
GROUP BY sc.country_name;



-- 27.Business scenario Q27
-- Bookings by Half
-- You are a team manager preparing for an upcoming football tournament. In order to strategize
-- effectively and anticipate potential game disruptions, you want to understand the pattern of
-- bookings from a recent tournament, the EURO cup 2016.
-- From the EURO cup 2016 data, how many bookings occurred in each half of play?


SELECT play_half,
       COUNT(*) AS booking_per_half
FROM player_booked
WHERE play_schedule = 'NT'
GROUP BY play_half;




-- 28. Business scenario Q28
-- Stoppage Time Bookings
-- As a football analyst preparing for an upcoming match, you want to understand the frequency
-- of bookings during critical moments, particularly during stoppage time, based on data from the
-- EURO cup 2016.
-- How many bookings occurred during stoppage time in the EURO cup 2016?


SELECT COUNT(*) AS total_booking_in_stoppage_time
FROM player_booked
WHERE play_schedule = 'ST';




-- 29. Business scenario Q29
-- Extra Time Bookings
-- As a football coach preparing for an extended play scenario in a knockout match, you're
-- reviewing historical data from the EURO cup 2016 to understand player discipline during highpressure moments.
-- How many bookings took place during extra time in the EURO cup 2016?


SELECT COUNT(*) AS total_booking_in_extra_time
FROM player_booked
WHERE play_schedule = 'ET';


-- 30. Business scenario Q30
-- Team Performance Analysis
-- As a sports journalist, you're preparing an article on teams with the most goals in the EURO
-- cup 2016. This data will help you highlight the top-performing teams in terms of goal-scoring
-- capability. Retrieve the top 5 teams with the most goals scored during the EURO cup 2016.


SELECT TOP 5
    sc.country_name,
    COUNT(*) AS total_goals_team
FROM goal_details gd
LEFT JOIN soccer_country sc ON sc.country_id = gd.team_id
WHERE goal_type <> 'P'
GROUP BY sc.country_name
ORDER BY total_goals_team DESC;




-- 31. Business scenario Q31
-- Player Discipline Analysis
-- As a club scout, you're interested in signing new players. However, you want to ensure you're
-- recruiting disciplined players. You decide to analyse the players with the most bookings
-- (yellow/red cards) during the EURO cup 2016. List players with more than one booking during
-- the EURO cup 2016.

WITH cte_booking_player AS (
SELECT pm.player_name,
       COUNT(*) OVER(PARTITION BY player_name) AS cnt_booking
FROM player_booked pb
LEFT JOIN player_mast pm ON pm.player_id = pb.player_id
)
SELECT *
FROM cte_booking_player
WHERE cnt_booking > 1;



-- 32.Business scenario Q32
-- Coach Performance Analysis
-- As the director of a football academy, you're planning to invite successful coaches from the
-- EURO cup 2016 for a seminar. You're interested in coaches whose teams scored the most
-- goals. Identify coaches whose teams were among the top 5 in terms of goals scored during
-- the EURO cup 2016.


SELECT TOP 5
    cm.coach_name,
    COUNT(*) AS total_goals_team
FROM goal_details gd
LEFT JOIN soccer_country sc ON sc.country_id = gd.team_id
LEFT JOIN dbo.Team_coaches tc ON gd.team_id = tc.team_id
LEFT JOIN coach_mast cm ON  cm.coach_id = tc.coach_id
WHERE goal_type <> 'P'
GROUP BY cm.coach_name
ORDER BY total_goals_team DESC;



-- 33.Business scenario Q33
-- Analysing Venue Utilisation
-- As an event organizer, you're benchmarking venue utilization for a future event. You decide to
-- check which venues hosted the most matches during the EURO cup 2016. List soccer venues
-- by the number of matches they hosted during the EURO cup 2016.


SELECT sv.venue_name,
       COUNT(*) AS cnt_matches_on_stadium
FROM match_mast mm
LEFT JOIN soccer_venue sv ON sv.venue_id = mm.venue_id
GROUP BY sv.venue_name
ORDER BY cnt_matches_on_stadium DESC;



-- 34. Business scenario Q34
-- Analysing Average Substitution Patterns
-- As a sports analyst, you're studying player fatigue and its impact on match performance. You
-- decide to analyse the average number of substitutions made by teams during the second half
-- of the matches in the EURO cup 2016. Calculate the average number of substitutions made
-- by teams during the second half of matches in the EURO cup 2016.

WITH cte_team_booking AS (
    SELECT team_id,
           COUNT(*) AS cnt
    FROM player_booked
    WHERE play_schedule = 'NT'
    AND play_half = '2'
    GROUP BY team_id
)

SELECT AVG(cnt) AS average_booking_team_in_euro2016
FROM cte_team_booking;



-- 35.Business scenario Q35
-- Penalty Analysis
-- As a goalkeeping coach, you're preparing your goalkeepers for potential penalty shootouts.
-- You decide to study the teams that had the most successful penalties during the EURO cup
-- 2016. Identify the top 3 teams with the highest successful penalty conversion rates during the
-- EURO cup 2016.

WITH cte_pen_goal AS (
    SELECT sc.country_name,
           CASE WHEN ps.score_goal = 'Y' THEN 1 ELSE 0 END AS scr_goal,
           COUNT(*) OVER (PARTITION BY ps.team_id) AS total_penalty_taken
    FROM penalty_shootout ps
    LEFT JOIN soccer_country sc ON sc.country_id = ps.team_id
)

SELECT TOP 3
    country_name,
       SUM(scr_goal) * 1.0 / MIN(total_penalty_taken) AS success_penalty_cr
FROM cte_pen_goal
GROUP BY country_name
ORDER BY success_penalty_cr DESC;


-- 36. Business scenario Q36
-- Referee Analysis
-- As a referee instructor, you're preparing a training module based on the performance of
-- referees in the EURO cup 2016. You're interested in referees who officiated the most number
-- of matches. List referees based on the number of matches they officiated during the EURO
-- cup 2016.


SELECT rm.referee_name,
       COUNT(*) AS cnt_matches
FROM match_mast mm
LEFT JOIN referee_mast rm ON rm.referee_id = mm.referee_id
GROUP BY rm.referee_name
ORDER BY cnt_matches DESC;




-- 37.Business scenario Q37
-- Top Goal Scorers
-- You are a sports journalist preparing an article on the top goal scorers of the EURO cup 2016.
-- To ensure your article is accurate and data-driven, you decide to consult the database to
-- identify the top 5 players who scored the most goals during the tournament.


SELECT TOP 5
    pm.player_name,
       COUNT(*) AS cnt_goals
FROM goal_details gd
LEFT JOIN player_mast pm ON pm.player_id = gd.player_id
GROUP BY pm.player_name
ORDER BY cnt_goals DESC;


-- 38.Business scenario Q38
-- Teams with Most Bookings
-- As a team manager, you are reviewing the discipline of various teams in the EURO cup 2016.
-- You want to identify the top 3 teams that received the most bookings to understand the
-- aggressive nature of their gameplay


SELECT TOP 3
    sc.country_name,
       COUNT(*) AS cnt_booking_per_team
FROM player_booked pb
LEFT JOIN soccer_country sc ON pb.team_id = sc.country_id
GROUP BY sc.country_name
ORDER BY COUNT(*) DESC;




-- 39. Business scenario Q39
-- Players substituted the Most
-- You are a soccer coach analysing player fitness and endurance. You decide to look into the
-- players who were frequently substituted during matches in EURO cup 2016 to understand
-- their stamina levels and game participation.


SELECT pm.player_name,
       SUM(CASE WHEN in_out = 'I' THEN 1 ELSE 0 END) AS total_in_player,
       SUM(CASE WHEN in_out = 'O' THEN 1 ELSE 0 END) AS total_out_player /* How freequintly player was substitued */
FROM player_in_out pio
LEFT JOIN player_mast pm ON pm.player_id = pio.player_id
GROUP BY pm.player_name
ORDER BY total_out_player DESC;



-- 40. Business scenario Q40
-- Referees who Officiated Most Matches
-- As part of a referee performance review, the soccer federation wants to know which referees
-- were assigned the most matches during EURO cup 2016. This data will help in understanding
-- their experience and performance during high stakes matches.



SELECT rm.referee_name,
       COUNT(*) AS cnt_matches
FROM match_mast mm
LEFT JOIN referee_mast rm ON rm.referee_id = mm.referee_id
GROUP BY rm.referee_name
ORDER BY cnt_matches DESC;



-- 41.Business scenario Q41
-- Teams with Highest Average Player Age
-- As an analyst for a sports agency, you're trying to identify veteran teams in the EURO cup
-- 2016. Teams with a higher average age might have more experienced players. You decide to
-- compute the average age of players for each team.


WITH cte_avg_team AS (
    SELECT team_id,
           AVG(age) AS avg_team_age
    FROM player_mast
    GROUP BY team_id
)
SELECT sc.country_name,
       avg_team_age
FROM cte_avg_team cat
LEFT JOIN soccer_country sc ON cat.team_id = sc.country_id
ORDER BY avg_team_age DESC;