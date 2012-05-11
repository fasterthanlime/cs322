-- Note: ActiveRecord (Rails) don't support composite primary keys so the
--       mention “Weak” has been put on top of the tables acting like so.

--
-- People
-- ======
--
-- A person can be a player and/or a coach at different time of
-- her life.
--
-- ilkid can be NULL for drafted only players
--

CREATE TABLE people (
    id INT,
    ilkid VARCHAR(10),
    firstname VARCHAR(255) NOT NULL,
    lastname VARCHAR(255) NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT person_unique UNIQUE (ilkid, firstname, lastname)
);

CREATE SEQUENCE people_seq
    START WITH 1
    INCREMENT BY 1;

CREATE TABLE players (
    id INT,
    person_id INT NOT NULL,
    position CHAR(1),
    height INT, -- in inches
    weight INT,
    birthdate DATE,
    PRIMARY KEY (id),
    FOREIGN KEY (person_id)
        REFERENCES people (id) ON DELETE CASCADE
);

CREATE SEQUENCE players_seq
    START WITH 1
    INCREMENT BY 1;

--
-- Group of people
-- ===============
--
-- Teams, leagues and stuff
--

-- NBA/ABA
CREATE TABLE leagues (
    id INT,
    name CHAR(3) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (name)
);

CREATE SEQUENCE leagues_seq
    START WITH 1
    INCREMENT BY 1;

CREATE TABLE conferences (
    id INT,
    name VARCHAR(31) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (name)
);

CREATE SEQUENCE conferences_seq
    START WITH 1
    INCREMENT BY 1;

CREATE TABLE teams (
    id INT,
    league_id INT NOT NULL,
    trigram CHAR(3) NOT NULL,
    name VARCHAR(255),
    location VARCHAR(255),
    PRIMARY KEY (id),
    CONSTRAINT team_unique UNIQUE (league_id, trigram),
    FOREIGN KEY (league_id)
        REFERENCES leagues (id) ON DELETE CASCADE
);

CREATE SEQUENCE teams_seq
    START WITH 1
    INCREMENT BY 1;

-- @weak
CREATE TABLE coach_seasons (
    id INT,
    person_id INT NOT NULL,
    team_id INT NOT NULL,
    year INT NOT NULL,
    year_order INT,
    season_win INT,
    season_loss INT,
    playoff_win INT,
    playoff_loss INT,
    PRIMARY KEY (id),
    CONSTRAINT coach_seasons_unique UNIQUE (person_id, team_id, year),
    FOREIGN KEY (person_id)
        REFERENCES people (id) ON DELETE CASCADE,
    FOREIGN KEY (team_id)
        REFERENCES teams (id) ON DELETE CASCADE
);

CREATE SEQUENCE coach_seasons_seq
    START WITH 1
    INCREMENT BY 1;

--
-- Physical
-- ========
--
-- A school or a country if it's outside the U.S.
--

CREATE TABLE locations (
    id INT,
    name VARCHAR(255),
    PRIMARY KEY (id),
    UNIQUE (name)
);

CREATE SEQUENCE locations_seq
    START WITH 1
    INCREMENT BY 1;

--
-- Drafts
--

-- @weak
CREATE TABLE drafts (
    id INT,
    person_id INT NOT NULL,
    year INT NOT NULL,
    round INT NOT NULL,
    selection INT NOT NULL,
    team_id INT NOT NULL,
    location_id INT NULL,
    PRIMARY KEY (id),
    CONSTRAINT draft_unique UNIQUE (person_id, team_id, location_id, year, round),
    FOREIGN KEY (person_id)
        REFERENCES people (id) ON DELETE CASCADE,
    FOREIGN KEY (team_id)
        REFERENCES teams (id) ON DELETE CASCADE,
    FOREIGN KEY (location_id)
        REFERENCES locations (id) ON DELETE CASCADE
);

CREATE SEQUENCE drafts_seq
    START WITH 1
    INCREMENT BY 1;


-- Teams stats
-- ===========


CREATE TABLE team_stat_tactiques (
    id INT NOT NULL,
    name VARCHAR(31),
    PRIMARY KEY (id),
    UNIQUE (name)
);

CREATE SEQUENCE team_stat_tactiques_seq
    START WITH 1
    INCREMENT BY 1;

-- @weak
CREATE TABLE team_stats (
    id INT,
    team_id INT NOT NULL,
    year INT NOT NULL,
    team_stat_tactique_id INT NOT NULL,
    pts INT,
    oreb INT,
    dreb INT,
    reb INT,
    asts INT,
    steals INT,
    blocks INT,
    pf INT,
    fga INT,
    fgm INT,
    fta INT,
    ftm INT,
    tpa INT, -- 3pa
    tpm INT, -- 3pm
    pace NUMBER NULL,
    PRIMARY KEY (id),
    CONSTRAINT team_stat_unique UNIQUE (team_id, year, team_stat_tactique_id),
    FOREIGN KEY (team_id)
        REFERENCES teams (id) ON DELETE CASCADE,
    FOREIGN KEY (team_stat_tactique_id)
        REFERENCES team_stat_tactiques (id) ON DELETE CASCADE
);

