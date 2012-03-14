-- Drop all the things!!
DROP TABLE nba.people CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE nba.people_seq;

DROP TABLE nba.players CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE nba.players_seq;

DROP TABLE nba.coaches CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE nba.coaches_seq;

--
-- People
-- ======
--
-- A person can be a player and/or a coach at different time of
-- her life.
--

CREATE TABLE nba.people (
    id NUMBER,
    ilkid VARCHAR(9) NOT NULL,
    firstname VARCHAR(255),
    lastname VARCHAR(255),
    PRIMARY KEY (id)
);

CREATE SEQUENCE nba.people_seq
    START WITH 1
    INCREMENT BY 1;

CREATE TABLE nba.players (
    id NUMBER,
    person_id NUMBER NOT NULL,
    position CHAR(1) NOT NULL,
-- look like denormalized values to me
--    season_first NUMBER,
--    season_last NUMBER,
    height_feet NUMBER,
    height_inches NUMBER,
    weight NUMBER,
    birthdate DATE,
    PRIMARY KEY (id),
    FOREIGN KEY (person_id)
        REFERENCES nba.people ON DELETE CASCADE
);

CREATE SEQUENCE nba.players_seq
    START WITH 1
    INCREMENT BY 1;

CREATE TABLE nba.coaches (
    id NUMBER,
    person_id NUMBER NOT NULL,
    season_win NUMBER,
    season_loss NUMBER,
    playoff_win NUMBER,
    playoff_loss NUMBER,
    PRIMARY KEY (id),
    FOREIGN KEY (person_id)
        REFERENCES nba.people ON DELETE CASCADE
);

CREATE SEQUENCE nba.coaches_seq
    START WITH 1
    INCREMENT BY 1;
