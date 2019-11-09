FactoryBot.define do
  factory :author do
    given_name { "Pat" }
    family_name { "Shaughnessy" }
  end

  factory :peter_ayeni, class: Author do
    given_name { "Peter" }
    family_name { "Ayeni" }
  end

  factory :sam_ruby, class: Author do
    given_name { 'Sam' }
    family_name { 'Ruby' }
  end
end