CREATE SEQUENCE team_stats_seq
    START WITH 1
    INCREMENT BY 1;

--
-- Players stats
-- =============

CREATE TABLE player_seasons (
    id INT,
    player_id INT NOT NULL,
    team_id INT NOT NULL,
    year INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT player_season_unique UNIQUE (player_id, team_id, year),
    FOREIGN KEY (player_id)
        REFERENCES players (id) ON DELETE CASCADE,
    FOREIGN KEY (team_id)
        REFERENCES teams (id) ON DELETE CASCADE
);

CREATE SEQUENCE player_seasons_seq
    START WITH 1
    INCREMENT BY 1;

CREATE TABLE player_season_types (
    id INT,
    name VARCHAR (31),
    PRIMARY KEY (id),
    UNIQUE (name)
);

CREATE SEQUENCE player_season_types_seq
    START WITH 1
    INCREMENT BY 1;

-- @weak
CREATE TABLE player_stats (
    id INT,
    player_season_id INT NOT NULL,
    player_season_type_id INT NOT NULL,
    pts INT,
    oreb INT,
    dreb INT,
    reb INT,
    asts INT,
    steals INT,
    blocks INT,
    pf INT,
    fga INT,
    fgm INT,
    fta INT,
    ftm INT,
    tpa INT, -- 3pa
    tpm INT, -- 3pm
    turnovers INT,
    gp INT,
    minutes INT,
    PRIMARY KEY (id),
    CONSTRAINT player_stat_unique UNIQUE (player_season_id, player_season_type_id),
    FOREIGN KEY (player_season_id)
        REFERENCES player_seasons (id) ON DELETE CASCADE,
    FOREIGN KEY (player_season_type_id)
        REFERENCES player_season_types (id) ON DELETE CASCADE
);

CREATE SEQUENCE player_stats_seq
    START WITH 1
    INCREMENT BY 1;

CREATE TABLE player_allstars (
    id INT,
    player_id INT NOT NULL,
    conference_id INT NOT NULL,
    year INT NOT NULL,
    pts INT,
    oreb INT,
    dreb INT,
    reb INT,
    asts INT,
    steals INT,
    blocks INT,
    pf INT,
    fga INT,
    fgm INT,
    fta INT,
    ftm INT,
    tpa INT, -- 3pa
    tpm INT, -- 3pm
    turnovers INT,
    gp INT,
    minutes INT,
    PRIMARY KEY(id),
    CONSTRAINT player_allstars_unique UNIQUE (player_id, conference_id, year),
    FOREIGN KEY (player_id)
        REFERENCES players (id) ON DELETE CASCADE,
    FOREIGN KEY (conference_id)
        REFERENCES conferences (id) ON DELETE CASCADE
);

CREATE SEQUENCE player_allstars_seq
    START WITH 1
    INCREMENT BY 1;

-- Denormalized data

CREATE TABLE coaches (
    person_id INT NOT NULL,
    season_win INT,
    season_loss INT,
    playoff_win INT,
    playoff_loss INT,
    PRIMARY KEY (person_id),
    FOREIGN KEY (person_id)
        REFERENCES people (id) ON DELETE CASCADE
);

CREATE OR REPLACE TRIGGER coaches_data
AFTER INSERT OR UPDATE OR DELETE ON coach_seasons
FOR EACH ROW
DECLARE
  c INT;
  r_id coach_seasons.person_id%type := NULL;
  r_season_win coach_seasons.season_win%type := 0;
  r_season_loss coach_seasons.season_loss%type := 0;
  r_playoff_win coach_seasons.playoff_win%type := 0;
  r_playoff_loss coach_seasons.playoff_loss%type := 0;
BEGIN
  IF UPDATING OR INSERTING THEN
    r_id := :new.person_id;
    r_season_win := :new.season_win;
    r_season_loss := :new.season_loss;
    r_playoff_win := :new.playoff_win;
    r_playoff_loss := :new.playoff_loss;
  END IF;

  IF UPDATING OR DELETING THEN
    r_id := :new.person_id;
    r_season_win := r_season_win - :old.season_win;
    r_season_loss := r_season_loss - :old.season_loss;
    r_playoff_win := r_playoff_win - :old.playoff_win;
    r_playoff_loss := r_playoff_loss - :old.playoff_loss;
  END IF;

  SELECT COUNT(id) INTO c FROM people WHERE id = r_id;

  IF c = 0 THEN
    INSERT INTO coaches
      (person_id, season_win, season_loss, playoff_win, playoff_loss)
    VALUES
      (:new.person_id, 0, 0, 0, 0);
  END IF;

  UPDATE coaches SET
    season_win = season_win + r_season_win,
    season_loss = season_loss + r_season_loss,
    playoff_win = playoff_win + r_playoff_win,
    playoff_loss = playoff_loss + r_playoff_loss
  WHERE
    person_id = :new.person_id;
END coaches_data;
/
