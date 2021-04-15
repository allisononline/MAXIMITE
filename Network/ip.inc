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
#DEFINE "connTCPFlag","11"
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

Function ipAddress%(byte1,byte2,byte3,byte4)
    ipAddress% = (byte1 << 8) + byte2
    ipAddress% = (ipAddress% << 8) + byte3
    ipAddress% = (ipAddress% << 8) + byte4
End Function

Function htons(int16)
    htons = ((int16 >> 8) Or (int16 << 8)) And &HFFFF
End Function

Function chksum(sum,dataAddr%,len)
    chksum = sum
    Local t = 0
    Local dataPtr = dataAddr%
    Local lastbyte = dataAddr%+len-1
    Do While dataPtr < lastbyte
        t = Peek(Short dataPtr)
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
    Local UpperLayerLen = Peek(Short hdrAddr+2)-ipIPHLen
    Local sum3 = UpperLayerLen + proto
    sum3 = chksum(sum3,hdrAddr+12,4)
    sum3 = chksum(sum3,ipBuffAddr%+ipIPHLen+ipLLHLen,UpperLayerLen)
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

Sub ipAdd32(op32(),op16)
    ipAcc32(3) = op32(3) + (op16 And &HFF)
    ipAcc32(2) = op32(2) + (op16 >> 8)
    ipAcc32(1) = op32(1)
    ipAcc32(0) = op32(0)
    If ipAcc32(2) < (op16 >> 8) Then
        inc ipAcc32(1)
        If ipAcc32(1) = 0 Then
            inc ipAcc32(0)
        EndIf
    EndIf
    If ipAcc32(3) < (op16 And &HFF) Then
        inc ipAcc32(2)
        If ipAcc32(2) = 0 Then
            inc ipAcc32(1)
            If ipAcc32(1) = 0 Then
                inc ipAcc32(0)
            EndIf
        EndIf
    EndIf
End Sub

