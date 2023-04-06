import consumer from "./consumer"

const subscription = consumer.subscriptions.create("RateChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },
  received(data) {
    console.log(data)
    // Called when there's incoming data on the websocket for this channel
    const rateValue = JSON.parse(data.rate).rate;
    document.querySelector("#rate p").textContent = rateValue;
  }
});
if (window.location.pathname === '/admin') {
  console.log("leave from admin")
  subscription.unsubscribe();
}