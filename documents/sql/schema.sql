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
    position CHAR(1),
    height INT, -- in inches
    weight INT,
    birthdate DATE,
    PRIMARY KEY (id),
    CONSTRAINT person_unique UNIQUE (ilkid, firstname, lastname)
);

CREATE INDEX people_ilkid_idx ON people (ilkid);
CREATE INDEX people_firstname_idx ON people (firstname);
CREATE INDEX people_lastname_idx ON people (lastname);

CREATE SEQUENCE people_seq
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
    person_id INT NOT NULL,
    team_id INT NOT NULL,
    year INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT player_season_unique UNIQUE (person_id, team_id, year),
    FOREIGN KEY (person_id)
        REFERENCES people (id) ON DELETE CASCADE,
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
    person_id INT NOT NULL,
    conference_id INT NOT NULL,
    league_id INT NOT NULL,
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
    CONSTRAINT player_allstars_unique UNIQUE (person_id, conference_id, year),
    FOREIGN KEY (person_id)
        REFERENCES people (id) ON DELETE CASCADE,
    FOREIGN KEY (conference_id)
        REFERENCES conferences (id) ON DELETE CASCADE,
    FOREIGN KEY (league_id)
        REFERENCES leagues (id) ON DELETE CASCADE
);

CREATE SEQUENCE player_allstars_seq
    START WITH 1
    INCREMENT BY 1;

-- Denormalized data

