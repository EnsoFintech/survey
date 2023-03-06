# Factories

# Create a Survey::Survey
def create_survey(opts = {})
  survey_name = "#{Faker::Games::Pokemon.name} #{Faker::Games::Pokemon.move}"
  Survey::Survey.create({
    :name => survey_name,
    :slug => "#{survey_name.parameterize}-#{Faker::Number.leading_zero_number(digits: 4)}",
    :attempts_number => 3,
    :description => ::Faker::Lorem.paragraph
  }.merge(opts))
end

# Create a Survey::Question
def create_question(opts = {})
  Survey::Question.create({
    :text =>  ::Faker::Lorem.paragraph,
    :options_attributes => {:option => correct_option_attributes}
  }.merge(opts))
end

# Create a Survey::option but not saved
def new_option(opts = {})
  Survey::Option.new
end

# Create a Survey::Option
def create_option(opts = {})
  Survey::Option.create(option_attributes.merge(opts))
end

def option_attributes
  { :text => ::Faker::Lorem.paragraph }
end

def correct_option_attributes
  option_attributes.merge({:correct => true})
end

def create_attempt(opts ={})
  attempt = Survey::Attempt.create do |t|
    t.survey = opts.fetch(:survey, nil)
    t.participant = opts.fetch(:user, nil)
    opts.fetch(:options, []).each do |option|
        t.answers.new(:option => option, :question => option.question, :attempt => t)
    end
  end
end

def create_survey_with_questions(num)
  survey = create_survey
  pp survey.inspect
  num.times do
    question = create_question
    num.times do
      question.options << create_option(correct_option_attributes)
    end
    survey.questions << question
  end
  survey
end

def create_attempt_for(user, survey, opts = {})

  if opts.fetch(:all, :wrong) == :right
    correct_survey = survey.correct_options
    create_attempt({  :options => correct_survey,
                      :user => user,
                      :survey => survey})
  else
    incorrect_survey = survey.correct_options
    incorrect_survey.shift
    create_attempt({  :options  => incorrect_survey,
                      :user => user,
                      :survey => survey})
  end
end

def create_answer(opts = {})
  survey = create_survey_with_questions(6)
  question = survey.questions.first
  option   = survey.questions.first.options.first
  attempt = create_attempt(:user => create_user, :survey => survey)
  Survey::Answer.create({:option => option, :attempt => attempt, :question => question}.merge(opts))
end

# Dummy Model from Dummy Application
def create_user
  User.create(name: Faker::Name.name)
end

def create_sti_user
  StiUser.create(name: Faker::Name.name)
end