importScripts('https://www.gstatic.com/firebasejs/9.17.2/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.17.2/firebase-messaging-compat.js');

firebase.initializeApp({
    // Firebase 설정 정보
    apiKey: 'AIzaSyA0y29Vlz8ABQDTZG6k0amd2z6q4a1js3I',
    appId: '1:575239767004:web:3a6512f6a4d4c143710519',
    messagingSenderId: '575239767004',
    projectId: 'myfirebasefluttertest-80764',
    authDomain: 'myfirebasefluttertest-80764.firebaseapp.com',
    storageBucket: 'myfirebasefluttertest-80764.appspot.com',
    measurementId: 'G-BM7FB4ZMY9',
});

const messaging = firebase.messaging();

// 백그라운드에서 수신한 알림 처리 로직
messaging.onBackgroundMessage((payload) => {
    console.log('[firebase-messaging-sw.js] Received background message ', payload);

    const notificationTitle = 'Background Message Title';
    const notificationOptions = {
        body: 'Background Message body.',
        icon: '/firebase-logo.png'
    };

    self.registration.showNotification(notificationTitle,
        notificationOptions);
});