-> NOREV
OPT PREPROCESS
OPT OSVERSION=39

#ifdef PPC
OPT MORPHOS
OPT REG=-1
#endif

MODULE  'bsdsocket'
MODULE  'amitcp/sys/socket'
MODULE  'amitcp/netinet/in'

MODULE  'dos/dosextens'

MODULE 'openssl/bio'

MODULE 'amissl'
MODULE 'amisslmaster'
MODULE 'amissl/tags'
MODULE 'amissl/misc'
MODULE 'libraries/amissl'
MODULE 'libraries/amisslmaster'

#define FPrintf(out, str) WriteF(str)
#define Printf(str, arg) WriteF(str, arg)

PROC errorOutput()
  DEF tc:PTR TO process
  tc:=FindTask(NIL)
ENDPROC tc.ces

PROC getStdErr()
  DEF err
  err := errorOutput()
ENDPROC IF err THEN err ELSE Output()

/* The program expects at most four arguments: host in IP format, port
 * number to connect to, proxy in IP format and proxy port number.
 * If last two are specified, host can be in any format proxy will
 * understand (since this is an example for SSL programming, host name
 * resolving code is left out).
 *
 * Default values are '127.0.0.1', 443. If any proxy parameter is
 * omitted, the program will connect directly to the host.
 */

PROC main()
  DEF buffer[4096]:ARRAY /* This should be dynamically allocated */
  DEF request:PTR TO CHAR
  DEF is_ok = FALSE
  DEF server_cert:PTR TO LONG->X509
  DEF ctx:PTR TO LONG->SSL_CTX
  DEF bio_err:PTR TO LONG->BIO
  DEF ssl:PTR TO LONG->SSL

  DEF sock
  DEF ssl_err
  DEF str:PTR TO CHAR

  DEF argt[6]:ARRAY OF LONG, argc=0
  DEF c=0

  request := 'GET / HTTP/1.0\r\n\r\n'

  -> E-Note: parsing space separated arguments from 'arg' to argt array, argt[0] is broken and just a copy of first argument
  argt[argc++]:=arg
  WHILE arg[c]
    IF arg[c] = " "
      arg[c] := 0
      argt[argc++]:=arg
      arg:=arg + c + 1
      c:=0
    ELSE
      c++
    ENDIF

    EXIT argc > 4
  ENDWHILE
  IF argc < 5 THEN argt[argc++]:=arg

  IF init()
    /* Basic intialization. Next few steps (up to SSL_new()) need
     * to be done only once per AmiSSL opener.
     */

    ssLeay_add_ssl_algorithms()
    ssL_load_error_strings()

    /* Note: BIO writing routines are prepared for NULL BIO handle */
    IF (bio_err := BiO_new(BiO_s_file())) <> NIL THEN
      BiO_set_fp_amiga(bio_err, getStdErr(), BIO_NOCLOSE OR BIO_FP_TEXT)

    /* Get a new SSL context */
    IF (ctx := SsL_CTX_new( SsLv23_client_method() )) <> NIL

      /* Basic certificate handling. OpenSSL documentation has more
       * information on this.
       */
      SsL_CTX_set_default_verify_paths(ctx)
      SsL_CTX_set_verify(ctx, SSL_VERIFY_PEER OR SSL_VERIFY_FAIL_IF_NO_PEER_CERT,NIL)

      /* The following needs to be done once per socket */
      IF (ssl := SsL_new(ctx)) <> NIL

        /* Connect to the HTTPS server, directly or through a proxy */
        IF (argc > 4)
          sock := connectToServer(argt[1], Val(argt[2]), argt[3], Val(argt[4]))
        ELSE
          sock := connectToServer(IF argt[1] THEN argt[1] ELSE '127.0.0.1', IF argc > 2 THEN Val(argt[2]) ELSE 443, NIL, 0)
        ENDIF

        /* Check if connection was established */
        IF sock >= 0
          ssl_err := 0

          /* Associate the socket with the ssl structure */
          SsL_set_fd(ssl, sock)

          /* Perform SSL handshake */
          IF (ssl_err := SsL_connect(ssl)) >= 0
            Printf('SSL connection using \s\n', SsL_get_cipher(ssl))

            /* Certificate checking. This example is *very* basic */
            IF server_cert := SsL_get_peer_certificate(ssl)

              Printf('Server certificate:\n','')

              IF str := Xu09_NAME_oneline(Xu09_get_subject_name(server_cert), 0, 0)
                Printf('\tSubject: \s\n', str)
                OpENSSL_free(str)
              ELSE
                WriteF('Warning: couldnt read subject name in certificate!\n')
              ENDIF

              IF (str := Xu09_NAME_oneline(Xu09_get_issuer_name(server_cert),0, 0)) <> NIL
                Printf('\tIssuer: \s\n', str)
                OpENSSL_free(str)
              ELSE
                WriteF('Warning: couldn"t read issuer name in certificate!\n')
              ENDIF
              Xu09_free(server_cert)

              /* Send a HTTP request. Again, this is just
               * a very basic example.
               */
              IF (ssl_err := SsL_write(ssl, request, StrLen(request))) > 0
                /* Dump everything to output */
                WHILE (ssl_err := SsL_read(ssl, buffer, 1024  - 1)) > 0
                  Write(Output(), buffer, ssl_err)
                ENDWHILE

                ->no need to flush since we're using Write()
                ->Fflush(Output())

                /* This is not entirely true, check
                 * the SSL_read documentation
                 */
                is_ok := ssl_err = 0
              ELSE
                WriteF('Couldnt write request!\n')
              ENDIF

            ELSE
              WriteF('Couldnt get server certificate!\n')
            ENDIF

          ELSE
            WriteF('Couldnt establish SSL connection!\n')
          ENDIF

          /* If there were errors, print them */
          IF ssl_err < 0 THEN
            ErR_print_errors(bio_err)

          /* Send SSL close notification and close the socket */
          SsL_shutdown(ssl)
          CloseSocket(sock)

        ELSE
          WriteF('Couldnt connect to host!\n')
        ENDIF

        WriteF('before SSL_free()\n')
        SsL_free(ssl)
      ELSE
        WriteF('Couldnt create new SSL handle!\n')
      ENDIF

      WriteF('before SSL_CTX_free()\n')
      SsL_CTX_free(ctx)
    ELSE
      WriteF('Couldnt create new context!\n')
    ENDIF

    WriteF('before Cleanup()\n')
    cleanup()
  ENDIF

  WriteF('before end of main()\n')
