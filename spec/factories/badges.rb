FactoryBot.define do
  factory :badge do
    name { "MyBadge" }
    image { Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb") }
  end
end
