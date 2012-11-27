namespace :import do
  task :timespents => :environment do
    require 'csv'

    CSV.foreach('timespents.csv', headers: true) do |row|
      row = row.to_hash
      user = {
        email: row["name"].split(" ").first.first.downcase + row["name"].split(" ").last.downcase + "@codequarry.net"
      }
      puts user.to_yaml
    end
  end
end