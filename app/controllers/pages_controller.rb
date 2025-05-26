class PagesController < ApplicationController
  def index
  end
  
  def not_found
    begin
      @object = object params[:uri]
      return render action: "show"
    rescue => e
      return redirect_to "/404.html"
    end  
  end
  
  def object id
    Page.find(id)
  end
end
