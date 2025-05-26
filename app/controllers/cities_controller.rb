class CitiesController < ApplicationController
  layout "city"
  def index
    @object = OpenStruct.new name: "Greater ATL Cities"
  end

  def object id
    City.find(id)
  end
end
