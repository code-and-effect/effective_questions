module EffectiveQuestions
  class Engine < ::Rails::Engine
    engine_name 'effective_questions'

    # Set up our default configuration options.
    initializer 'effective_questions.defaults', before: :load_config_initializers do |app|
      eval File.read("#{config.root}/config/effective_questions.rb")
    end

    # Include concerns and allow any ActiveRecord object to call it
    initializer 'effective_questions.active_record' do |app|
      app.config.to_prepare do
        ActiveRecord::Base.extend(ActsAsQuestionable::Base)
        ActiveRecord::Base.extend(ActsAsResponsable::Base)
      end
    end

  end
end