ENDPROC

/* Open and initialize AmiSSL */
PROC init()
  DEF is_ok = FALSE
  DEF errno

  IF (socketbase := OpenLibrary('bsdsocket.library', 4)) = 0
    WriteF('Couldnt open bsdsocket.library v4!\n')

  ELSEIF (amisslmasterbase := OpenLibrary('amisslmaster.library', AMISSLMASTER_MIN_VERSION)) = 0
    WriteF('Couldnt open amisslmaster.library v\d!\n', AMISSLMASTER_MIN_VERSION)

  ELSEIF InitAmiSSLMaster(AMISSL_CURRENT_VERSION, TRUE) = 0
    WriteF('AmiSSL version is too old!\n')

  ELSEIF (amisslbase := OpenAmiSSL()) = 0
    WriteF('Couldnt open AmiSSL!\n')

  ELSEIF InitAmiSSLA([AMISSL_ERRNOPTR, {errno}, AMISSL_SOCKETBASE, socketbase, TAG_DONE]) <> 0
    WriteF('Couldnt initialize AmiSSL!\n')

  ELSE
    is_ok := TRUE

  ENDIF

  IF is_ok = 0 THEN
    cleanup() /* This is safe to call even if something failed above */

ENDPROC is_ok

PROC cleanup()
  IF amisslbase
    CleanupAmiSSLA([TAG_DONE])

    CloseAmiSSL()
    amisslbase := NIL
  ENDIF

  CloseLibrary(amisslmasterbase)
  amisslmasterbase := NIL

  CloseLibrary(socketbase)
  socketbase := NIL
