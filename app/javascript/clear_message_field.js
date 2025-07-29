console.log("clear_message_field.js loaded");

document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("message_form");
  if (form) {
    form.addEventListener("submit", (event) => {
      setTimeout(() => {
        document.getElementById("message_content").value = "";
      }, 100);
    });
  }
});
