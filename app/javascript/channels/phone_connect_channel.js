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
    console.log('in js received', data)
    // Called when there's incoming data on the websocket for this channel
    const messages = document.querySelector("#messages")
    if (messages) {
      console.log('insert html', data.content)
      messages.insertAdjacentHTML("beforeend", data.content)
      messages.lastElementChild.scrollIntoView({behavior: "smooth"})
    }
  }
});
