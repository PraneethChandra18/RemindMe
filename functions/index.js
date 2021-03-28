const functions = require("firebase-functions");
const admin = require("firebase-admin");


admin.initializeApp();
var db = admin.firestore();
var fcm = admin.messaging();


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

exports.notifyNewFeed = functions.firestore
    .document('data/{userId}/feed/{notificationId}')
    .onCreate(async (snapshot) => {
        const message = snapshot.data();

        var subscribers = "";

        await db.collection('Users').doc(message.senderId).get()
                                 .then(doc => {
                                   if(!doc.exists) {
                                       throw new Error('No such User document!');
                                   } else {
                                       subscribers = doc.data().subscribers.join();
                                       console.log(subscribers);
                                   }
                                 })
                                 .catch(err => {
                                         console.log('Error getting document', err);
                                         return false;
                                 });

        const payload = {
                    notification: {
                        title: message.by,
                        body: message.title,
                        clickAction: "FLUTTER_NOTIFICATION_CLICK",
                    },
                    data: {
                        "subscribers" : subscribers,
                    }
                };

       return db.collection('Tokens').doc("Device Tokens").get()
                         .then(doc => {
                           if(!doc.exists) {
                               console.log('No such document');
                               throw new Error('No such User document!');
                           } else {
                               console.log('Document data:', doc.data().tokens);
                               fcm.sendToDevice(doc.data().tokens, payload);
                           }
                         })
                         .catch(err => {
                                 console.log('Error getting document', err);
                                 return false;
                         });
});

exports.notifyNewReminder = functions.firestore
    .document('data/{userId}/reminders/{notificationId}')
    .onCreate(async (snapshot) => {
        const message = snapshot.data();

        var subscribers = "";

        await db.collection('Users').doc(message.senderId).get()
                                 .then(doc => {
                                   if(!doc.exists) {
                                       throw new Error('No such User document!');
                                   } else {
                                       subscribers = doc.data().subscribers.join();
                                       console.log(subscribers);
                                   }
                                 })
                                 .catch(err => {
                                         console.log('Error getting document', err);
                                         return false;
                                 });

        const payload = {
                    notification: {
                        title: message.by,
                        body: message.title,
                        clickAction: "FLUTTER_NOTIFICATION_CLICK",
                    },
                    data: {
                        "subscribers" : subscribers,
                    }
                };

       return db.collection('Tokens').doc("Device Tokens").get()
                         .then(doc => {
                           if(!doc.exists) {
                               console.log('No such document');
                               throw new Error('No such User document!');
                           } else {
                               console.log('Document data:', doc.data().tokens);
                               fcm.sendToDevice(doc.data().tokens, payload);
                           }
                         })
                         .catch(err => {
                                 console.log('Error getting document', err);
                                 return false;
                         });
});