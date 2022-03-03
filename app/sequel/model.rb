# need add `gem 'chronic'` to Gemfile
module Sequel
  class Model
    def validates_date(date)
      errors.add(date, "is not valid date") unless Chronic.parse(date)
    end
  end
end
