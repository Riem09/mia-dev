FactoryGirl.define do
  factory :related_motif do
    association :motif1, :factory => :motif
    association :motif2, :factory => :motif
  end
end