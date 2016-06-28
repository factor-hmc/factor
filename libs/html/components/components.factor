! Copyright (C) 2008, 2010 Slava Pestov, Daniel Ehrenberg
! See http://factorcode.org/license.txt for BSD license.
USING: accessors kernel namespaces io math.parser assocs classes
classes.tuple words arrays sequences splitting mirrors
hashtables combinators continuations math strings inspector
fry locals calendar calendar.format xml.entities xml.data
validators urls present xml.writer xml.syntax xml
xmode.code2html lcs.diff2html farkup io.streams.string
html html.streams html.forms ;
IN: html.components

GENERIC: render* ( value name renderer -- xml ) ;

: render>xml ( name renderer -- xml )
    prepare-value
    [
        dup validation-error-state?
        [ [ message>> render-error ] [ value>> ] bi ]
        [ f swap ]
        if
    ] 2dip
    render*
    swap 2array ;

: render ( name renderer -- )
    render>xml write-xml ;

PRIVATE<

GENERIC: write-nested ( obj -- ) ;

M: string write-nested write ;

M: sequence write-nested [ write-nested ] each ;

PRIVATE>

: render-string ( name renderer -- )
    render>xml write-nested ;

SINGLETON: label

M: label render*
    2drop present ;

SINGLETON: hidden

M: hidden render*
    drop XML-CHUNK[[ <input value=<-> name=<-> type="hidden"/> ]] ;

: render-field ( value name size type -- xml )
    XML-CHUNK[[ <input value=<-> name=<-> size=<-> type=<->/> ]] ;

TUPLE: field size ;

: <field> ( -- field )
    field new ;

M: field render*
    size>> "text" render-field ;

TUPLE: password size ;

: <password> ( -- password )
    password new ;

M: password render*
    ! Don't send passwords back to the user
    [ drop "" ] 2dip size>> "password" render-field ;

! Text areas
TUPLE: textarea rows cols ;

: <textarea> ( -- renderer )
    textarea new ;

M:: textarea render* ( value name area -- xml )
    area rows>> set: rows
    area cols>> set: cols
    XML-CHUNK[[
         <textarea
            name=<-name->
            rows=<-rows->
            cols=<-cols->><-value-></textarea>
    ]] ;

! Choice
TUPLE: choice size multiple choices ;

: <choice> ( -- choice )
    choice new ;

: render-option ( text selected? -- xml )
    "selected" and swap
    XML-CHUNK[[ <option selected=<->><-></option> ]] ;

: render-options ( value choice -- xml )
    [ choices>> value ] [ multiple>> ] bi
    [ swap ] [ swap 1array ] if
    $[ dup _ member? render-option ] map ;

M:: choice render* ( value name choice -- xml )
    choice size>> set: size
    choice multiple>> "true" and set: multiple
    value choice render-options set: contents
    XML-CHUNK[[ <select
        name=<-name->
        size=<-size->
        multiple=<-multiple->><-contents-></select> ]] ;

! Checkboxes
TUPLE: checkbox label ;

: <checkbox> ( -- checkbox )
    checkbox new ;

M: checkbox render*
    [ "true" and ] [ ] [ label>> ] tri*
    XML-CHUNK[[ <input
        type="checkbox"
        checked=<-> name=<->><-></input> ]] ;

! Link components
GENERIC: link-title ( obj -- string ) ;
GENERIC: link-href ( obj -- url ) ;

M: string link-title ;
M: string link-href ;

M: url link-title ;
M: url link-href ;

TUPLE: simple-link title href ;

C: <simple-link> simple-link ;

M: simple-link link-title title>> ;
M: simple-link link-href href>> ;

TUPLE: link target ;

M: link render*
    nip swap
    [ target>> ] [ [ link-href ] [ link-title ] bi ] bi*
    XML-CHUNK[[ <a target=<-> href=<->><-></a> ]] ;

! XMode code component
TUPLE: code mode ;

: <code> ( -- code )
    code new ;

M: code render*
    [ string-lines ] [ drop ] [ mode>> value ] tri* htmlize-lines ;

! Farkup component
TUPLE: farkup no-follow disable-images parsed ;

: <farkup> ( -- farkup )
    farkup new ;

: string>boolean ( string -- boolean )
    {
        { "true" [ t ] }
        { "false" [ f ] }
        { f [ f ] }
    } case ;

M: farkup render*
    [
        nip
        [ no-follow>> [ string>boolean link-no-follow? set ] when* ]
        [ disable-images>> [ string>boolean disable-images? set ] when* ]
        [ parsed>> string>boolean [ (write-farkup) ] [ farkup>xml ] if ]
        tri
    ] with-scope ;

! Inspector component
SINGLETON: inspector

M: inspector render*
    2drop [ describe ] with-html-writer ;

! Diff component
SINGLETON: comparison

M: comparison render*
    2drop htmlize-diff ;

! HTML component
SINGLETON: html

M: html render* 2drop dup string? [ <unescaped> ] when ;

! XML component
SINGLETON: xml

M: xml render* 2drop ;