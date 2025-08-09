import consumer from "./consumer"

consumer.subscriptions.create("RecipeChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("サブスクライブ成功")
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log("レシーブメソッド起動");

    const recipeResultArea = document.getElementById("recipe-result-area");
    recipeResultArea.innerHTML = '';

    if (data){
        let htmlContent = `
            <div class="mt-8 bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4" id="recipe_detail">
              <h2 class="text-2xl font-bold mb-2">${data.recipeName}</h2>
              <p class="text-gray-700 mb-4">${data.description}</p>
              
              <h3 class="text-xl font-semibold mb-2">材料</h3>
              <ul class="list-disc list-inside mb-4">
                ${data.ingredients.map(ingredient => `
                  <li>${ingredient.name} - ${ingredient.quantity}</li>
                `).join('')}
              </ul>

              <h3 class="text-xl font-semibold mb-2">手順</h3>
              <ol class="list-decimal list-inside">
                ${data.instructions.map(instruction => `
                  <li>${instruction}</li>
                `).join('')}
              </ol>
            </div>
        `;
        recipeResultArea.innerHTML = htmlContent;
    }

    // ボタンとローディング表示をこの場所で取得
    const submitButton = document.getElementById("recipe-submit-button");
    const loadingIndicator = document.getElementById("loading-indicator");

    // ボタンの状態を更新
    if (submitButton) {
        submitButton.disabled = false;
        submitButton.value = "別のレシピを提案してもらう";
    }

    // ローディング表示を隠す
    if (loadingIndicator) {
        loadingIndicator.classList.add("hidden");
    }
  }
});
