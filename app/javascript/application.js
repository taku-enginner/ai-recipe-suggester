// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("DOMContentLoaded", () => {
    // formタグをform変数に入れる
    const form = document.querySelector("form");

    // レシピ送信ボタンのIDを変数に入れる
    const submitButton = document.getElementById("recipe-submit-button"); 

    // ロード中のマークを変数に入れる
    const loadingIndicator = document.getElementById("loading-indicator");

    // formという変数があるならというif文
    if (form) {
        // フォームが送信された瞬間を監視
        form.addEventListener("submit", () => {
            submitButton.disabled = true;
            submitButton.value = "考え中..";
            loadingIndicator.classList.remove("hidden");
        });
    }

});
import "channels"
