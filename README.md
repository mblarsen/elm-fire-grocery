# Simple Grocery List in Elm

This is a tiny project with the sole purpose of learning Elm.

Functionality:

- [X] Add new items
- [X] Persist items
- [X] Mark as purchased 
- [X] Unmark again
- [X] Marke shopping complete (archive all but save for later reuse)
- [X] Reuse archived item
- [X] Persist 
- [X] Use Sass to build Bulma.io + app css
- [ ] Style for mobile
- [ ] Add app icons
- [ ] Use Firebase
- [ ] Add auth

# Getting started

## Install:

    elm-package install
    npm install

## Build:

    npm run build

## Develop

Be sure to configure your firebase database in `config.js`.

(TODO: implement above section)

Then start the webpack dev server:

    npm run dev

## Deploy

Be sure to install `firebase-tools`:

    npm install -g firebase-tools

Then when configured:

    firebase deploy

(be sure `npm run build` has been run first so that `dist` has been created)
