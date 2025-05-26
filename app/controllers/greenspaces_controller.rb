class GreenspacesController < ApplicationController
  layout 'greenspace', only: [:show]
  def index
    @object = OpenStruct.new name: "Squire Bun's Parks and Trails"
  end

  def object id
    Greenspace.find(id)
  end
end
