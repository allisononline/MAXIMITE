#DEFINE "ipProtoICMP","1"
#DEFINE "ipProtoTCP","6"
#DEFINE "ipProtoUDP","17"
#DEFINE "ipIPHLen","20"
#DEFINE "ipUDPHLen","8"
#DEFINE "ipTCPHLen","20"
#DEFINE "ipIPUDPHLen","(ipUDPHLen+ipIPHLen)"
#DEFINE "ipIPTCPHLen","(ipTCPHLen+ipIPHLen)"
#DEFINE "ipTCPIPHLen","ipIPTCPHLen"
#DEFINE "ipTTL","64"
#DEFINE "ipUDPConnsNum","10"
#DEFINE "ipConnsNum","10"
#DEFINE "ipListenPortsNum","20"
#DEFINE "ipRTO","3"
#DEFINE "ipMaxRtx","8"
#DEFINE "ipMaxSynRtx","5"
#DEFINE "ipTCPMSS","(ipBufSize-ipLLHLen-ipTCPIPHLen)"
#DEFINE "ipRecieveWindow","ipTCPMSS"
#DEFINE "ipTimeWaitTimeout","120"
#DEFINE "ipAckData","1"
#DEFINE "ipNewData","2"
#DEFINE "ipReXmit","4"
#DEFINE "ipPoll","8"
#DEFINE "ipClose","16"
#DEFINE "ipAbort","32"
#DEFINE "ipConnected","64"
#DEFINE "ipTimedOut","128"
#DEFINE "ipBufSize","1024"
#DEFINE "ipLLHLen","14"
#DEFINE "ipData","1"
#DEFINE "ipTimer","2"
#DEFINE "ipPollRequest","3"
#DEFINE "ipUDPSendConn","4"
#DEFINE "ipUDPTimer","5"
#DEFINE "ipClosed","0"
#DEFINE "ipSynRcvd","1"
#DEFINE "ipSynSent","2"
#DEFINE "ipEstablished","3"
#DEFINE "ipFInWait1","4"
#DEFINE "ipFInWait2","5"
#DEFINE "ipClosing","6"
#DEFINE "ipTimeWait","7"
#DEFINE "ipLastAck","8"
#DEFINE "ipTSMask","15"
#DEFINE "ipStopped","16"
#DEFINE "tcpFin","&H01"
#DEFINE "tcpSyn","&H02"
#DEFINE "tcpRst","&H04"
#DEFINE "tcpPsh","&H08"
#DEFINE "tcpAck","&H10"
#DEFINE "tcpUrg","&H20"
#DEFINE "tcpCtl","&H3F"
#DEFINE "tcpOptEnd","0"
#DEFINE "tcpOptNoop","1"
#DEFINE "tcpOptMss","2"
#DEFINE "tcpOptMssLen","4"
#DEFINE "icmpEchoReply","0"
#DEFINE "icmpEcho","8"
#DEFINE "connRIPAddr","0"
#DEFINE "connLPort","1"
#DEFINE "connRPort","2"
#DEFINE "connRcvNxt","3"
#DEFINE "connSndNxt","4"
#DEFINE "connLen","5"
#DEFINE "connMSS","6"
#DEFINE "connInitMSS","7"
#DEFINE "connSA","8"
#DEFINE "connSV","9"
#DEFINE "connRTO","10"
#DEFINE "connTCPFlags","11"
#DEFINE "connTimer","12"
#DEFINE "connNRtx","13"
#DEFINE "connUDPTTL","4"
#DEFINE "ipConnLen","14"
#DEFINE "ipUDPConnLen","4"
#DEFINE "hdrVhl","0"
#DEFINE "hdrTos","1"
#DEFINE "hdrLen","2"
#DEFINE "hdrIPid","4"
#DEFINE "hdrIPOffset","6"
#DEFINE "hdrTTL","8"
#DEFINE "hdrProto","9"
#DEFINE "hdrIPChksum","10"
#DEFINE "hdrSrcIPAddr","12"
#DEFINE "hdrDestIPAddr","16"
#DEFINE "hdrSrcPort","20"
#DEFINE "hdrDestPort","22"
#DEFINE "hdrSeqNo","24"
#DEFINE "hdrAckNo","28"
#DEFINE "hdrTCPOffset","32"
#DEFINE "hdrFlags","33"
#DEFINE "hdrWnd","34"
#DEFINE "hdrTCPChksum","36"
#DEFINE "hdrUrgP","38"
#DEFINE "hdrOptData","40"
#DEFINE "hdrICMPtype","20"
#DEFINE "hdrICMPicode","21"
#DEFINE "hdrICMPChksum","22"
#DEFINE "hdrICMPid","24"
#DEFINE "hdrICMPseqno","26"
#DEFINE "hdrUDPlen","24"
#DEFINE "hdrUDPchksum","26"
#DEFINE "statsIPdrop","0"
#DEFINE "statsIPrecv","1"
#DEFINE "statsIPsent","2"
#DEFINE "statsIPvhlerr","3"
#DEFINE "statsIPhblenerr","4"
#DEFINE "statsIPlblenerr","5"
#DEFINE "statsIPfragerr","6"
#DEFINE "statsIPchkerr","7"
#DEFINE "statsIPprotoerr","8"
#DEFINE "statsICMPdrop","9"
#DEFINE "statsICMPrecv","10"
#DEFINE "statsICMPsent","11"
#DEFINE "statsICMPtypeerr","12"
#DEFINE "statsTCPdrop","13"
#DEFINE "statsTCPrecv","14"
#DEFINE "statsTCPsent","15"
#DEFINE "statsTCPchkerr","16"
#DEFINE "statsTCPackerr","17"
#DEFINE "statsTCPrst","18"
#DEFINE "statsTCPrexmit","19"
#DEFINE "statsTCPsyndrop","20"
#DEFINE "statsTCPsynrst","21"
#DEFINE "statsUDPdrop","22"
#DEFINE "statsUDPrecv","23"
#DEFINE "statsUDPsent","24"
#DEFINE "statsUDPchkerr","25"
#DEFINE "NULL","255"
#DEFINE "hdrAddr","ipBuffAddr%+ipLLHLen"

