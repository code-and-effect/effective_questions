namespace :effective_questions do

  # bundle exec rake effective_questions:seed
  task seed: :environment do
    load "#{__dir__}/../../db/seeds.rb"
  end

end
