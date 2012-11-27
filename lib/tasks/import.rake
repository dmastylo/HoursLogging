namespace :import do
  task :timespents => :environment do
    require 'csv'

    CSV.foreach('timespents.csv', headers: true) do |row|
      row = row.to_hash
      email = row["name"].split(" ").first.first.downcase + row["name"].split(" ").last.downcase + "@codequarry.net"
      user = User.find_by_email(email)

      if !user.nil?
        # puts row.to_yaml
        project = Project.find_or_create_by_name(row["project"])
        # puts row["date"] + " " + row["time_end"]
        created_at = Time.strptime(row["date"] + " " + row["time_start"], "%m/%d/%Y %H:%M")
        finished_at = Time.strptime(row["date"] + " " + row["time_end"], "%m/%d/%Y %H:%M")
        timespent = {
          project_id: project.id,
          notes: row["description"],
          created_at: created_at,
          finished_at: finished_at
        }

        timespent = user.time_spents.new(timespent)
        timespent.save
      end
    end
  end
end