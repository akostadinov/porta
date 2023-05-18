FactoryBot.define do
  factory :annotation do
    annotation { "MyString" }
    value { "MyString" }
    tenant_id { 1 }
  end
end
