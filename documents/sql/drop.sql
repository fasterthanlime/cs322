-- Drop all the things!!
DROP TABLE people CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE people_seq;

DROP TABLE players CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE players_seq;

DROP TABLE coaches CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE coaches_seq;

DROP TABLE teams CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE teams_seq;

DROP TABLE coaches_teams CASCADE CONSTRAINT PURGE;
DROP SEQUENCE coaches_teams_seq;

DROP TABLE conferences CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE conferences_seq;

DROP TABLE leagues CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE leagues_seq;

DROP TABLE locations CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE locations_seq;

DROP TABLE drafts CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE drafts_seq;

DROP TABLE stats CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE stats_seq;

DROP TABLE team_seasons CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE team_seasons_seq;

DROP TABLE team_stat_tactiques CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE team_stat_tactiques_seq;

DROP TABLE team_stats CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE team_stats_seq;

DROP TABLE player_seasons CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE player_seasons_seq;

DROP TABLE player_season_types CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE player_season_types_seq;

DROP TABLE player_stats CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE player_stats_seq;

DROP TABLE player_allstars CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE player_allstars_seq;
