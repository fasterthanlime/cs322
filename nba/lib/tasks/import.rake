require 'csv'

desc "Import team data from the CSV"
task :team_import => :environment do
  text = File.read('../dataset/teams.csv')
  csv = CSV.parse(text, :headers => true)

  csv.each do |row|
    puts "Adding #{row[0]}: " + Team.create(
      :trigram => row[0],
      :location => row[1],
      :name => row[2],
    ).to_s
  end
end

desc "Drop all data"
task :drop => :environment do
  Team.delete_all()
end
