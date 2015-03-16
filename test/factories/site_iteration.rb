FactoryGirl.define do
  factory :site_iteration do
    screenshot { File.new("#{Rails.root}/test/fixtures/sample.jpg") }
  end
end
