var admin = require("firebase-admin");

var serviceAccount = require("../frontend/serviceAccountKey.json");

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://wired-bf519-default-rtdb.asia-southeast1.firebasedatabase.app",
});

function sendNotification({regToken, notifTitle, notifbody}){
    var message = {
        notification: {
            title: notifTitle,
            body: notifbody,
        },
        token: regToken,
    };
    admin
    .messaging()
    .send(message)
    .then((response) => {
        // Response is a message ID string.
        console.log("Successfully sent message:", response);
    })
    .catch((error) => {
        console.log("Error sending message:", error);
    });
}


    module.exports=sendNotification;