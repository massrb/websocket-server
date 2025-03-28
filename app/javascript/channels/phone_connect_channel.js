import consumer from "channels/consumer"

consumer.subscriptions.create("PhoneConnectChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("connected in JS")
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log('in js received')
    // Called when there's incoming data on the websocket for this channel
    const messages = document.querySelector("#messages")
    messages.insertAdjacentHTML("beforeend", `<p>${data.content}</p>`)
    messages.lastElementChild.scrollIntoView({behavior: "smooth"})
  }
});