Sub ipInit
    For c = 0 To ipListenPorts-1
        ipListenPorts%(c) = 0
    Next
    For c = 0 To ipConnsNum-1
        ipConns%(c,connTCPFlag) = 0
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
        If ipConns%(conn,connTCPFlag) <> ipClosed Then
            If ipCnns%(conn,connLPort) = htons(lastport) Then
                goto again
                Exit For
            EndIf
        EndIf
    Next
    conn = 255
    For c = 0 To ipConnsNum-1
        conn = c
        If ipConns%(conn,connTCPFlag) <> ipClosed Then
            conn = cconn
            Exit For
        EndIf
        If ipConns%(conn,connTCPFlag) = ipTimeWait Then
            If conn = 0 Or ipConns%(cconn,connTimer) > ipConns%(conn,connTimer) Then
                conn = cconn
            EndIf
        EndIf
    Next
    If conn <> 255 Then
        ipConns%(conn,connTCPFlag) = 2
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
        If (ipConns%(ipConnR,connTCPFlag) And ipTSMask) = ipEstablished Then
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
    If (ipConns%(ipConnR,connTCPFlag)=ipTimeWait) Or (ipCOnns%(ipConnR,connTCPFlag) = ipFINWait2) Then
        inc ipConns%(ipConnR,connTimer)
        If ipConns%(ipConnR,connTimer) = ipTimeWaitTimeout Then
            ipConns%(ipConnR,connTCPFlag) = ipClosed
        EndIf
    ElseIf ipConns%(ipConnR,connTCPFlag) = ipClosed Then
        If ipConns%(ipConnR,connLen) > 0 Then
            Inc ipConns%(ipConnR,connTimer),-1
            If ipConns%(ipConnR,connTimer) < 0 Then
                ipConns%(ipConnR,connTimer) = 255
                If (ipConns%(ipConnR,connNRtx)=ipMaxRtx) Or (ipConns%(ipConnR,connTCPFlag)=ipSynSent) Or (ipCOnns%(ipConnR,connTCPFlag) = ipSynRcvd) Then
                    If ipConns%(ipConnR,connNRtx) = ipMaxSynRtx Then
                        ipConns%(ipConnR,connTCPFlag) = ipClosed
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
                    Select Case (ipConns%(ipConnR,connTCPFlag) And ipTSMask)
                        Case ipSynRcvd
                            goto tcp_send_synack
                        Case ipSynSent
                            Poke Byte hdrAddr+hdrFLags,0
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
            ElseIf (ipConns%(ipConnR,connTCPFlag) And ipTSMask) = ipEstablished Then
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
    If Peek(Short hdrAddr+hdrLen) =< ipLen Then
        ipLen = Peek(Short hdrAddr+hdrLen)
    Else
        ipLog("ip: packet shorter than reported in IP header.")
        goto drop
    EndIf
    If (Peek(Short hdrAddr+hdrIPoffset) And &H3FFF) <> 0 Then
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
    If Peek(Short hdrAddr+hdrICMPchksum) => htons(&HFFFF-(ICMPEcho << 8)) Then
        Poke Short hdrAddr+hdrICMPchksum, Peek(Short hdrAddr+hdrICMPchksum) + htons(ICMPEcho << 8) + 1
    Else
        Poke Short hdrAddr+hdrICMPchksum, Peek(Short hdrAddr+hdrICMPchksum) + htons(ICMPEcho << 8)
    EndIf
    Poke Word hdrAddr+hdrDestIPAddr,Peek(Word hdrAddr+hdrSrcIPAddr)
    Poke Word hdrAddr+hdrSrcIPAddr,ipHostAddr%
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
            If Peek(Short hdrAddr+hdrDestPort) = ipUDPConns%(ipUDPCurrent,connLPort) Then
                If ipUDPConns%(ipUDPCUrrent,connRPort) = 0 Or Peek(Short hdrAddr+hdrSrcPort) = ipUDPConns%(ipUDPCurrent,connRPort) Then
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
    Poke Short hdrAddr+hdrLen,ipLen
    Poke Byte hdrAddr+hdrTTL = ipUDPConns%(ipUDPCurrent,connUDPTTL)
    Poke Byte hdrAddr+hdrProto = ipProtoUDP
    Poke Short hdrAddr+hdrUDPlen, ipSlen+ipUDPHLen
    Poke Short hdrAddr+hdrUDPChksum,0
    Poke Short hdrAddr+hdrSrcPort, ipUDPConns%(ipUDPCurrent,connLPort)
    Poke Short hdrAddr+hdrDestPort, ipUDPConns%(ipUDPCurrent,connRPort)
    Poke Word hdrAddr+hdrSrcIPAddr, ipHostAddr%
    Poke Word hdrAddr+hdrDestIPAddr, ipUDPConns%(ipUDPCurrent,connRIPAddr)
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
    c = Peek(Word hdrAddr+hdrSeqNo)
    Poke Word hdrAddr+hdrSeqNo,Peek(Word hdrAddr+hdrAckno)
    Poke Word hdrAddr+hdrAckNo,(c+1) And &HFFFFFFFF
    tmp16 = Peek(Short hdrAddr+hdrSrcPort)
    Poke Short hdrAddr+hdrSrcPort,Peek(Short hdrAddr+hdrDestPort)
    Poke Short hdrAddr+hdrDestPort,tmp16
    Poke Word hdrAddr+hdrDestIPAddr,Peek(Word hdrAddr+hdrSrcIPAddr)
    Poke Word hdrAddr+hdrSrcIPAddr,ipHostAddr%
    goto tcp_send_noconn

    found_listen:
    ipConnR = 255
    For c = 0 To ipConnsNum-1
        If ipConns%(c,connTCPFlag) = ipClosed Then
            ipConnR = c
            Exit For
        EndIf
        If ipConns%(c,connTCPFlag) = ipTImeWait Then
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
    ipConns%(ipConnR,connTCPFlag) = ipSynRcvd
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

    tcp_send_syn
    Poke Byte hdrAddr+hdrFlags, Peek(Byte hdrAddr+hdrFlags) Or tcpSyn
    tmp32 = (tcpOptMss << 24) + (tcpOptMssLen << 16) + (ipTCPMSS)
    Poke Word hdrAddr+hdrOptData,tmp32
    Poke Byte hdrAddr+hdrTCPOffset, ((ipTCPHLen+tcpOptMssLen) And &HFC) << 2
    goto tcp_send

    found:
    ipConnCurrent = ipConnR
    ipFlags = 0
    If (Peek(Byte hdrAddr+hdrFlags) And tcpRst) = tcpRst Then
        ipConns%(ipConnR,connTCPFlag) = ipClosed
        ipLog("tcp: got reset, aborting connection.")
        ipFlags = ipAbort
        ipAppCall
        goto drop
    EndIf
    c = (Peek(Byte hdrAddr+hdrTCPOffset) And &HF0) >> 2
    ipLen = ipLen - c - ipIPHLen
    If (ipConns%(ipConnR,connTCPFlag) And ipTSMask) = ipSynSent And Peek(Byte hdrAddr+hdrFlags) = (tcpSyn Or tcpAck) Then
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
    Select Case (ipConns%(ipConnR,connTCPFlag) And ipTSMask)
        Case ipSynRcvd
            If (ipFlags And ipAckData) = ipAckData Then
                ipConns%(ipConnR,connTCPFlag) = ipEstablished
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

