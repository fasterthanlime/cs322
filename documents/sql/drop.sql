-- Drop all the things!!
DROP TABLE people CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE people_seq;

DROP TABLE teams CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE teams_seq;

DROP TABLE coach_seasons CASCADE CONSTRAINT PURGE;
DROP SEQUENCE coach_seasons_seq;

DROP TABLE conferences CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE conferences_seq;

DROP TABLE leagues CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE leagues_seq;

DROP TABLE locations CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE locations_seq;

DROP TABLE drafts CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE drafts_seq;

DROP TABLE team_seasons CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE team_seasons_seq;

DROP TABLE player_seasons CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE player_seasons_seq;

DROP TABLE player_season_types CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE player_season_types_seq;

DROP TABLE player_stats CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE player_stats_seq;

DROP TABLE player_allstars CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE player_allstars_seq;

-- Denormalized data tables and procedures (triggers are automagically deleted)

DROP TABLE coaches PURGE;

DROP TABLE players PURGE;
DROP PROCEDURE players_data;
