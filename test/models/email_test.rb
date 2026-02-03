require 'test_helper'

class EmailTest < ActiveSupport::TestCase
  let(:questionable) { create_user! }
  let(:responsable) { create_user! }

  test 'Equal to email' do
    value = 'test@example.com'

    question = build_question(questionable, 'Email', scored: true)
    answer = question.question_answers.build(operation: 'Equal to', email: value)

    response = responsable.response(question: question)
    response.assign_attributes(email: value)
    assert response.correct?

    response.assign_attributes(email: 'other@example.com')
    refute response.correct?
  end

  test 'Contains email' do
    value = 'example.com'

    question = build_question(questionable, 'Email', scored: true)
    answer = question.question_answers.build(operation: 'Contains', email: value)

    response = responsable.response(question: question)
    response.assign_attributes(email: 'test@example.com')
    assert response.correct?

    response.assign_attributes(email: 'test@other.com')
    refute response.correct?
  end

  test 'Does not contain email' do
    value = 'spam.com'

    question = build_question(questionable, 'Email', scored: true)
    answer = question.question_answers.build(operation: 'Does not contain', email: value)

    response = responsable.response(question: question)
    response.assign_attributes(email: 'test@example.com')
    assert response.correct?

    response.assign_attributes(email: 'test@spam.com')
    refute response.correct?
  end

  test 'question_answer to_s for email' do
    question = build_question(questionable, 'Email', scored: true)

    answer = question.question_answers.build(operation: 'Equal to', email: 'test@example.com')
    assert_equal 'Equal to "test@example.com"', answer.to_s

    answer.assign_attributes(operation: 'Contains', email: 'example.com')
    assert_equal 'Contains "example.com"', answer.to_s

    answer.assign_attributes(operation: 'Does not contain', email: 'spam.com')
    assert_equal 'Does not contain "spam.com"', answer.to_s
  end
end
