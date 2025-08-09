class RecipesController < ApplicationController
  def new
    @recipe = nil
  end

  def create
    ingredients = params[:ingredients]

    prompt = <<-PROMPT
      「#{ingredients}」という食材を使った、家庭で簡単に作れるレシピを1つ提案してください。
      以下のJSON形式で、キーた値の方も完全に守って応答してください。

      {
        "recipeName": "料理名",
        "description": "料理の簡単な説明",
        "ingredients": [
          { "name": "材料名", "quantity": "分量" }
        ],
        "instructions": [
          "手順1",
          "手順2"
        ]
      }
    PROMPT

    client = OpenAI::Client.new

    begin
      response = client.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: [{ role: "user", content: prompt }],
          response_format: { type: "json_object" },
          temperature: 0.7, # 創造性。0に近いほど決定的。0.7は安定した応答を得やすい
        }
      )

      raw_response = response.dig("choices", 0, "message", "content")
      @recipe = JSON.parse(raw_response)
    rescue OpenAI::Error => e
      @error_message = "AIとの通信中にエラーが発生しました: #{e.message}"
    rescue JSON::ParserError => e
      @error_message = "AIからの応答を正しく解析できませんでした。もう一度お試しください。"
    end
    render :new, status: :ok
  end
end
