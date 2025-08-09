class RecipesController < ApplicationController
  def new
    @recipe = nil
  end

  def create
    ingredients = params[:ingredients]

    begin
      # ユーザーを待たせることなく次の画面にリダイレクトする
      respond_to do |format|
        # Active Jobにキューを入れる
        ApiCommunicationJob.perform_later(ingredients)
        
        #フラッシュメッセージをセット
        #flash.now[:notice] = '処理を開始しました。完了までしばらくお待ちください。'

        # Turbo Streamのレスポンスを返す
        format.turbo_stream

        # HTMLリクエストにも対応
        format.html { redirect_to root_path, notice: flash[:notice], status: :see_other }
      end
    rescue OpenAI::Error => e
      @error_message = "AIとの通信中にエラーが発生しました: #{e.message}"
    rescue JSON::ParserError => e
      @error_message = "AIからの応答を正しく解析できませんでした。もう一度お試しください。"
    end
    #render :new, status: :ok
  end
end
