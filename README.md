# Simple Grocery List in Elm and Firebase

This is a tiny project with the sole purpose of learning Elm.

Functionality:

- [ ] Items
    - [X] Add
    - [X] Mark as purchased
    - [X] Unmark
    - [X] Mark shopping complete (archive all)
    - [X] Reuse archived items
    - [ ] Delete
- [ ] Lists
    - [ ] Create
    - [ ] Switch
    - [ ] Delete
- [ ] Hook up to Firebase
- [ ] Mobile friendly

# Getting started

## Install:

    elm-package install
    npm install

## Build:

    npm run build

## Develop

Be sure to configure your firebase database in `config.js`. Copy
`config.example.js` to get started.

Then start the webpack dev server:

    npm run dev

## Deploy

Be sure to install `firebase-tools`:

    npm install -g firebase-tools

Then when configured:

    firebase deploy

(be sure `npm run build` has been run first so that `dist` has been created)
