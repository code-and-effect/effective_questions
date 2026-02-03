require 'test_helper'

class LongAnswerTest < ActiveSupport::TestCase
  let(:questionable) { create_user! }
  let(:responsable) { create_user! }

  test 'Equal to long answer' do
    value = 'This is the correct long answer.'

    question = build_question(questionable, 'Long Answer', scored: true)
    answer = question.question_answers.build(operation: 'Equal to', long_answer: value)

    response = responsable.response(question: question)
    response.assign_attributes(long_answer: value)
    assert response.correct?

    response.assign_attributes(long_answer: 'This is a different answer.')
    refute response.correct?
  end

  test 'Contains long answer' do
    value = 'keyword'

    question = build_question(questionable, 'Long Answer', scored: true)
    answer = question.question_answers.build(operation: 'Contains', long_answer: value)

    response = responsable.response(question: question)
    response.assign_attributes(long_answer: 'This answer contains the keyword we are looking for.')
    assert response.correct?

    response.assign_attributes(long_answer: 'This answer does not have it.')
    refute response.correct?
  end

  test 'Does not contain long answer' do
    value = 'forbidden'

    question = build_question(questionable, 'Long Answer', scored: true)
    answer = question.question_answers.build(operation: 'Does not contain', long_answer: value)

    response = responsable.response(question: question)
    response.assign_attributes(long_answer: 'This is an acceptable answer.')
    assert response.correct?

    response.assign_attributes(long_answer: 'This answer has the forbidden word.')
    refute response.correct?
  end

  test 'question_answer to_s for long answer' do
    question = build_question(questionable, 'Long Answer', scored: true)

    answer = question.question_answers.build(operation: 'Equal to', long_answer: 'expected answer')
    assert_equal 'Equal to "expected answer"', answer.to_s

    answer.assign_attributes(operation: 'Contains', long_answer: 'keyword')
    assert_equal 'Contains "keyword"', answer.to_s

    answer.assign_attributes(operation: 'Does not contain', long_answer: 'forbidden')
    assert_equal 'Does not contain "forbidden"', answer.to_s
  end
end
