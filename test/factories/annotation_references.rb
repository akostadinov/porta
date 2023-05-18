FactoryBot.define do
  factory :annotation_reference do
    annotated { nil }
    tenant_id { 1 }
    annotation { nil }
  end
end
