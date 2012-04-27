# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120425172609) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",                                  :null => false
    t.string   "resource_type",                                :null => false
    t.integer  "author_id",     :precision => 38, :scale => 0
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "i_act_adm_com_aut_typ_aut_id"
  add_index "active_admin_comments", ["namespace"], :name => "i_act_adm_com_nam"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "i_adm_not_res_typ_res_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                                                 :default => "", :null => false
    t.string   "encrypted_password",                                    :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :precision => 38, :scale => 0, :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                                            :null => false
    t.datetime "updated_at",                                                            :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "i_adm_use_res_pas_tok", :unique => true

  create_table "coaches", :force => true do |t|
    t.decimal "person_id",    :null => false
    t.decimal "season_win"
    t.decimal "season_loss"
    t.decimal "playoff_win"
    t.decimal "playoff_loss"
  end

  create_table "coaches_teams", :force => true do |t|
    t.decimal "coach_id",   :null => false
    t.decimal "team_id",    :null => false
    t.decimal "year"
    t.decimal "year_order"
  end

  add_index "coaches_teams", ["coach_id", "team_id", "year"], :name => "coaches_team_unique", :unique => true

  create_table "conferences", :force => true do |t|
    t.string "name", :limit => 31, :null => false
  end

  add_index "conferences", ["name"], :name => "sys_c004723", :unique => true

  create_table "drafts", :force => true do |t|
    t.decimal "player_id",   :null => false
    t.decimal "year",        :null => false
    t.decimal "round",       :null => false
    t.decimal "selection",   :null => false
    t.decimal "team_id",     :null => false
    t.decimal "location_id"
  end

  add_index "drafts", ["player_id", "team_id", "location_id", "year"], :name => "draft_unique", :unique => true

  create_table "leagues", :force => true do |t|
    t.string "name", :limit => 3, :null => false
  end

  add_index "leagues", ["name"], :name => "sys_c004720", :unique => true

  create_table "locations", :force => true do |t|
    t.string "name"
  end

  add_index "locations", ["name"], :name => "sys_c004733", :unique => true

  create_table "people", :force => true do |t|
    t.string "ilkid",     :limit => 10
    t.string "firstname",               :null => false
    t.string "lastname",                :null => false
  end

  add_index "people", ["ilkid"], :name => "sys_c004710", :unique => true

  create_table "player_allstars", :force => true do |t|
    t.decimal "player_id",     :null => false
    t.decimal "stat_id",       :null => false
    t.decimal "conference_id", :null => false
    t.decimal "year",          :null => false
    t.decimal "gp"
    t.decimal "minutes"
  end

  add_index "player_allstars", ["player_id", "conference_id", "year"], :name => "player_allstars_unique", :unique => true

  create_table "player_season_types", :force => true do |t|
    t.string "name", :limit => 31
  end

  add_index "player_season_types", ["name"], :name => "sys_c004770", :unique => true

  create_table "player_seasons", :force => true do |t|
    t.decimal "player_id", :null => false
    t.decimal "team_id",   :null => false
    t.decimal "year",      :null => false
  end

  add_index "player_seasons", ["player_id", "team_id", "year"], :name => "player_season_unique", :unique => true

  create_table "player_stats", :force => true do |t|
    t.decimal "player_season_id",      :null => false
    t.decimal "stat_id",               :null => false
    t.decimal "player_season_type_id", :null => false
    t.decimal "gp"
    t.decimal "minutes"
  end

  add_index "player_stats", ["player_season_id", "player_season_type_id"], :name => "player_stat_unique", :unique => true

  create_table "players", :force => true do |t|
    t.decimal  "person_id",              :null => false
    t.string   "position",  :limit => 1, :null => false
    t.decimal  "height"
    t.decimal  "weight"
    t.datetime "birthdate"
  end

  create_table "stats", :force => true do |t|
    t.decimal "pts"
    t.decimal "oreb"
    t.decimal "dreb"
    t.decimal "reb"
    t.decimal "asts"
    t.decimal "steals"
    t.decimal "blocks"
    t.decimal "turnovers"
    t.decimal "tpf"
    t.decimal "fga"
    t.decimal "fgm"
    t.decimal "fta"
    t.decimal "ftm"
    t.decimal "tpa"
    t.decimal "tpm"
  end

  create_table "team_seasons", :force => true do |t|
    t.decimal "team_id",   :null => false
    t.decimal "year",      :null => false
    t.decimal "league_id", :null => false
    t.decimal "won"
    t.decimal "pace"
    t.decimal "lost"
  end

  add_index "team_seasons", ["team_id", "year"], :name => "team_season_unique", :unique => true

  create_table "team_stat_tactiques", :force => true do |t|
    t.string "name", :limit => 31
  end

  add_index "team_stat_tactiques", ["name"], :name => "sys_c004754", :unique => true

  create_table "team_stats", :force => true do |t|
    t.decimal "team_season_id",        :null => false
    t.decimal "stat_id",               :null => false
    t.decimal "team_stat_tactique_id", :null => false
  end

  add_index "team_stats", ["team_season_id", "stat_id", "team_stat_tactique_id"], :name => "team_stat_unique", :unique => true

  create_table "teams", :force => true do |t|
    t.string "trigram",  :limit => 3, :null => false
    t.string "name"
    t.string "location"
  end

  add_foreign_key "coaches", "people", :name => "sys_c004717", :dependent => :delete

  add_foreign_key "coaches_teams", "coaches", :name => "sys_c004730", :dependent => :delete
  add_foreign_key "coaches_teams", "teams", :name => "sys_c004731", :dependent => :delete

  add_foreign_key "drafts", "locations", :name => "sys_c004743", :dependent => :delete
  add_foreign_key "drafts", "players", :name => "sys_c004741", :dependent => :delete
  add_foreign_key "drafts", "teams", :name => "sys_c004742", :dependent => :delete

  add_foreign_key "player_allstars", "conferences", :name => "sys_c004787", :dependent => :delete
  add_foreign_key "player_allstars", "players", :name => "sys_c004785", :dependent => :delete
  add_foreign_key "player_allstars", "stats", :name => "sys_c004786", :dependent => :delete

  add_foreign_key "player_seasons", "players", :name => "sys_c004767", :dependent => :delete
  add_foreign_key "player_seasons", "teams", :name => "sys_c004768", :dependent => :delete

  add_foreign_key "player_stats", "player_season_types", :name => "sys_c004778", :dependent => :delete
  add_foreign_key "player_stats", "player_seasons", :name => "sys_c004776", :dependent => :delete
  add_foreign_key "player_stats", "stats", :name => "sys_c004777", :dependent => :delete

  add_foreign_key "players", "people", :name => "sys_c004714", :dependent => :delete

  add_foreign_key "team_seasons", "leagues", :name => "sys_c004751", :dependent => :delete
  add_foreign_key "team_seasons", "teams", :name => "sys_c004750", :dependent => :delete

  add_foreign_key "team_stats", "stats", :name => "sys_c004761", :dependent => :delete
  add_foreign_key "team_stats", "team_seasons", :name => "sys_c004760", :dependent => :delete

end
