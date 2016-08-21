class ExportCSV
  extend EventHelper

  def self.event_users(attendees, signup)
    if attendees.present? && signup.present?
      CSV.generate(headers: true) do |csv|
        csv << [User.human_attribute_name(:name),
                EventUser.human_attribute_name(:user_type),
                EventUser.human_attribute_name(:group),
                User.human_attribute_name(:food_preference),
                EventUser.human_attribute_name(:answer),
                User.human_attribute_name(:email)]

        attendees.each do |a|
          csv << [a.user,
                  event_user_type(signup, a.user_type),
                  a.group,
                  a.user.food_preference,
                  a.answer,
                  a.user.email]
        end
      end
    end
  end
end