Dim ipBuffer%(ipBufSize/8)
Dim ipBuffAddr% = Peek(VarAddr ipBuffer%())
Dim ipConns%(ipConnsNum,ipConnLen)
Dim ipListenPorts%(ipListenPortsNum)
Dim ipUDPConns%(ipUDPConnsNum,ipUDPConnLen)
Dim ipStats(26)
Dim iss
Dim ipAcc32(4)
Dim ipConnCurrent,ipUDPCurrent,ipLen,ipSLen,ipFlags,ipID,lastport
Const ipHostAddr% = ipAddress%(192,168,5,2)
Const ipRouterAddr% = ipAddress%(192,168,5,1)
Const ipNetMask% = ipAddress%(255,255,255,0)
Const ipAllOnes% = ipAddress%(255,255,255,255)
Const ipAllZeroes% = ipAddress%(0,0,0,0)

Function chksum(sum,dataAddr%,len)
    chksum = sum
    Local t = 0
    Local dataPtr = dataAddr%
    Local lastbyte = dataAddr%+len-1
    Do While dataPtr < lastbyte
        t = htons(Peek(Short dataPtr))
        inc chksum,t
        If chksum < t Then
            inc chksum
        EndIf
        inc dataPtr, 2
    Loop
    If dataPtr = lastbyte Then
        t = Peek(Byte dataPtr) << 8
        inc chksum,t
        If chksum < t Then
            inc chksum
        EndIf
    EndIf
End Function

Function ipChksum(dataAddr%,len)
    ipChksum = htons(chksum(0,dataAddr%,len))
End Function

Function ipIPChksum()
    Local sum2 = chksum(0,hdrAddr,ipIPHLen)
    MMDebug "ipIPCHksum: sum &H"+Hex$(sum2)
    If sum2 = 0 Then
        ipChksum = &HFFFF
    Else
        ipChksum = htons(sum2)
    EndIf
End Function

Function UpperLayerChksum(proto)
    Local UpperLayerLen = htons(Peek(Short hdrAddr+hdrLen))-ipIPHLen
    Local sum3 = UpperLayerLen + proto
    sum3 = chksum(sum3,hdrAddr+hdrSrcIPAddr,2*4)
    sum3 = chksum(sum3,hdrAddr+ipIPHLen,UpperLayerLen)
    If sum3 = 0 Then
        UpperLayerChksum = &HFFFF
    Else
        UpperLayerChksum = htons(sum3)
    EndIf
End Function

Function ipTCPChksum()
    ipTCPChksum = UpperLayerChksum(ipProtoTCP)
End Function

Function ipUDPChksum()
    ipUDPChksum = UpperLayerChksum(ipProtoUDP)
End Function

Sub ipInit
    For c = 0 To ipListenPorts-1
        ipListenPorts%(c) = 0
    Next
    For c = 0 To ipConnsNum-1
        ipConns%(c,connTCPFlags) = 0
    Next
    lastport = 1024
    For c = 0 To ipUDPConnsNum-1
        ipUDPConns%(c,connLPort) = 0
    Next
End Sub

Function ipConnect(ripAddr%,rPort,)
    Local conn,cconn
    again:
    inc lastport
    If lastport => 32000 Then
        lastport = 4096
    EndIf
    For c = 0 To ipConnsNum-1
        conn = c
        If ipConns%(conn,connTCPFlags) <> ipClosed Then
            If ipCnns%(conn,connLPort) = htons(lastport) Then
                goto again
                Exit For
            EndIf
        EndIf
    Next
    conn = 255
    For c = 0 To ipConnsNum-1
        conn = c
        If ipConns%(conn,connTCPFlags) <> ipClosed Then
            conn = cconn
            Exit For
        EndIf
        If ipConns%(conn,connTCPFlags) = ipTimeWait Then
            If conn = 0 Or ipConns%(cconn,connTimer) > ipConns%(conn,connTimer) Then
                conn = cconn
            EndIf
        EndIf
    Next
    If conn <> 255 Then
        ipConns%(conn,connTCPFlags) = 2
        ipConns%(conn,connSndNxt) = iss
        ipConns%(conn,connMSS) = ipTCPMSS
        ipConns%(conn,connInitMSS) = ipConns%(conn,connMSS)
        ipConns%(conn,connLen) = 1
        ipConns%(conn,connNRtx) = 0
        ipConns%(conn,connTimer) = 1
        ipConns%(conn,connRTO) = 3
        ipConns%(conn,connSA) = 0
        ipConns%(conn,connSV) = 16
        ipConns%(conn,connLPort) = htons(lastport)
        ipConns%(conn,connRPort) = rport
        ipConns%(conn,connRIPAddr) = ripAddr%
        ipConnect = conn
    EndIf
