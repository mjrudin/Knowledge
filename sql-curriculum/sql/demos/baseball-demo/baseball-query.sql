-- This query joins each player with all of the coaches for his
-- team. Notice that I *namespace* the tables of the join; this is
-- necessary when using the name field. Since both baseball_players
-- and baseball_coaches have a name column, using it without the table
-- name would be ambiguous. Likewise, it is common to use the table
-- names in the ON condition, to make explicit how the two tables are
-- related.
--
-- This is a *many-to-many* query, because each player can have
-- several coaches, and each coach can have many players. We say that
-- the relationship occurs *through* the baseball_teams table, since
-- this is what relates them.
SELECT 
  baseball_players.name,
  baseball_coaches.name
FROM 
  baseball_players
JOIN
  baseball_coaches 
  ON baseball_players.baseball_team_id = baseball_coaches.baseball_team_id;
