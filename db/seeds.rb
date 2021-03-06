user = User.create!(email: "test@test.com", password: "password9")
member_user = User.create!(email: "member_test@test.com", password: "password9")

projects = user.created_projects.create!([
                  { name: "Booth", description: "Marketplace app, private", privacy_type: Project::PrivacyType::PRIVATE },
                  { name: "Inflation Gem", description: "Gem for calculating inflation", privacy_type: Project::PrivacyType::PUBLIC },
                  { name: "Nutshell Design", description: "My software development consultancy", privacy_type: Project::PrivacyType::PRIVATE }
                  ])

projects.each { |project| project.members << member_user }

projects.each_with_index do |project, index|
  user.time_spents.create!(project_id: project.id,
                           created_at: (index + 3).hours.ago,
                           finished_at: (index + 2).hours.ago,
                           notes: "#{project.name} #{index} db:seed note, 1 hour test time spent")

  user.time_spents.create!(project_id: project.id,
                           created_at: (index + 5).days.ago,
                           finished_at: (index + 5).days.ago + (index + 3).hours,
                           notes: "#{project.name} #{index} db:seed note, 5 days ago, 3 hour test time spent")

  user.time_spents.create!(project_id: project.id,
                           created_at: (index + 1).month.ago,
                           finished_at: (index + 1).month.ago + (index + 0.5).hours,
                           notes: "#{project.name} #{index} db:seed note, 1 month ago, 0.5 hour test time spent")
end