CREATE TABLE coaches (
    person_id INT NOT NULL,
    season_count INT,
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
  r_id coaches.person_id%type := NULL;
  r_season_count coaches.season_count%type := 0;
  r_season_win coaches.season_win%type := 0;
  r_season_loss coaches.season_loss%type := 0;
  r_playoff_win coaches.playoff_win%type := 0;
  r_playoff_loss coaches.playoff_loss%type := 0;
BEGIN
  IF UPDATING OR INSERTING THEN
    r_id := :new.person_id;
    r_season_count := 1;
    r_season_win := :new.season_win;
    r_season_loss := :new.season_loss;
    r_playoff_win := :new.playoff_win;
    r_playoff_loss := :new.playoff_loss;
  END IF;

  IF UPDATING OR DELETING THEN
    r_id := :old.person_id;
    r_season_count := r_season_count - 1;
    r_season_win := r_season_win - :old.season_win;
    r_season_loss := r_season_loss - :old.season_loss;
    r_playoff_win := r_playoff_win - :old.playoff_win;
    r_playoff_loss := r_playoff_loss - :old.playoff_loss;
  END IF;

  SELECT COUNT(*) INTO c FROM coaches WHERE person_id = r_id;

  IF c = 0 THEN
    INSERT INTO coaches
      (person_id, season_count, season_win, season_loss, playoff_win, playoff_loss)
    VALUES
      (r_id, r_season_count, r_season_win, r_season_loss, r_playoff_win, r_playoff_loss);
  ELSE
    UPDATE coaches SET
      season_count = season_count + r_season_count,
      season_win = season_win + r_season_win,
      season_loss = season_loss + r_season_loss,
      playoff_win = playoff_win + r_playoff_win,
      playoff_loss = playoff_loss + r_playoff_loss
    WHERE
      person_id = r_id;
  END IF;
END coaches_data;
/

CREATE TABLE players (
  person_id INT NOT NULL,
  league_id INT NOT NULL,
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
  CONSTRAINT players_unique UNIQUE (person_id, league_id, player_season_type_id),
  FOREIGN KEY (person_id)
    REFERENCES people (id) ON DELETE CASCADE,
  FOREIGN KEY (league_id)
    REFERENCES leagues (id) ON DELETE CASCADE,
  FOREIGN KEY (player_season_type_id)
    REFERENCES player_season_types (id) ON DELETE CASCADE
);

CREATE OR REPLACE PROCEDURE players_data (
  c                  INT,
  p_person_id        players.person_id%type,
  p_league_id        players.league_id%type,
  p_player_season_type_id players.player_season_type_id%type,
  p_gp               players.gp%type,
  p_minutes          players.minutes%type,
  p_pts              players.pts%type,
  p_oreb             players.oreb%type,
  p_dreb             players.dreb%type,
  p_reb              players.reb%type,
  p_asts             players.asts%type,
  p_steals           players.steals%type,
  p_blocks           players.blocks%type,
  p_turnovers        players.turnovers%type,
  p_pf               players.pf%type,
  p_fga              players.fga%type,
  p_fgm              players.fgm%type,
  p_fta              players.fta%type,
  p_ftm              players.ftm%type,
  p_tpa              players.tpa%type,
  p_tpm              players.tpm%type
) IS
BEGIN
  IF c = 0 THEN
    INSERT INTO players (
      person_id, league_id, player_season_type_id, gp, minutes, pts, oreb, dreb, reb,
      asts, steals, blocks, turnovers, pf, fga, fgm, fta, ftm, tpa, tpm
    ) VALUES (
      p_person_id, p_league_id, p_player_season_type_id, p_gp, p_minutes, p_pts,
      p_oreb, p_dreb, p_reb, p_asts, p_steals, p_blocks, p_turnovers, p_pf,
      p_fga, p_fgm, p_fta, p_ftm, p_tpa, p_tpm
    );
  ELSE
    UPDATE players SET
      gp = gp + p_gp,
      minutes = gp + p_minutes,
      pts = pts + p_pts,
      oreb = dreb + p_oreb,
      dreb = dreb + p_dreb,
      reb = reb + p_reb,
      asts = asts + p_asts,
      steals = steals + p_steals,
      blocks = blocks + p_blocks,
      turnovers = turnovers + p_turnovers,
      pf = pf + p_pf,
      fga = fga + p_fga,
      fgm = fgm + p_fgm,
      fta = fta + p_fta,
      ftm = ftm + p_ftm,
      tpa = tpa + p_tpa,
      tpm = tpm + p_tpm
    WHERE
      person_id = p_person_id AND
      league_id = p_league_id AND
      player_season_type_id = p_player_season_type_id;
  END IF;
END players_data;
/

CREATE OR REPLACE TRIGGER players_data_after
AFTER INSERT OR UPDATE ON player_stats
FOR EACH ROW
DECLARE
  c INT;
  r_person_id players.person_id%type := 0;
  r_league_id players.league_id%type := 0;
  r_gp players.gp%type := 0;
  r_minutes players.minutes%type := 0;
  r_pts players.pts%type := 0;
  r_oreb players.oreb%type := 0;
  r_dreb players.dreb%type := 0;
  r_reb players.reb%type := 0;
  r_asts players.asts%type := 0;
  r_steals players.steals%type := 0;
  r_blocks players.blocks%type := 0;
  r_turnovers players.turnovers%type := 0;
  r_pf players.pf%type := 0;
  r_fga players.fga%type := 0;
  r_fgm players.fgm%type := 0;
  r_fta players.fta%type := 0;
  r_ftm players.ftm%type := 0;
  r_tpa players.tpa%type := 0;
  r_tpm players.tpm%type := 0;
BEGIN
  IF INSERTING OR UPDATING THEN
    r_gp := :new.gp;
    r_minutes := :new.minutes;
    r_pts := :new.pts;
    r_oreb := :new.oreb;
    r_dreb := :new.dreb;
    r_reb := :new.reb;
    r_asts := :new.asts;
    r_steals := :new.steals;
    r_blocks := :new.blocks;
    r_turnovers := :new.turnovers;
    r_pf := :new.pf;
    r_fga := :new.fga;
    r_fgm := :new.fgm;
    r_fta := :new.fta;
    r_ftm := :new.ftm;
    r_tpa := :new.tpa;
    r_tpm := :new.tpm;
  END IF;

  IF UPDATING THEN
    r_gp := r_gp - :old.gp;
    r_minutes := r_minutes - :old.minutes;
    r_pts := r_pts - :old.pts;
    r_oreb := r_oreb - :old.oreb;
    r_dreb := r_dreb - :old.dreb;
    r_reb := r_reb - :old.reb;
    r_asts := r_asts - :old.asts;
    r_steals := r_steals - :old.steals;
    r_blocks := r_blocks - :old.blocks;
    r_turnovers := r_turnovers - :old.turnovers;
    r_pf := r_pf - :old.pf;
    r_fga := r_fga - :old.fga;
    r_fgm := r_fgm - :old.fgm;
    r_fta := r_fta - :old.fta;
    r_ftm := r_ftm - :old.ftm;
    r_tpa := r_tpa - :old.tpa;
    r_tpm := r_tpm - :old.tpm;
  END IF;

  SELECT ps.person_id, t.league_id INTO r_person_id, r_league_id
  FROM player_seasons ps, teams t WHERE ps.team_id = t.id AND ps.id = :new.player_season_id;

  SELECT COUNT(*) INTO c
  FROM players WHERE
    person_id = r_person_id AND
    league_id = r_league_id AND
    player_season_type_id = :new.player_season_type_id;

  players_data(
    c, r_person_id, r_league_id, :new.player_season_type_id, r_gp, r_minutes,
    r_pts, r_oreb, r_dreb, r_reb, r_asts, r_steals, r_blocks, r_turnovers,
    r_pf, r_fga, r_fgm, r_fta, r_ftm, r_tpa, r_tpm
  );
END players_data_after;
/

CREATE OR REPLACE TRIGGER players_data_before
BEFORE DELETE ON player_stats
FOR EACH ROW
DECLARE
  c INT;
  r_person_id players.person_id%type := 0;
  r_league_id players.league_id%type := 0;
BEGIN
  SELECT ps.person_id, t.league_id INTO r_person_id, r_league_id
  FROM player_seasons ps, teams t WHERE ps.team_id = t.id AND ps.id = :old.player_season_id;

  SELECT COUNT(*) INTO c
  FROM players WHERE
    person_id = r_person_id AND
    league_id = r_league_id AND
    player_season_type_id = :old.player_season_type_id;

  players_data(
    c, r_person_id, r_league_id, :old.player_season_type_id, -:old.gp,
    -:old.minutes, -:old.pts, -:old.oreb, -:old.dreb, -:old.reb, -:old.asts,
    -:old.steals, -:old.blocks, -:old.turnovers, -:old.pf, -:old.fga,
    -:old.fgm, -:old.fta, -:old.ftm, -:old.tpa, -:old.tpm
  );
END players_data_before;
/

ALTER TABLE player_stats ADD (
    d_tendex NUMBER
);

CREATE OR REPLACE TRIGGER player_stats_tendices
BEFORE INSERT OR UPDATE ON player_stats
FOR EACH ROW
BEGIN
    IF :new.minutes > 0 THEN
        :new.d_tendex := (:new.pts + :new.reb + :new.asts + :new.steals +
                         :new.blocks - :new.ftm - :new.fgm - :new.turnovers) /
                         :new.minutes;
    END IF;
END player_stats_tendices;
/