End Function

Function ipUDPNew(RIPAddr%,rport)
    Local conn
    again:
    inc lastport
    If lastport => 32000 Then
        lastport = 4096
    EndIf
    again = 0
    For c = 0 To ipUDPConnsNum-1
        If ipUDPConns%(c,connLPort) = htons(lastport) Then
            goto again
            Exit For
        EndIf
    Next
    conn = 255
    For c = 0 To ipUDPConnsNum - 1
        If ipUDPConns%(c,connLPort) = 0 Then
            conn = c
            Exit For
        EndIf
    Next
    If conn <> 255 Then
        ipConns%(conn,connLPort) = htons(lastport)
        ipConns%(conn,connRPort) = rPort
        ipConns%(conn,connRIPAddr) = ripAddr%
        ipConns%(conn,connUDPTTL) = ipTTL
        ipUDPNew = conn
    EndIf
End Function

Sub ipUnlisten(port)
    For c = 0 To ipListenPortsNum - 1
        If ipListenPorts%(c) = port Then
            ipListenPorts%(c) = 0
            Exit Sub
        EndIf
    Next
End Sub

Sub ipListen(port)
    For c = 0 To ipListenPortsNum - 1
        If ipListenPorts%(c) = 0 Then
            ipListenPorts%(c) = port
            Exit Sub
        EndIf
    Next
End Sub

Sub ipAddRcvNxt(num)
    Local rcvNxt(4)
    For i = 0 To 3
        rcvNxt(i) = ipConns%(ipConnCurrent,connRcvNxt+i)
    Next
    ipAdd32(rcvNxt(),num)
    For i = 0 To 3
        ipConns%(ipConnCurrent,connRcvNxt+i) = ipAcc32(i)
    Next
End Sub

