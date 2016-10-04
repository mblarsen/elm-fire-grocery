module View exposing (..)

import Html exposing (..)
import Html.App
import Html.Attributes exposing (class, placeholder, value)
import Html.Events exposing (onInput, onClick)
import Messages exposing (Msg(..))
import Models exposing (Model)
import Items.List
import Items.Models exposing (ItemId)


view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ hero
        , page model
        ]


hero : Html Msg
hero =
    section [ class "hero is-warning" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ]
                    [ text "Grocery List" ]
                ]
            ]
        ]


page : Model -> Html Msg
page model =
    div [ class "container" ]
        [ dontForget model
        , Html.App.map ItemsMsg (Items.List.view model.items)
        ]


dontForget : Model -> Html Msg
dontForget model =
    div [ class "section column is-offset-3 is-6" ]
        [ div [ class "control is-grouped" ]
            [ p [ class "control is-expanded" ] [ input [ class "input", placeholder "Add new item, or choose from below...", onInput UpdateName, value model.newItem.name ] [] ]
            , p [ class "control" ]
                [ button [ class "button is-primary", onClick AddNew ] [ text "Add" ]
                ]
            ]
        ]
