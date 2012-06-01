INSERT INTO leagues (id, name) VALUES (leagues_seq.NEXTVAL, 'NBA');
INSERT INTO leagues (id, name) VALUES (leagues_seq.NEXTVAL, 'ABA');

INSERT INTO conferences (id, name) VALUES (conferences_seq.NEXTVAL, 'Eastern');
INSERT INTO conferences (id, name) VALUES (conferences_seq.NEXTVAL, 'Western');

INSERT INTO player_season_types (id, name) VALUES (player_season_types_seq.NEXTVAL, 'Regular');
INSERT INTO player_season_types (id, name) VALUES (player_season_types_seq.NEXTVAL, 'Playoff');