Sub ipProcess(flag)
    Local ipConnR = ipConnCurrent
    If flag = ipUDPSendConn Then
        goto udp_send
    EndIf
    ipAppData = ipIPTCPHLen + ipLLHLen
    ipSAppData = ipAppData
    If flag = ipPollRequest Then
        If (ipConns%(ipConnR,connTCPFlags) And ipTSMask) = ipEstablished Then
            If ipConns%(ipConnR,connLen) = 0 Then
                ipFlags = ipPoll
                ipAppCall
                goto appsend
            EndIf
        EndIf
        goto drop
    ElseIf flag = ipTimer Then
    EndIf
    Inc iss
    If iss > &HFFFFFFFF Then
        iss = 0
    EndIf
    ipLen = 0
    ipSLen = 0
    If (ipConns%(ipConnR,connTCPFlags)=ipTimeWait) Or (ipCOnns%(ipConnR,connTCPFlags) = ipFINWait2) Then
        inc ipConns%(ipConnR,connTimer)
        If ipConns%(ipConnR,connTimer) = ipTimeWaitTimeout Then
            ipConns%(ipConnR,connTCPFlags) = ipClosed
        EndIf
    ElseIf ipConns%(ipConnR,connTCPFlags) = ipClosed Then
        If ipConns%(ipConnR,connLen) > 0 Then
            Inc ipConns%(ipConnR,connTimer),-1
            If ipConns%(ipConnR,connTimer) < 0 Then
                ipConns%(ipConnR,connTimer) = 255
                If (ipConns%(ipConnR,connNRtx)=ipMaxRtx) Or (ipConns%(ipConnR,connTCPFlags)=ipSynSent) Or (ipCOnns%(ipConnR,connTCPFlags) = ipSynRcvd) Then
                    If ipConns%(ipConnR,connNRtx) = ipMaxSynRtx Then
                        ipConns%(ipConnR,connTCPFlags) = ipClosed
                        ipFlags = ipTimedOut
                        ipAppCall
                        Poke Byte hdrAddr+hdrFlags,tcpRst Or tcpAck
                        goto tcp_send_nodata
                    EndIf
                    If ipConns%(ipConnR,connNRtx) > 4 Then
                        ipCOnns%(ipConnR,connTimer) = ipRTO << 4
                    Else
                        ipConns%(ipConnR,connTimer) = ipROT << ipConns%(ipCOnnR,connNrtx)
                    EndIf
                    Inc ipConns%(ipConnR,connNrtx)
                    Inc ipStats(statsTCPRexmit)
                    Select Case (ipConns%(ipConnR,connTCPFlags) And ipTSMask)
                        Case ipSynRcvd
                            goto tcp_send_synack
                        Case ipSynSent
                            Poke Byte hdrAddr+hdrFlags,0
                            goto tcp_send_syn
                        Case ipEstablished
                            ipFlags = ipReXmit
                            ipAppCall
                            goto apprexmit
                        Case ipFInWait1
                        Case ipClosing
                        Case ipLastAck
                            goto tcp_send_finack
                    End Select
                EndIf
            ElseIf (ipConns%(ipConnR,connTCPFlags) And ipTSMask) = ipEstablished Then
                ipFlags = ipPoll
                ipAppCall
                goto appsend
            EndIf
        EndIf
        goto drop
    EndIf
    If flag = ipUDPTimer Then
        If ipUDPConns%(ipUDPCurrent,connLPort) <> 0 Then
            ipConnCurrent = 0
            ipAppData = ipLLHLen+ipIPUDPHLen
            ipSappData = ipAppData
            ipSlen = 0
            ipLen = 0
            ipFlags = ipPoll
            ipUDPAppCall
            goto udp_send
        Else
            goto drop
        EndIf
    EndIf
    Inc ipStats(statsIPRecv)
    If Peek(Byte hdrAddr+hdrVhl) <> &H45 Then
        Inc ipStats(statsIPdrop)
        Inc ipStats(statsIPvhlerr)
        ipLog("ip: invalid version or header length")
        goto drop
    EndIf
    If htons(Peek(Short hdrAddr+hdrLen)) =< ipLen Then
        ipLen = htons(Peek(Short hdrAddr+hdrLen))
    Else
        ipLog("ip: packet shorter than reported in IP header.")
        goto drop
    EndIf
    If htons((Peek(Short hdrAddr+hdrIPoffset)) And &H3FFF) <> 0 Then
    EndIf
    Inc ipStats(statsIPdrop)
    Inc ipStats(statsIPFragerr)
    ipLog("ip: fragment dropped.")
    goto drop
    If ipHostAddr% = ipAllZeroes Then
    Else
        If Peek(Word hdrAddr+hdrDestIPAddr) <> ipHostAddr Then
            Inc ipStats(statsIPdrop)
            goto drop
        EndIf
    EndIf
    If ipIPChksum() <> &HFFFF Then
        Inc ipStats(statsIPdrop)
        Inc ipStats(statsIPchkerr)
        ipLog("ip: bad checksum.")
        goto drop
    EndIf
    If Peek(Byte hdrAddr+hdrProto) = ipProtoTCP Then
        goto tcp_input
    EndIf
    If Peek(Byte hdrAddr+hdrProto) = ipProtoUDP Then
        goto udp_input
    EndIf
    If Peek(Byte hdrAddr+hdrProto) <> ipProtoICMP Then
        Inc ipStats(statsIPdrop)
        Inc ipStats(statsIPprotoerr)
        ipLog("ip: neither tcp nor icmp.")
        goto drop
    EndIf
    Poke Byte hdrAddr+hdrICMPtype, icmpEchoReply
    If htons(Peek(Short hdrAddr+hdrICMPchksum)) => (&HFFFF-(ICMPEcho)) Then
        Poke Short hdrAddr+hdrICMPchksum, Peek(Short hdrAddr+hdrICMPchksum) + htons(ICMPEcho << 8) + 1
    Else
        Poke Short hdrAddr+hdrICMPchksum, Peek(Short hdrAddr+hdrICMPchksum) + htons(ICMPEcho << 8)
    EndIf
    Poke Word hdrAddr+hdrDestIPAddr,Peek(Word hdrAddr+hdrSrcIPAddr)
    Poke Word hdrAddr+hdrSrcIPAddr,netAddr%(ipHostAddr%)
    Inc IPStats(statsICMPsent)
    goto send

    udp_input:
    Inc ipLen,-ipIPUDPHLen
    ipAppData = ipLLHLen+ipIPUDPHLen
    If (Peek(Short hdrAddr+hdrUDPChksum) <> 0) And (ipUDPChksum() <> &HFFFF) Then
        Inc ipStats(statsUDPdrop)
        Inc ipStats(statsUDPchkerr)
        ipLog("udp: bad checksum.")
        goto drop
    EndIf
    For k = 0 To ipUDPConnsNum-1
        ipUDPCUrrent = k
        If ipUDPConns%(ipUDPCurrent,connLPort) <> 0 Then 
            If Peek(Short hdrAddr+hdrDestPort) = htons(ipUDPConns%(ipUDPCurrent,connLPort)) Then
                If ipUDPConns%(ipUDPCUrrent,connRPort) = 0 Or Peek(Short hdrAddr+hdrSrcPort) = htons(ipUDPConns%(ipUDPCurrent,connRPort)) Then
                    If ipUDPConns%(ipUDPCurrent,connRIPAddr) = ipAllZeroes Or ipUDPConns%(ipUDPCurrent,connRIPAddr) = ipAllOnes Or Peek(Word hdrAddr+hdrSrcIPAddr) = ipUDPConns%(ipUDPCurrent,connRIPAddr) Then
                        goto udp_found
                    EndIf
                EndIf
            EndIf
        EndIf
    Next
    ipLog("udp: no matching connection found.")
    goto drop

    udp_found:
    ipConnCurrent = 0
    ipFlags = ipNewData
    ipAppData = ipLLHLen+ipIPUDPHLen
    ipSAppData = ipAppData
    ipSlen = 0
    ipUDPAppCall

    udp_send:
    If ipSlen = 0 Then
        goto drop
    EndIf
    ipLen = ipSLen + ipIPUDPHLen
    Poke Short hdrAddr+hdrLen,htons(ipLen)
    Poke Byte hdrAddr+hdrTTL = ipUDPConns%(ipUDPCurrent,connUDPTTL)
    Poke Byte hdrAddr+hdrProto = ipProtoUDP
    Poke Short hdrAddr+hdrUDPlen, htons(ipSlen+ipUDPHLen)
    Poke Short hdrAddr+hdrUDPChksum,0
    Poke Short hdrAddr+hdrSrcPort, htons(ipUDPConns%(ipUDPCurrent,connLPort))
    Poke Short hdrAddr+hdrDestPort, htons(ipUDPConns%(ipUDPCurrent,connRPort))
    Poke Word hdrAddr+hdrSrcIPAddr, netAddr%(ipHostAddr%)
    Poke Word hdrAddr+hdrDestIPAddr, netAddr(ipUDPConns%(ipUDPCurrent,connRIPAddr))
    ipAppData = ipLLHLen+ipIPTCPHLen
    Poke Short hdrAddr+hdrUDPCHksum,&HFFFF-ipUDPCHksum()
    If Peek(Short hdrAddr+hdrUDPCHksum) = 0 Then
        Poke Short hdrAddr+hdrUDPCHksum,&HFFFF
    EndIf
    goto ip_send_nolen

    tcp_input:
    Inc ipStats(statsTCPrecv)
    If ipTCPChksum() <> &HFFFF Then
        Inc ipStats(statsTCPDrop)
        Inc ipStats(statsTCPchkerr)
        ipLog("tcp: bad checksum.")
        goto drop
    EndIf
    For k = 0 To ipConnsNum-1
        ipConnR = k
        If ipConns%(ipConnR,conTCPFlag) <> ipClosed Then
            If Peek(Short hdrAddr+hdrDestPort) = ipConns%(ipConnR,connLPort) Then
                If Peek(Short hdrAddr+hdrSrcPort) = ipConns%(ipConnR.connRPort) Then
                    If Peek(Word hdrAddr+hdrSrcIPAddr) = ipConns%(ipConnR,connRIPAddr) Then
                        goto found
                    EndIf
                EndIf
            EndIf
        EndIf
    Next
    If (Peek(Byte hdrAddr+hdrFlags) And tcpCtl) <> tcpSyn Then
        goto reset
    EndIf
    tmp16 = Peek(Short hdrAddr+hdrDestPort)
    For c = 0 To ipListenPortsNum
        If tmp16 = ipListenPorts(c) Then
            goto found_listen
        EndIf
    Next
    Inc ipStats(statsTCPSynrst)

    reset:
    If Peek(Byte hdrAddr+hdrFlags) And tcpRst = tcpRst Then
        goto drop:
    EndIf
    Inc ipStats(statsTCPrst)
    Poke Byte hdrAddr+flags, tcpRST Or tcpAck
    ipLen = ipIPTCPHLen
    Poke Byte hdrAddr+hdrTCPOffset, 5 << 4
    c = Peek(Byte hdrAddr+hdrSeqNo+3)
    Poke Word hdrAddr+hdrSeqNo,Peek(Word hdrAddr+hdrAckno)
    Poke Word hdrAddr+hdrAckNo,incWord(c,1)
    tmp16 = Peek(Short hdrAddr+hdrSrcPort)
    Poke Short hdrAddr+hdrSrcPort,Peek(Short hdrAddr+hdrDestPort)
    Poke Short hdrAddr+hdrDestPort,tmp16
    Poke Word hdrAddr+hdrDestIPAddr,Peek(Word hdrAddr+hdrSrcIPAddr)
    Poke Word hdrAddr+hdrSrcIPAddr,netAddr%(ipHostAddr%)
    goto tcp_send_noconn

    found_listen:
    ipConnR = 255
    For c = 0 To ipConnsNum-1
        If ipConns%(c,connTCPFlags) = ipClosed Then
            ipConnR = c
            Exit For
        EndIf
        If ipConns%(c,connTCPFlags) = ipTImeWait Then
            If ipConnR = 255 Or ipConns%(c,connTimer) > ipConns%(c,connTimer) Then
                ipConnR = char
            EndIf
        EndIf
    Next
    If ipConnR = 255 Then
        Inc ipStats(statsTCPSyndrop)
        ipLog("tcp: found no unused connections.")
        goto drop
    EndIf
    ipConnCurrent = ipConnR
    ipConns%(ipConnR,connTimer) = ipRTO
    ipConns%(ipConnR,connSA) = 0
    ipConns%(ipConnR,connSV) = 4
    ipConns%(ipConnR,connNRtx) = 0
    ipConns%(ipConnR,connLPort) = Peek(Short hdrAddr+hdrDestPort)
    ipConns%(ipConnR,connRPort) = Peek(Short hdrAddr+hdrSrcPort)
    ipConns%(ipConnR,connRIPAddr) = Peek(Word hdrAddr+srcIPAddr)
    ipConns%(ipConnR,connTCPFlags) = ipSynRcvd
    ipConns%(ipConnR,connSndNxt) = iss
    ipConns%(ipConnR,connLen) = 1
    ipConns%(ipConnR,connRcvNxt) = Peek(Word hdrAddr+hdrSeqNo)
    Inc ipConns%(ipConnCurrent,connRcvNxt)
    If (Peek(Byte hdrAddr+hdrTCPOffset) And &HF0) > &H50 Then
        tmp8 = ((Peek(Byte hdrAddr+hdrTCPOffset) >> 4) - 5) << 2
        For c = 0 To tmp8-1
            opt = Peek(Byte hdrAddr+ipTCPIPHlen+c)
            If opt = tcpOptEnd Then
                Exit For
            ElseIf opt = tcpOptNoop Then
                Inc c
            ElseIf (opt = tcpOptMss) And (Peek(Byte hdrAddr%+ipTCPIPHLen+1+c) = tcpOptMssLen) Then
                tmp16 = (peek(Short hdrAddr+ipTCPIPHlen+2+c)
                If tmp16 > ipTCPMSS Then
                    ipConns%(ipConnR,connMSS) = ipTCPMSS
                Else
                    ipConns%(ipConnR,connMSS) = tmp16
                EndIf
                ipConns%(ipConnR,connInitMSS) = ipConns%(ipConnR,connMSS)
                Exit For
            Else
                If Peek(Byte hdrAddr+ipTCPIPHLen+1+c) = 0 Then
                    Exit For
                EndIf
                Inc c,Peek(Byte hdrAddr+ipTCPIPHLen+1+c)
            EndIf
        Next
    EndIf

    tcp_send_synack:
    Poke Byte hdrAddr+hdrFlags,tcpAck

    tcp_send_syn:
    Poke Byte hdrAddr+hdrFlags, Peek(Byte hdrAddr+hdrFlags) Or tcpSyn
    tmp32 = (tcpOptMss << 24) + (tcpOptMssLen << 16) + (ipTCPMSS)
    Poke Word hdrAddr+hdrOptData,netAddr%(tmp32)
    Poke Byte hdrAddr+hdrTCPOffset, ((ipTCPHLen+tcpOptMssLen) And &HFC) << 2
    goto tcp_send

    found:
    ipConnCurrent = ipConnR
    ipFlags = 0
    If (Peek(Byte hdrAddr+hdrFlags) And tcpRst) = tcpRst Then
        ipConns%(ipConnR,connTCPFlags) = ipClosed
        ipLog("tcp: got reset, aborting connection.")
        ipFlags = ipAbort
        ipAppCall
        goto drop
    EndIf
    c = (Peek(Byte hdrAddr+hdrTCPOffset) And &HF0) >> 2
    ipLen = ipLen - c - ipIPHLen
    If (ipConns%(ipConnR,connTCPFlags) And ipTSMask) = ipSynSent And Peek(Byte hdrAddr+hdrFlags) = (tcpSyn Or tcpAck) Then
        If (ipLen > 0) Or ((Peek(Byte hdrAddr+hdrFlags) And (tcpSyn Or tcpFin)) <> 0)
            If Peek(Byte hdrAddr+hdrSeqNo) <> ipConns%(ipConnR,connRcvNxt) Then
                goto tcp_send_ack
            EndIf
        EndIf
    EndIf
    If ((Peek(Byte hdrAddr+hdrFlags) And tcpAck) = tcpAck) And (ipConns%(ipConnR,connLen) > 0) Then
        tmp32 = ipConns%(ipConnR,connSndNxt)+ipConns%(ipConnR,connLen) 
        If Peek(Word hdrAddr+hdrAckNo) = tmp32 Then
            ipConns%(ipConnR,connSndNxt) = tmp32
            If ipConns%(ipConnR,connNrtx) = 0 Then
                m = ipConns%(ipConnR,connRTO) - ipConns%(ipConnR,connTimer)
                Inc m,-(ipConns%(ipConnR,connSA) >> 3)
                Inc ipConns%(ipConnR,connSA),m
                if m < 0 Then
                    m = -m
                EndIf
                Inc m, -(ipConns%(ipConnR,connSV) >> 2)
                Inc ipConns%(ipConnR,connSV), m
                ipConns%(ipConnR,connRTO) = (ipConns%(ipConnR,connSA) >> 3) + ipConns%(ipConnR,connSV)
            EndIf
            ipFlags = ipAckData
            ipConns%(ipConnR,connTimer) = ipConns%(ipConnR,connRTO)
            ipConns%(ipConnR,connLen) = 0
        EndIf
    EndIf
    Select Case (ipConns%(ipConnR,connTCPFlags) And ipTSMask)
        Case ipSynRcvd
            If (ipFlags And ipAckData) = ipAckData Then
                ipConns%(ipConnR,connTCPFlags) = ipEstablished
                ipFlags = ipConnected
                ipConns%(ipConnR,connLen) = 0
                If ipLen > 0 Then
                    ipFlags = ipFlags Or ipNewData
                    Inc ipConns%(ipConnCurrent,connRcvNxt),ipLen
                    ipConns%(ipConnCurrent,connRcvNxt) = ipConns%(ipConnCurrent,connRcvNxt) And &HFFFFFFFF
                EndIf
                ipSlen = 0
                ipAppCall
                goto appsend
            EndIf
            goto drop
        Case ipSynSent
            If ((ipFlags And ipAckData) = ipAckData) And (Peek(Byte hdrAddr+hdrFlags) = (tcpSyn Or tcpAck)) Then
                If (Peek(Byte hdrAddr+hdrTCPOffset) And &HF0) > &H50 Then
                    tmp8 = ((Peek(Byte hdrAddr+hdrTCPOffset) >> 4) -5) << 2
                    For c = 0 To tmp8-1
                        opt = Peek(Byte hdrAddr+ipIPTCPHLen+c)
                        If opt = tcpOptEnd Then
                            Exit For
                        ElseIf opt = tcpOptNoop Then
                            inc c
                        ElseIf (opt = tcpOptMss) And (Peek(Byte hdrAddr+ipIPTCPHLen+1+c) = tcpOptMssLen) Then
                            tmp16 = Peek(Short hdrAddr+ipTCPIPHLen+2+c)
                            If tmp16 > ipTCPMSS Then
                                ipConns%(ipConnR,connMSS) = ipTCPMSS
                            Else
                                ipConns%(ipConnr,connMSS) = tmp16
                            EndIf
                            Exit For
                        Else
                            If Peek(Byte hdrAddr+ipTCPIPHLen+1+c) = 0 Then
                                Exit For
                            EndIf
                            Inc c,Peek(Byte hdrAddr+ipTCPIPHLen+1+c)
                        EndIf
                    Next
                EndIf
                ipConns%(ipConnR,connTCPFlags) = ipEstablished
                ipConns%(ipConnR,connRcvNxt) = Peek(Word hdrAddr+hdrSeqNo)
                ipConns%(ipConnCurrent,connRcvNxt) = (ipConns%(ipConnCurrent,connRcvNxt) + 1) And &HFFFFFFFF
                ipFlags = ipConnected Or ipNewData
                ipConns%(ipConnR,connLen) = 0
                ipLen = 0
                ipSlen = 0
                ipAppCall
                goto appsend
            EndIf
            ipFlags = ipAbort
            ipAppCall
            ipConns%(ipConnCurrent,connTCPFlags) = ipClosed
            goto reset
        Case ipEstablished
            If (peek(Byte hdrAddr+hdrFlags) And tcpFin) And (ipConns%(ipConnR,connTCPFlags) And ipStopped) Then
                If ipConns%(ipConnR,connLen) > 0 Then
                    goto drop
                EndIf
                ipConns%(ipConnCurrent,connRcvNxt) = (ipConns%(ipConnCurrent,connRcvNxt) + ipLen + 1) And &HFFFFFFFF
                ipFlags = ipFlags Or ipClose
                If ipLen > 0 Then
                    ipFlags = ipFlags Or ipNewData
                EndIf
                ipAppCall
                ipConns%(ipConnR,connLen) = 1
                ipConns%(ipConnR,connTCPFlags) = ipLastAck
                ipConns%(ipConnR,connNRtx) = 0

                tcp_send_finack:
                Poke Byte hdrAddr+hdrFlags, tcpFin Or tcpAck
                goto tcp_send_nodata
            EndIf
            If (Peek(Byte hdrAddr+hdrFlags) And tcpUrg) <> 0 Then
                ipAppData = Peek(Byte ipBuffAddr%+ipAppData) + Peek(Short hdrAddr+hdrUrgP)
                Inc ipLen,-Peek(Short hdrAddr+hdrUrgP)
            EndIf
            If (ipLen > 0) And (ipConns%(ipConnR,connTCPFlags) And ipStopped) Then
                ipFlags = ipFlags Or ipNewData
                ipConns%(ipConnCurrent,connRcvNxt) = (ipConns%(ipConnCurrent,connRcvNxt)+ipLen) And &HFFFFFFFF
            EndIf
            tmp16 = htons(Peek(Short hdrAddr+hdrWnd))
            If (tmp16 > ipConns%(ipConnR,connInitMSS)) Or (tmp16 = 0) Then
                tmp16 = ipConns%(ipConnR,connInitMSS))
            EndIf
            ipConns%(ipConnR,connMSS) = tmp16
            If ipFlags And (ipNewData Or ipAckData) Then
                ipSLen = 0
                ipAppCall

                appsend:
                If ipFlags And ipAbort Then
                    ipSLen = 0
                    ipConns%(ipConnR,connTCPFlags) = ipClosed
                    Poke Byte hdrAddr+hdrFlags, tcpRst Or tcpAck
                    goto tcp_send_nodata
                EndIf
                If ipFlags And ipClose Then
                    ipSLen = 0
                    ipConns%(ipConnR,connLen) = 1
                    ipConns%(ipConnR,connTCPFlags) = ipFInWait1
                    ipConns%(ipConnR,connNRtx) = 0
                    Poke Byte hdrAddr+hdrFlags, tcpFin Or tcpAck
                    goto tcp_send_nodata
                EndIf
                If ipSLen > 0 Then
                    If (ipFlags And ipAckData) <> 0 Then
                        ipConns%(ipConnR,connLen) = 0
                    EndIf
                    If ipConns%(ipConnR,connLen) = 0 Then
                        If ipSlen > ipConns%(ipConnR,connMSS) Then
                            ipSlen = ipConns%(ipConnR,connMSS)
                        EndIf
                        ipConns%(ipConnR,connLen) = ipSLen
                    Else
                        ipSLen = ipConns%(ipConnR,connLen)
                    EndIf
                EndIf
                ipConns%(ipConnR,connNRTx) = 0

                apprexmit:
                ipAppdata = ipSAppData
                If (ipSLen > 0) And (ipConns%(ipConnR,connLen) > 0) Then
                    ipLen = ipConns%(ipConnR,connLen) + ipTCPIPHLen
                    Poke Byte hdrAddr+hdrFlags, tcpAck Or tcpPsh
                    goto tcp_send_noopts
                EndIf
                If ipFlags And ipNewData Then
                    ipLen = ipTCPIPHLen
                    Poke Byte hdrAddr+hdrFlags, tcpAck
                    goto tcp_send_noopts
                EndIf
            EndIf
            goto drop
        Case ipLastAck
            If ipFlags And ipAckData Then
                ipConns%(ipConnR,connTCPFlags) = ipClosed
                ipFlags = ipClose
                ipAppCall
            EndIf
            goto exit_tcp_case
        Case ipFInWait1
            If ipLen > 0 Then
                Inc ipConns%(ipConnCurrent,connRcvNxt),ipLen
            EndIf
            If Peek(Byte hdrAddr+hdrFlags) And tcpFin Then
                If ipFlags And ipAckData Then
                    ipConns%(ipConnr,connTCPFlags) = ipTimeWait
                    ipConns%(ipConnr,connTimer) = 0
                    ipConns%(ipConnr,connLen) = 0
                Else
                    ipConns%(ipConnr,connTCPFlags) = ipClosing
                EndIf
                Inc ipConns%(ipConnCurrent,connRcvNxt),1
                ipFlags = ipClose
                ipAppCall
                goto tcp_send_ack
            ElseIf ipFlags And ipAckData Then
                ipConns%(ipConnr,connTCPFlags) = ipFInWait2
                ipConns%(ipConnr,connLen) = 0
                goto drop
            EndIf
            If ipLen > 0 Then
                goto tcp_send_ack
            EndIf
            goto drop
        Case ipFInWait2
            If ipLen > 0 Then
                Inc ipConns%(ipConnCurrent,connRcvNxt),ipLen
            EndIf
            If Peek(Byte hdrAddr+hdrFlags) And tcpFin Then
                ipConns%(ipConnr,connTCPFlags) = ipTimeWait
                ipConns%(ipConnr,connTimer) = 0
                Inc ipConns%(ipConnCurrent,connRcvNxt), 1
                ipFlags = ipClose
                ipAppCall
                goto tcp_send_ack
            EndIf
            If ipLen > 0 Then
                goto tcp_send_ack
            EndIf
            goto drop
        Case ipTimeWait
            goto tcp_send_ack
        Case ipClosing
            If ipFlags And ipAckData Then
                ipConns%(ipConnr,connTCPFlags) = ipTimeWait
                ipConns%(ipConnr,connTimer) = 0
            EndIf
    End Select
    exit_tcp_case:
    goto drop

    tcp_send_ack:
    Poke Byte hdrAddr+hdrFlags, tcpAck

    tcp_send_nodata:
    ipLen = ipIPTCPHLen

    tcp_send_noopts:
    Poke Byte hdrAddr+hdrTcpOffset, (ipTCPHLen/4) << 4

    tcp_send:
    Poke Word hdrAddr+hdrAckNo, netAddr%(ipConns%(ipConnr,connRcvNxt)
    Poke Word hdrAddr+hdrSeqNo, netAddr%(ipConns%(ipConnr,connSndNxt)
    Poke Byte hdrAddr+hdrProto, ipProtoTCP
    Poke Short hdrAddr+hdrSrcPort, htons(ipConns%(ipConnr,connLPort)
    Poke Short hdrAddr+hdrDestPort, htons(ipConns%(ipConnr,connRPort)
    Poke Word hdrAddr+hdrSrcIPAddr, netAddr%(ipHostAddr%)
    Poke Word hdrAddr+hdrDestIPAddr, netAddr%(ipConns%(ipConnr,connRIPAddr))
    If ipConns%(ipConnr,connTCPFlags) And ipStopped Then
        Poke Short hdrAddr+hdrWnd, 0
    Else
        Poke Short hdrAddr+hdrWnd, htons(ipReceiveWindow)
    EndIf

    tcp_send_noconn:
    Poke Byte hdrAddr+hdrTTL, ipTTL
    Poke Short hdrAddr+hdrLen, htons(ipLen)
    Poke Short hdrAddr+hdrUrgP,0
    Poke Short hdrAddr+hdrTCPChksum, 0
    Poke Short hdrAddr+hdrTCPChksum, &HFFFF - ipTCPChksum()

    ip_send_nolen:
    Poke Byte hdrAddr+hdrVhl, &H45
    Poke Byte hdrAddr+hdrTos, 0
    Poke Short hdrAddr+hdrIPOffset,0
    Inc ipID
    Poke Short hdrAddr+hdrIPid, htons(ipID)
    Poke Short hdrAddr+hdrIPChksum, 0
    Poke Short hdrAddr+hdrIPChksum, &HFFFF - ipIPChksum()
    Inc ipStats(statsTCPSent)

    send:
    MMDebug "Sending packet with length "+Format$(ipLen)+" ("+Format$(htons(Peek(Short hdrAddr+hdrLen))+")"
    Inc ipStats(statsIPSent)
    ipFlags = 0
    Exit Sub

    drop:
    ipLen = 0
    ipFlags = 0
End Sub

Sub ipSend(dataAddr%, dataLen)
    If dataLen > 0 Then
        ipSLen = dataLen
        If dataAddr% <> (ipBuffAddr%+ipSappData) Then
            BufferCpy(ipBuffAddr%+ipSAppData, dataAddr%,ipSLen)
        EndIf
    EndIf
End Sub