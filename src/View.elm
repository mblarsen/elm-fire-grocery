module View exposing (..)

import Html exposing (..)
import Html.App
import Html.Attributes exposing (class, placeholder)
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
        [ dontForget
        , Html.App.map ItemsMsg (Items.List.view model.items)
        ]


dontForget : Html Msg
dontForget =
    div []
        [ h1 [] [ text "Don't forget" ]
        , input [ placeholder "Apples?", onInput NameItem ] []
        , button
            [ class "button is-success"
            , onClick AddNew
            ]
            [ text "Add" ]
        ]
