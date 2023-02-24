module Survey
  module ActiveRecord
    extend ActiveSupport::Concern

    module ClassMethods
      def has_surveys
        has_many :survey_attempts, as: :participant, class_name: 'Survey::Attempt'

        define_method('for_survey') do |survey|
          survey_attempts.where(survey_id: survey.id)
        end
      end

      def has_many_surveys
        has_many :surveys, class_name: 'Survey::Survey'
      end

      def has_one_survey
        has_one :survey, class_name: 'Survey::Survey'
      end

    end
  end
end