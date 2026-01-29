module EffectiveQuestionsTestBuilder

  def build_question(questionable, category)
    questions = Array(category).map.with_index do |category, index|
      question = questionable.questions.build(title: "#{category} Question ##{index+1}", category: category, required: false)

      if question.question_option?
        question.question_options.build(title: 'Option A')
        question.question_options.build(title: 'Option B')
        question.question_options.build(title: 'Option C')
      end
    end

    questions.length == 1 ? questions.first : questions
  end

  def create_user!
    build_user.tap(&:save!)
  end

  def build_user
    @user_index ||= 0
    @user_index += 1

    User.new(
      email: "user#{@user_index}@example.com",
      password: 'rubicon2020',
      password_confirmation: 'rubicon2020',
      first_name: 'Test',
      last_name: 'User'
    )
  end

end
