require 'test_helper'

class PercentageTest < ActiveSupport::TestCase
  let(:questionable) { create_user! }
  let(:responsable) { create_user! }

  test 'Equal to percentage' do
    value = 50000 # 50% stored as 50000 (multiplied by 1000)

    question = build_question(questionable, 'Percentage', scored: true)
    answer = question.question_answers.build(operation: 'Equal to', percentage: value)

    response = responsable.response(question: question)
    response.assign_attributes(percentage: value)
    assert response.correct?

    response.assign_attributes(percentage: value + 1000)
    refute response.correct?
  end

  test 'Within range percentage' do
    value = 50000

    question = build_question(questionable, 'Percentage', scored: true)
    answer = question.question_answers.build(operation: 'Within range', percentage_begin: value - 10000, percentage_end: value + 10000)

    response = responsable.response(question: question)
    response.assign_attributes(percentage: value)
    assert response.correct?

    response.assign_attributes(percentage: value + 50000)
    refute response.correct?
  end

  test 'Less than percentage' do
    value = 50000

    question = build_question(questionable, 'Percentage', scored: true)
    answer = question.question_answers.build(operation: 'Less than', percentage: value + 1000)

    response = responsable.response(question: question)
    response.assign_attributes(percentage: value)
    assert response.correct?

    response.assign_attributes(percentage: value + 1000)
    refute response.correct?
  end

  test 'Less than or equal to percentage' do
    value = 50000

    question = build_question(questionable, 'Percentage', scored: true)
    answer = question.question_answers.build(operation: 'Less than or equal to', percentage: value)

    response = responsable.response(question: question)
    response.assign_attributes(percentage: value)
    assert response.correct?

    response.assign_attributes(percentage: value + 1000)
    refute response.correct?
  end

  test 'Greater than percentage' do
    value = 50000

    question = build_question(questionable, 'Percentage', scored: true)
    answer = question.question_answers.build(operation: 'Greater than', percentage: value - 1000)

    response = responsable.response(question: question)
    response.assign_attributes(percentage: value)
    assert response.correct?

    response.assign_attributes(percentage: value - 1000)
    refute response.correct?
  end

  test 'Greater than or equal to percentage' do
    value = 50000

    question = build_question(questionable, 'Percentage', scored: true)
    answer = question.question_answers.build(operation: 'Greater than or equal to', percentage: value)

    response = responsable.response(question: question)
    response.assign_attributes(percentage: value)
    assert response.correct?

    response.assign_attributes(percentage: value - 1000)
    refute response.correct?
  end

  test 'question_answer to_s for percentage' do
    value = 50000 # 50%

    question = build_question(questionable, 'Percentage', scored: true)

    answer = question.question_answers.build(operation: 'Equal to', percentage: value)
    assert_equal 'Equal to 50%', answer.to_s

    answer.assign_attributes(operation: 'Less than', percentage: value)
    assert_equal 'Less than 50%', answer.to_s

    answer.assign_attributes(operation: 'Less than or equal to', percentage: value)
    assert_equal 'Less than or equal to 50%', answer.to_s

    answer.assign_attributes(operation: 'Greater than', percentage: value)
    assert_equal 'Greater than 50%', answer.to_s

    answer.assign_attributes(operation: 'Greater than or equal to', percentage: value)
    assert_equal 'Greater than or equal to 50%', answer.to_s

    answer.assign_attributes(operation: 'Within range', percentage: nil, percentage_begin: 25000, percentage_end: 75000)
    assert_equal 'Between 25% and 75%', answer.to_s

    # Test decimal percentage (not divisible by 1000)
    answer.assign_attributes(operation: 'Equal to', percentage: 33333)
    assert_equal 'Equal to 33.333%', answer.to_s
  end
end
