/* jshint node: true, asi: true */
/* global firebase, window, document */
'use strict';

require('./sass/app.sass')
require('font-awesome/css/font-awesome.css')

// Initialize Firebase
firebase.initializeApp(require('../config.js'))
var database = firebase.database()

// Embed Elm
var Elm = require('./Main.elm')
var mountNode = document.getElementById('main')
var list = window.location.hash.substr(1)
list = list ? list : 'demo'
console.log(list)
var app = Elm.Main.embed(mountNode, { list: list })

// Get values from Firebase
var listRef = null
app.ports.changeList.subscribe(function (list) {
    if (listRef) listRef.off()
    listRef = database.ref('list/' + list + '/items/')
    listRef.on('value', function (snapshot) {
        app.ports.listItems.send(snapshot.val())
    })
});

// Push change to Firebase
app.ports.fbPush.subscribe(function (item) {
    var id = item.id
    delete item.id
    if (id === null) {
        listRef.push(item)
    } else {
        listRef.child(id).set(item)
    }
})
// Remove item
app.ports.fbRemove.subscribe(function (id) {
    listRef.child(id).remove()
})
