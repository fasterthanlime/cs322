INSERT INTO leagues (id, name) VALUES (leagues_seq.NEXTVAL, 'NBA');
INSERT INTO leagues (id, name) VALUES (leagues_seq.NEXTVAL, 'ABA');

INSERT INTO conferences (id, name) VALUES (conferences_seq.NEXTVAL, 'Eastern');
INSERT INTO conferences (id, name) VALUES (conferences_seq.NEXTVAL, 'Western');

INSERT INTO team_stat_tactiques (id, name) VALUES (team_stat_tactiques_seq.NEXTVAL, 'Offensive');
INSERT INTO team_stat_tactiques (id, name) VALUES (team_stat_tactiques_seq.NEXTVAL, 'Defensive');

INSERT INTO player_season_types (id, name) VALUES (player_season_types_seq.NEXTVAL, 'Regular');
INSERT INTO player_season_types (id, name) VALUES (player_season_types_seq.NEXTVAL, 'Playoff');
INSERT INTO player_season_types (id, name) VALUES (player_season_types_seq.NEXTVAL, 'All Stars');
