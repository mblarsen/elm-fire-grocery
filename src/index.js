'use strict';

require('bulma/bulma.sass')
require('./sass/app.sass')
require('font-awesome/css/font-awesome.css')

// Require index.html so it gets copied to dist
require('./index.html')

// Initialize Firebase
firebase.initializeApp(require('../config.js'))
var database = firebase.database()

// Embed Elm
var Elm = require('./Main.elm')
var mountNode = document.getElementById('main')
var app = Elm.Main.embed(mountNode)

// Get values from Firebase
var listRef = null
app.ports.changeList.subscribe(function (list) {
    if (listRef) listRef.off()
    listRef = database.ref('list/' + list + '/')
    listRef.on('value', function (snapshot) {
        app.ports.listItems.send(snapshot.val())
    })
});

// Push change to Firebase
app.ports.fbPush.subscribe(function (item) {
    item = JSON.parse(item)
    var id = item.id
    delete item.id
    if (id === "") {
        listRef.push(item)
    } else {
        listRef.child(id).set(item)
    }
})
