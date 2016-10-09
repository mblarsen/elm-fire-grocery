module Items.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onCheck, onInput)
import Html.Keyed as Keyed
import Items.Messages exposing (..)
import Items.Models exposing (Item, ItemId)


view : List Item -> Html Msg
view items =
    let
        wrapSection =
            wrapMaybe "section column is-offset-3 is-6"

        wrapListSection =
            wrapListMaybe "section column is-offset-3 is-6"
    in
        div []
            [ wrapSection <| incompleteSection items
            , wrapSection <| completeSection items
            , wrapListSection <| doneShopping items
            , wrapListSection <| commonItemsSection items
            ]


wrapMaybe : String -> Maybe (Html Msg) -> Html Msg
wrapMaybe classes maybeNode =
    case maybeNode of
        Nothing ->
            text ""

        Just node ->
            div [ class classes ] [ node ]


wrapListMaybe : String -> Maybe (List (Html Msg)) -> Html Msg
wrapListMaybe classes maybeList =
    case maybeList of
        Nothing ->
            text ""

        Just elements ->
            div [ class classes ] elements


doneShopping : List Item -> Maybe (List (Html Msg))
doneShopping items =
    if items |> isActive |> List.isEmpty then
        Nothing
    else
        Just
            ((clearCompletedButton items)
                ++ [ button [ class "button is-link", onClick DoneShopping ] [ text "Clear All" ] ]
            )


clearCompletedButton : List Item -> List (Html Msg)
clearCompletedButton items =
    case items |> complete |> List.isEmpty of
        True ->
            []

        False ->
            [ button
                [ class "button is-primary", onClick ArchiveSelected ]
                [ text "Clear Completed" ]
            , text " "
            ]


isActive : List Item -> List Item
isActive items =
    items |> List.filter (not << .archived)


incomplete : List Item -> List Item
incomplete items =
    items
        |> isActive
        |> List.filter (not << .done)


complete : List Item -> List Item
complete items =
    items
        |> isActive
        |> List.filter .done


incompleteSection : List Item -> Maybe (Html Msg)
incompleteSection items =
    let
        itemNodes =
            items
                |> incomplete
                |> List.sortBy .name
                |> List.map activeItem

        headerNode =
            h1 [ class "title is-4" ] [ text "We Need" ]
    in
        if List.isEmpty itemNodes then
            Just <| p [] [ text "Add new items or scroll down to add commonly purchased items." ]
        else
            Just <| Keyed.node "div" [] (( "", headerNode ) :: itemNodes)


completeSection : List Item -> Maybe (Html Msg)
completeSection items =
    let
        itemNodes =
            items
                |> complete
                |> List.sortBy .name
                |> List.map activeItem

        headerNode =
            h2 [ class "title is-6" ] [ text "Bought" ]
    in
        if List.isEmpty itemNodes then
            Nothing
        else
            Just <| Keyed.node "div" [] (( "", headerNode ) :: itemNodes)


activeItem : Item -> ( String, Html Msg )
activeItem item =
    ( (toString item.id)
    , div
        [ class "Item--active" ]
        [ p [ class "control" ]
            [ label [ class "checkbox" ]
                [ input
                    [ type' "checkbox"
                    , id (toString item.id)
                    , checked item.done
                    , onCheck (ToggleItem item)
                    ]
                    []
                , text " "
                , text item.name
                ]
            , span [ class "icon is-small", onClick (RemoveItem item) ] [ i [ class "fa fa-times" ] [] ]
            ]
        ]
    )


commonItemsSection : List Item -> Maybe (List (Html Msg))
commonItemsSection items =
    Just
        [ h1 [ class "title is-4" ] [ text "Common Items" ]
        , div [] [ (archivedList items) ]
        ]


archivedList : List Item -> Html Msg
archivedList items =
    div [ class "section" ]
        (items
            |> List.filter (\i -> i.archived == True)
            |> List.sortBy .name
            -- |> List.sortWith sortOrder
            |>
                List.map archivedItem
        )


sortOrder : Item -> Item -> Order
sortOrder a b =
    case compare a.used b.used of
        LT ->
            GT

        GT ->
            LT

        EQ ->
            compare a.name b.name


archivedItem : Item -> Html Msg
archivedItem item =
    div [ class "Item--archived", onClick (ReuseItem item) ]
        [ span [ class "icon" ] [ i [ class "fa fa-plus-circle" ] [] ]
        , text (item.name ++ " (" ++ (toString item.used) ++ ")")
        , span [ class "icon is-small remove", onClick (DeleteItem (getItemId item)) ] [ i [ class "fa fa-times" ] [] ]
        ]


getItemId : Item -> ItemId
getItemId item =
    case item.id of
        Just id ->
            id

        Nothing ->
            ""
