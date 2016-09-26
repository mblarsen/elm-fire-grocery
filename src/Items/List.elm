module Items.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onCheck, onInput)
import Html.Keyed as Keyed
import Items.Messages exposing (..)
import Items.Models exposing (Item)


view : List Item -> Html Msg
view items =
    div []
        [ (incompleteSection items)
        , (completeSection items)
        , (doneShopping items)
        , h1 [] [ text "Archived" ]
        , div [] [ (archivedList items) ]
        ]


doneShopping : List Item -> Html Msg
doneShopping items =
    if items |> isActive |> List.isEmpty then
        div [] []
    else
        div []
            [ button [ class "button is-regular", onClick DoneShopping ] [ text "Done Shopping" ]
            ]


isActive : List Item -> List Item
isActive items =
    items
        |> List.filter (not << .archived)


incomplete : List Item -> List Item
incomplete items =
    items |> isActive |> List.filter (not << .done)


complete : List Item -> List Item
complete items =
    items |> isActive |> List.filter .done


incompleteSection : List Item -> Html Msg
incompleteSection items =
    let
        itemNodes =
            items
                |> incomplete
                |> List.map activeItem

        headerNode =
            h1 [] [ text "Get these items" ]
    in
        if List.isEmpty itemNodes then
            div [] [ text "Add new items or scroll down to add commonly purchased items." ]
        else
            div [] (headerNode :: itemNodes)


completeSection : List Item -> Html Msg
completeSection items =
    let
        itemNodes =
            items
                |> complete
                |> List.map activeItem

        headerNode =
            h2 [] [ text "In the basket" ]
    in
        if List.isEmpty itemNodes then
            div [] []
        else
            div [] (headerNode :: itemNodes)


activeItem : Item -> Html Msg
activeItem item =
    Keyed.node "div"
        [ class "Item--active" ]
        [ ( (toString item.id)
          , label []
                [ input
                    [ type' "checkbox"
                    , id (toString item.id)
                    , checked item.done
                    , onCheck (ToggleItem item)
                    ]
                    []
                , text item.name
                ]
          )
        ]


archivedList : List Item -> Html Msg
archivedList items =
    div [] (List.filter (\i -> i.archived == True) items |> List.map archivedItem)


archivedItem : Item -> Html Msg
archivedItem item =
    div [ class "Item--active" ]
        [ text item.name
        , i
            [ class "fa fa-plus-circle"
            , onClick (ReuseItem item)
            ]
            []
        ]
