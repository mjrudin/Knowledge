CREATE TABLE baseball_teams (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255),
  city VARCHAR(255)
);

CREATE TABLE baseball_players (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255),
  baseball_team_id INTEGER
);

CREATE TABLE baseball_coaches (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255),
  baseball_team_id INTEGER
);

INSERT INTO baseball_teams (name, city)
     VALUES ('Yankees', 'New York City'),
            ('Mets', 'New York City'),
            ('Giants', 'San Francisco'); -- Sorry, Brooklyn!

INSERT INTO baseball_players (name, baseball_team_id)
     VALUES ('Babe Ruth', 1),
            ('Tom Seaver', 2),
            ('Willie Mays', 3);

INSERT INTO baseball_coaches (name, baseball_team_id)
     VALUES ('Joe Torre', 1),
            ('Joe Girardi', 1);
