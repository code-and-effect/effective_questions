module EffectiveQuestionsTestBuilder

  def build_question(questionable, category, scored: false)
    question = questionable.questions.build(title: "#{category} Question", category: category, required: false, scored: scored)

    if question.question_option?
      question.question_options.build(title: 'Option A')
      question.question_options.build(title: 'Option B')
      question.question_options.build(title: 'Option C')
    end

    question
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
