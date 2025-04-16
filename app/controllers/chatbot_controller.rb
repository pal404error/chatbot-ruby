class ChatbotController < ApplicationController
    def ask
        if params[:question].present?
            response = ChatbotService.new.ask_question(params[:question])
            render json: {answer: response}
        else
            render json: {error: "no question typed"},status :unprocessable_entity
        end
    end
end
