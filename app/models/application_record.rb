class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def index
    @object = OpenStruct.new 
  end

  def to_s
    name
  end
end