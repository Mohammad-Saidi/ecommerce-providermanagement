const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const {initializeApp} = require("firebase-admin/app");
const {getMessaging} = require("firebase-admin/messaging");
const {setGlobalOptions} = require("firebase-functions/v2");
const {logger} = require("firebase-functions");
initializeApp();
const msg = getMessaging();
setGlobalOptions({maxInstances: 10});

exports.sendOrderNotification = onDocumentCreated("/Order/{id}", (event) => {
  const id = event.params.id;
  const payload = {
    notification: {
      title: "New Order",
      body: "You have a new order",
    },
    data: {
      key: "neworder",
      value: id,
    },
  };
  msg.sendToTopic("order", payload);
  logger.log("message sent");
});
