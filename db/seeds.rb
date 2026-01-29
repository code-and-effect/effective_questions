puts "Running effective_questions seeds"

def build_question(questionable, category)
  questions = Array(category).map.with_index do |category, index|
    question = questionable.questions.build(title: "#{category} Question ##{index+1}", category: category)

    if question.question_option?
      question.question_options.build(title: 'Option A')
      question.question_options.build(title: 'Option B')
      question.question_options.build(title: 'Option C')
    end
  end

  questions.length == 1 ? questions.first : questions
end
