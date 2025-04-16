require "faraday"
require "json"

class OpenaiService
  def initialize
    @api_key = ENV['GROQ']

    raise "API_KEY is missing!" if @api_key.nil? || @api_key.empty?

    @conn = Faraday.new(
      url: "https://api.groq.com/openai/v1/chat/completions",
      headers: {
        "Authorization" => "Bearer #{@api_key}",
        "Content-Type" => "application/json"
      }
    )
  end

  def get_response(message)
    response = @conn.post do |req|
      req.body = {
        model: "deepseek-r1-distill-llama-70b",
        messages: [
          { role: "user", content: message }
        ]
      }.to_json
    end

    puts "STATUS: #{response.status}"
    puts "BODY: #{response.body}"

    if response.status == 401
      return "❌ Unauthorized. Check your API key."
    elsif response.status != 200
      return "❌ Error: #{response.status} - #{response.body}"
    end

    json = JSON.parse(response.body)
    json.dig("choices", 0, "message", "content") || "🤖 No response from AI"
  rescue => e
    "🔥 Exception: #{e.message}"
  end
end
