-- Note: ActiveRecord (Rails) don't support composite primary keys so the
--       mention “Weak” has been put on top of the tables acting like so.

--
-- People
-- ======
--
-- A person can be a player and/or a coach at different time of
-- her life.
--
-- ilkit can be NULL for drafted only players
--

CREATE TABLE people (
    id NUMBER,
    ilkid VARCHAR(10),
    firstname VARCHAR(255) NOT NULL,
    lastname VARCHAR(255) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (ilkid)
);

CREATE SEQUENCE people_seq
    START WITH 1
    INCREMENT BY 1;

CREATE TABLE players (
    id NUMBER,
    person_id NUMBER NOT NULL,
    position CHAR(1) NOT NULL,
    height NUMBER, -- in inches
    weight NUMBER,
    birthdate DATE,
    PRIMARY KEY (id),
    FOREIGN KEY (person_id)
        REFERENCES people (id) ON DELETE CASCADE
);

CREATE SEQUENCE players_seq
    START WITH 1
    INCREMENT BY 1;

CREATE TABLE coaches (
    id NUMBER,
    person_id NUMBER NOT NULL,
    season_win NUMBER,
    season_loss NUMBER,
    playoff_win NUMBER,
    playoff_loss NUMBER,
    PRIMARY KEY (id),
    FOREIGN KEY (person_id)
        REFERENCES people (id) ON DELETE CASCADE
);

CREATE SEQUENCE coaches_seq
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
    id NUMBER,
    name CHAR(3) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (name)
);

CREATE SEQUENCE leagues_seq
    START WITH 1
    INCREMENT BY 1;

CREATE TABLE conferences (
    id NUMBER,
    name VARCHAR(31) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (name)
);

CREATE SEQUENCE conferences_seq
    START WITH 1
    INCREMENT BY 1;

CREATE TABLE teams (
    id NUMBER,
    trigram CHAR(3) NOT NULL,
    name VARCHAR(255),
    location VARCHAR(255),
    PRIMARY KEY (id)
);

CREATE SEQUENCE teams_seq
    START WITH 1
    INCREMENT BY 1;

-- @weak
CREATE TABLE coaches_teams (
    id NUMBER,
    coach_id NUMBER NOT NULL,
    team_id NUMBER NOT NULL,
    year NUMBER,
    year_order NUMBER,
    PRIMARY KEY (id),
    CONSTRAINT coaches_team_unique UNIQUE (coach_id, team_id, year),
    FOREIGN KEY (coach_id)
        REFERENCES coaches (id) ON DELETE CASCADE,
    FOREIGN KEY (team_id)
        REFERENCES teams (id) ON DELETE CASCADE
);

CREATE SEQUENCE coaches_teams_seq
    START WITH 1
    INCREMENT BY 1;

--
-- Physical
-- ========
--
-- A school or a country if it's outside the U.S.
--

CREATE TABLE locations (
    id NUMBER,
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
    id NUMBER,
    player_id NUMBER NOT NULL,
    year NUMBER NOT NULL,
    round NUMBER NOT NULL,
    selection NUMBER NOT NULL,
    team_id NUMBER NOT NULL,
    location_id NUMBER NULL,
    PRIMARY KEY (id),
    CONSTRAINT draft_unique UNIQUE (player_id, team_id, location_id, year),
    FOREIGN KEY (player_id)
        REFERENCES players (id) ON DELETE CASCADE,
    FOREIGN KEY (team_id)
        REFERENCES teams (id) ON DELETE CASCADE,
    FOREIGN KEY (location_id)
        REFERENCES locations (id) ON DELETE CASCADE
);

CREATE SEQUENCE drafts_seq
    START WITH 1
    INCREMENT BY 1;


--
-- Stats
-- =====
--
-- All the kind of statistical data
--

CREATE TABLE stats (
    id NUMBER,
    pts NUMBER,
    oreb NUMBER,
    dreb NUMBER,
    reb NUMBER,
    asts NUMBER,
    steals NUMBER,
    blocks NUMBER,
    turnovers NUMBER,
    tpf NUMBER,
    fga NUMBER,
    fgm NUMBER,
    fta NUMBER,
    ftm NUMBER,
    tpa NUMBER, -- 3pa
    tpm NUMBER, -- 3pm
    PRIMARY KEY (id)
);

CREATE SEQUENCE stats_seq
    START WITH 1
    INCREMENT BY 1;

--
-- Teams stats
-- ===========

-- @weak
CREATE TABLE team_seasons (
    id NUMBER,
    team_id NUMBER NOT NULL,
    year NUMBER NOT NULL,
    league_id NUMBER NOT NULL,
    won NUMBER,
    pace NUMBER,
    lost NUMBER,
    PRIMARY KEY (id),
    CONSTRAINT team_season_unique UNIQUE (team_id, year),
    FOREIGN KEY (team_id)
        REFERENCES teams (id) ON DELETE CASCADE,
    FOREIGN KEY (league_id)
        REFERENCES leagues (id) ON DELETE CASCADE
);

CREATE SEQUENCE team_seasons_seq
    START WITH 1
    INCREMENT BY 1;

CREATE TABLE team_stat_tactiques (
    id NUMBER NOT NULL,
    name VARCHAR(31),
    PRIMARY KEY (id),
    UNIQUE (name)
);

CREATE SEQUENCE team_stat_tactiques_seq
    START WITH 1
    INCREMENT BY 1;

-- @weak
CREATE TABLE team_stats (
    id NUMBER,
    team_season_id NUMBER NOT NULL,
    stat_id NUMBER NOT NULL,
    team_stat_tactique_id NUMBER NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT team_stat_unique UNIQUE (team_season_id, stat_id, team_stat_tactique_id),
    FOREIGN KEY (team_season_id)
        REFERENCES team_seasons (id) ON DELETE CASCADE,
    FOREIGN KEY (stat_id)
        REFERENCES stats (id) ON DELETE CASCADE
);

CREATE SEQUENCE team_stats_seq
    START WITH 1
    INCREMENT BY 1;

--
-- Players stats
-- =============

CREATE TABLE player_seasons (
    id NUMBER,
    player_id NUMBER NOT NULL,
    team_id NUMBER NOT NULL,
    year NUMBER NOT NULL,
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
    id NUMBER,
    name VARCHAR (31),
    PRIMARY KEY (id),
    UNIQUE (name)
);

CREATE SEQUENCE player_season_types_seq
    START WITH 1
    INCREMENT BY 1;

-- @weak
CREATE TABLE player_stats(
    id NUMBER,
    player_season_id NUMBER NOT NULL,
    stat_id NUMBER NOT NULL,
    player_season_type_id NUMBER NOT NULL,
    conference_id NUMBER NULL, -- for all star games only
    gp NUMBER,
    minutes NUMBER,
    PRIMARY KEY (id),
    CONSTRAINT player_stat_unique UNIQUE (player_season_id, stat_id, player_season_type_id),
    FOREIGN KEY (player_season_id)
        REFERENCES player_seasons (id) ON DELETE CASCADE,
    FOREIGN KEY (stat_id)
        REFERENCES stats (id) ON DELETE CASCADE,
    FOREIGN KEY (player_season_type_id)
        REFERENCES player_season_types (id) ON DELETE CASCADE,
    FOREIGN KEY (conference_id)
        REFERENCES conferences (id) ON DELETE CASCADE
);

CREATE SEQUENCE player_stats_seq
    START WITH 1
    INCREMENT BY 1;

