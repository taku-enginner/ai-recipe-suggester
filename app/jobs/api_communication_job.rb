class ApiCommunicationJob < ApplicationJob
  queue_as :default # ジョブをキューに入れる場所を指定

  def perform(ingredients)
    # ここに時間のかかる処理（API通信）を記述する
    puts "API通信を開始します..."
    #sleep(10) # 処理に時間がかかることをシミュレーション
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
    response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [{ role: "user", content: prompt }],
        response_format: { type: "json_object" },
        temperature: 0.7, # 創造性。0に近いほど決定的。0.7は安定した応答を得やすい
      }
    )
    # JSON文字列をRubyのハッシュにパースする
    raw_response = response.dig("choices", 0, "message", "content")
    recipe_data = JSON.parse(raw_response)
    
    puts "ブロードキャストを開始します..."
    puts recipe_data
    # 取得したレシピデータをActionCableでブロードキャスト.サーバー側の送信とクライアント側の受信が起こる。
    ActionCable.server.broadcast("all_recipes_channel", recipe_data)
    puts "ブロードキャストが完了しました"

    puts "API通信が完了しました！"
  end
end
