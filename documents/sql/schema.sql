--
-- TODO:
--  - team_seasons - offensive / defensive
--  - player season - regular / playoff / allstar
--  - etc.
--

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
    ilkid VARCHAR(9),
    firstname VARCHAR(255),
    lastname VARCHAR(255),
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
    height_feet NUMBER,
    height_inches NUMBER,
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
    league_id NUMBER NOT NULL,
    conference_id NUMBER NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (trigram),
    FOREIGN KEY (league_id)
        REFERENCES leagues (id) ON DELETE CASCADE,
    FOREIGN KEY (conference_id)
        REFERENCES conferences (id) ON DELETE CASCADE
);

CREATE SEQUENCE teams_seq
    START WITH 1
    INCREMENT BY 1;

--
-- Physical
-- ========
--
-- A school is also a country if it's outside the U.S.
--

CREATE TABLE schools (
    id NUMBER,
    name VARCHAR(255),
    PRIMARY KEY (id),
    UNIQUE (name)
);

CREATE SEQUENCE schools_seq
    START WITH 1
    INCREMENT BY 1;

--
-- Drafts
--

CREATE TABLE drafts (
    id NUMBER,
    year NUMBER NOT NULL,
    round NUMBER NOT NULL,
    selection NUMBER NOT NULL,
    person_id NUMBER NOT NULL,
    team_id NUMBER NOT NULL,
    league_id NUMBER NOT NULL,
    school_id NUMBer NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (person_id)
        REFERENCES people (id) ON DELETE CASCADE,
    FOREIGN KEY (team_id)
        REFERENCES teams (id) ON DELETE CASCADE,
    FOREIGN KEY (league_id)
        REFERENCES leagues (id) ON DELETE CASCADE,
    FOREIGN KEY (school_id)
        REFERENCES schools (id) ON DELETE CASCADE
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
-- Link entites
-- ============
--
-- Between players, teams, season and stats
--

CREATE TABLE player_seasons (
    id NUMBER,
    year NUMBER NOT NULL,
    person_id NUMBER NOT NULL,
    team_id NUMBER NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (person_id, year),
    FOREIGN KEY (person_id)
        REFERENCES people (id) ON DELETE CASCADE,
    FOREIGN KEY (team_id)
        REFERENCES teams (id) ON DELETE CASCADE
);

CREATE SEQUENCE player_seasons_seq
    START WITH 1
    INCREMENT BY 1;

CREATE TABLE team_seasons (
    id NUMBER,
    year NUMBER NOT NULL,
    team_id NUMBER NOT NULL,
    offensive_stat_id NUMBER NOT NULL,
    defensive_stat_id NUMBER NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (team_id, year),
    FOREIGN KEY (team_id)
        REFERENCES teams (id) ON DELETE CASCADE,
    FOREIGN KEY (offensive_stat_id)
        REFERENCES stats (id) ON DELETE CASCADE,
    FOREIGN KEY (defensive_stat_id)
        REFERENCES stats (id) ON DELETE CASCADE
);

CREATE SEQUENCE team_seasons_seq
    START WITH 1
    INCREMENT BY 1;

-- FIXME: Should we group these 3 with a “kind of” season attr ? —Yoan

CREATE TABLE player_regular_seasons (
    id NUMBER,
    player_season_id NUMBER,
    stat_id NUMBER,
    PRIMARY KEY (id),
    UNIQUE (player_season_id, stat_id),
    FOREIGN KEY (player_season_id)
        REFERENCES player_seasons (id) ON DELETE CASCADE,
    FOREIGN KEY (stat_id)
        REFERENCES stats (id) ON DELETE CASCADE
);

CREATE SEQUENCE player_regular_seasons_seq
    START WITH 1
    INCREMENT BY 1;

CREATE TABLE player_playoff_seasons (
    id NUMBER,
    player_season_id NUMBER,
    stat_id NUMBER,
    PRIMARY KEY (id),
    UNIQUE (player_season_id, stat_id),
    FOREIGN KEY (player_season_id)
        REFERENCES player_seasons (id) ON DELETE CASCADE,
    FOREIGN KEY (stat_id)
        REFERENCES stats (id) ON DELETE CASCADE
);

CREATE SEQUENCE player_playoff_seasons_seq
    START WITH 1
    INCREMENT BY 1;

CREATE TABLE player_allstar_seasons (
    id NUMBER,
    player_season_id NUMBER NOT NULL,
    stat_id NUMBER NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (player_season_id, stat_id),
    FOREIGN KEY (player_season_id)
        REFERENCES player_seasons (id) ON DELETE CASCADE,
    FOREIGN KEY (stat_id)
        REFERENCES stats (id) ON DELETE CASCADE
);

CREATE SEQUENCE player_allstar_seasons_seq
    START WITH 1
    INCREMENT BY 1;