ENDPROC

/* Connect to the specified server, either directly or through the specified
 * proxy using HTTP CONNECT method.
 */

PROC connectToServer(host:PTR TO CHAR, port, proxy:PTR TO CHAR, pport)
  DEF addr:sockaddr_in
  DEF buffer[1024]:ARRAY /* This should be dynamically alocated */
  DEF is_ok = FALSE
  DEF s1:PTR TO CHAR, s2:PTR TO CHAR
  DEF sock
  DEF len

  WriteF('Trying to connect to host: "\s" on port: \d\n', host, port)

  /* Create a socket and connect to the server */
  IF (sock := Socket(AF_INET, SOCK_STREAM, 0)) >= 0
    memset(addr, 0, SIZEOF sockaddr_in)
    addr.family := AF_INET

    IF (proxy<>0) AND (pport<>0)
      addr.addr.addr := Inet_addr(proxy) /* This should be checked against INADDR_NONE */
      addr.port := pport
    ELSE
      addr.addr.addr := Inet_addr(host) /* This should be checked against INADDR_NONE */
      addr.port := port
    ENDIF

    IF Connect(sock, addr, SIZEOF sockaddr_in) >= 0

      /* For proxy connection, use SSL tunneling. First issue a HTTP CONNECT
       * request and then proceed as with direct HTTPS connection.
       */
      IF (proxy<>0) AND (pport<>0)

        /* This should be done with snprintf to prevent buffer
         * overflows, but some compilers don"t have it and
         * handling that would be an overkill for this example
         */
        StringF(buffer, 'CONNECT \s:\d HTTP/1.0\r\n\r\n', host, port)

        /* In a real application, it would be necessary to loop
         * until everything is sent or an error occurrs, but here we
         * hope that everything gets sent at once.
         */
        IF Send(sock, buffer, StrLen(buffer), 0) >= 0

          /* Again, some optimistic behaviour: HTTP response might not be
           * received with only one recv
           */
          IF (len := Recv(sock, buffer, 1024 - 1, 0)) >= 0

            /* Assuming it was received, find the end of
             * the line and cut it off
             */
            IF (s1 := strchr(buffer, "\b")) OR (s1 := strchr(buffer, "\n"))
              s1[] := "\0"
            ELSE
              buffer[len] := "\0"
            ENDIF

            Printf('Proxy returned: \s\n', buffer)

            /* Check if HTTP response makes sense */

            IF (strcmp(buffer, 'HTTP/') = 0) AND (s1 := strchr(buffer, " ")) AND (s2 := strchr(s1[1], " ")) AND (s2 - s1 = 3)
              /* Only accept HTTP 200 OK response */
              IF (s1 = 200)
                is_ok := TRUE
              ELSE
                WriteF('Proxy response indicates error!\n')
              ENDIF
            ELSE
              WriteF('Amibigous proxy response!\n')
            ENDIF

          ELSE
            WriteF('Couldnt get proxy response!\n')
          ENDIF

        ELSE
          WriteF('Couldnt send request to proxy!\n')
        ENDIF

      ELSE
        is_ok := TRUE
      ENDIF

    ELSE
      WriteF('Couldnt connect to server\n')
    ENDIF

    IF is_ok = 0
      CloseSocket(sock)
      sock := -1
    ENDIF
  ENDIF

ENDPROC sock

/*
** C support funcs
*/
PROC strcmp(str1:PTR TO CHAR, str2:PTR TO CHAR) IS StrCmp(str1, str2)

PROC strchr(str:PTR TO CHAR, in)
  WHILE str[]
    IF str[] = in
      RETURN str
    ENDIF
    str[]++
  ENDWHILE
ENDPROC NIL

PROC memset(mem:PTR TO CHAR, value, size)
  DEF dummy

  dummy:=mem
  WHILE size-->=0 DO mem[]++:=value
ENDPROC dummy
