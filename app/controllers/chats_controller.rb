class ChatsController < ApplicationController
  def index
    # These will be passed by redirect via query params
    @response = params[:response]
    @user_input = params[:user_input]
  end

  def create
    user_input = params[:message]
    service = OpenaiService.new
    response = service.get_response(user_input)

    puts "GPT RESPONSE: #{response.inspect}"  # DEBUG

    # ⚠️ Avoid flash/session — just pass in URL or render directly
    redirect_to root_path(response: response, user_input: user_input)
  end
end
