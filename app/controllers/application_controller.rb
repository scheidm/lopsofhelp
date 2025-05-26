class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def index
  end

  def show
    begin
      @object = object params[:id]
      return render action: "show"
    rescue => e
      puts e
      redirect_to action: :index
    end  
  end

end
