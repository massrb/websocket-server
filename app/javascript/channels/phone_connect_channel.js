import consumer from "channels/consumer"

consumer.subscriptions.create("PhoneConnectChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("connected in JS")
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  // server broadcast to channel is recieved here
  received(data) {
    console.log('in js received', data);

    const messages = document.querySelector("#messages");
    if (messages && data.id && data.content) {
      const html = `
        <div id="message_${data.id}">
          <p>${data.content}</p>
        </div>
      `;

    messages.insertAdjacentHTML("beforeend", html);
    messages.lastElementChild.scrollIntoView({ behavior: "smooth" });
  }
}});
