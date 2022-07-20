importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyCaCSJ0BZItSyXqBv8vpD1N4WBffJeKhLQ",
  authDomain: "grofresh-3986f.firebaseapp.com",
  projectId: "grofresh-3986f",
  storageBucket: "grofresh-3986f.appspot.com",
  messagingSenderId: "250728969979",
  appId: "1:250728969979:web:b79642a7b2d2400b75a25e",
  databaseURL: "...",
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});