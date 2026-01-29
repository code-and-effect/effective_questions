Rails.application.routes.draw do
  mount EffectiveQuestions::Engine => '/', as: 'effective_questions'
end

EffectiveQuestions::Engine.routes.draw do
  scope module: 'effective' do
  end

  namespace :admin do
    resources :questions, except: [:show]
  end

end
