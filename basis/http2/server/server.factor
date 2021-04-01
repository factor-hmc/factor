USING: http http.server kernel io.servers ;

IN: http2.server

TUPLE: http2-server < http-server ;

: start-http2-connection ( threaded-server prev-req/f -- )
    2drop
    ! TODO: establish http2 connection and carry out requests
    ;
! stack effect: ( threaded-server -- )
M: http2-server handle-client*
    t ! check if this is a secure connection or not
      ! see remote-address variable?
    [ t ! get tls(1.2?) negotiated thing
      [ f start-http2-connection ] ! if h2, send prefix and start full http2
      [ call-next-method ] ! else, revert to http1?
      if ] ! secure case
    [ ! read initial request as http1
      t ! check if it asks for upgrade
      [ start-http2-connection ] ! if so, send 101 switching protocols response, start http2,
          ! including sending prefix and response to initial request.
      [ ] ! else, finish processing as http1.
      if ] ! insecure case
    if
    ;


