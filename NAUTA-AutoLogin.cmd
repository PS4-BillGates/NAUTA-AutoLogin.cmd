@ECHO OFF

SETLOCAL EnableDelayedExpansion

:://////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
:://	Default configuration values
:://////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

SET username=my_user@nauta.com.cu
SET password=my_password

SET ping_address=cubadebate.cu
SET ping_count=10
SET ping_delay=1

SET pause_countdown=15

SET connection_status=0
SET connection_status_beep=1

:://////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
:://	Main code
:://////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
CALL :Init

:Main_Loop
	IF %connection_status% EQU 1 (

		CALL :Main_Screen
		CALL :Test_Connection

		GOTO Main_Loop

	) ELSE (

		CALL :Login_Error

		curl --silent --data "username=%username%&password=%password%" https://secure.etecsa.net:8443/LoginServlet > NUL
		CALL :Test_Connection
	)

	GOTO Main_Loop

:://////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
:://	Check the current Connection-Status
:://////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
:Test_Connection
	FOR /L %%i IN (1, 1, 120) DO ECHO [29;%%iH 

	FOR /L %%i IN (1, 1, %ping_count%) DO (
 		ping -4 -n 1 %ping_address% | find "TTL" > NUL

		IF !ERRORLEVEL!==0 (

			SET connection_status=1

			CLS

			EXIT /B
		)

		ECHO [0m[92m[29;53HT E S T I N G
		SET /A L_dot = 53-2*%%i
		SET /A R_dot = 65+2*%%i
		ECHO [29;!L_dot!H.
		ECHO [29;!R_dot!H.

		TIMEOUT -T %ping_delay% -NOBREAK > NUL
	)

	SET connection_status=0

	CLS

	GOTO :EOF

:://////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
:://	Initialization
:://////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
:Init
	ECHO [?25l
	CLS
	CALL :Test_Connection

	GOTO :EOF

:://////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
:://	Perform a countdown before the next check.
:://////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
:Countdown
	ECHO [0m[27;0H
	TIMEOUT /T %pause_countdown% /NOBREAK

	GOTO :EOF

:://////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
:://	Main Screen (Shows if the Ping-Address is reachable). ]
:://////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
:Main_Screen
	ECHO [2;51H[92mYou are logged in![0m
	ECHO [4;37H[38;2;128;128;128mThere was a response from address [3m[4m[94m%ping_address%[0m
	ECHO [5;41H[38;2;128;128;128mA check-up will be performed every [93m%pause_countdown%s[0m.

	ECHO [8;1H[97m
	ECHO                                                                                ####
	ECHO                                                                               #####
	ECHO                                             #####+                           ##++#              #####
	ECHO                  ##### ########         ######++####    ######     #####   ####++#####      #####++#####
	ECHO                  #+++######+++##      ###+######++##    #+++#      #++##  ####++#####     ###+++#+++++#
	ECHO                 ##+++###  ##+++#     ##+###    #++#     #++##     ##++#      #++#       ###+++.---++++#
	ECHO                 ##++##     #+++#    ##+##     .#++#    ##++##     #+++#     ##++#      ##++++--++-+++##
	ECHO                 #+++#      #++##   ##++#      ##++#    #+++#      #+++#     #++##      ##+++--+++-#++#
	ECHO                 #++##     ##++#    #++##      #++##    #+++#     ##++##     #++#      ##+++--+++-.+++#
	ECHO                ##++##     #+++#   ##++#      ##++#     #+++#     #+++#     ##++#      #+++#-+++--#+++#
	ECHO                #+++#      #++##   ##++##    ##+++#    ##+++#    ##+++#     #+++#      #+++# ---.#++++#
	ECHO                #+++#     ##++##    ##++########++#    ##+++#######++##     #+++##-#   ##+++##+####+++#
	ECHO                #++##     #+++#      ##++++### #++#     ##++++### #++#+     ##+++###    ###+++### #++##
	ECHO [4m[22;15H#####      #####       ######  #####      ######   ####       ######       #####   #####
	ECHO [0m[23;59H[30m[48;2;127;127;127m    A u t o    L o g i n    S c r i p t     

	ECHO [0m[26;23H[3m[38;2;72;72;72m For configuration options you must edit the file [0m[33mNAUTA-AutoLogin.cmd

	CALL :Countdown

	GOTO :EOF

:://////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
:://	ERROR Screen (It is displayed in case of login or network error).
:://////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
:Login_Error
	ECHO [1;0H[6m[31mUNEXPECTED ERROR![0m Unable to contact server [3m[4m[94m%ping_address%[0m.
	ECHO.
	ECHO The connection to the [107m[38;2;228;141;6m NAUTA [38;2;0;0;102mHogar [0m service may be failing at some point.
	ECHO.
	ECHO [92mPossible causes:[0m
	ECHO ----------------
	ECHO [1]. [3m[38;2;128;128;128mThe domain name [4m[94m%ping_address%[0m [3m[38;2;128;128;128mmay be [33minvalid[38;2;128;128;128m or the [33mDNS server[38;2;128;128;128m could not be contacted.[0m
	ECHO [2]. [3m[38;2;128;128;128mYour account may be [33min use[38;2;128;128;128m, or it may have run out of [33mavailable balance[38;2;128;128;128m.[0m
	ECHO [3]. [3m[38;2;128;128;128mThere may be a problem with your [33mnetwork[38;2;128;128;128m or [33mequipment[38;2;128;128;128m.[0m
	ECHO [4]. [3m[38;2;128;128;128mA very [33mRestrictive Firewall[38;2;128;128;128m may be preventing the correct functioning of the [33mSupplementary Utilities[38;2;128;128;128m.[0m
	ECHO [x]. [3m[38;2;128;128;128mWe may be being [37minvaded[38;2;128;128;128m by an [37mintelligent species[38;2;128;128;128m from [37mouter space[38;2;128;128;128m.[0m
	ECHO.
	ECHO [92mOne way, another way, and either way [3m[30m[48;2;228;3;3m LA [48;2;255;140;0m CULPA [48;2;255;237;0m ES [48;2;0;128;38m DEL [48;2;0;77;255m BLOQ[48;2;117;7;135mUEO 

	ECHO [0m[96m
	ECHO [19;25H     (((           ___          \-^-/          '*`
	ECHO [20;25H    (o o)         (o o)         (o o)         (o o)         (o o)
	ECHO [21;25HooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-
	ECHO [30m[48;2;127;127;127m
	ECHO [22;25H  Freedom is the right to tell people what they do not want to hear.  

	IF %connection_status_beep%==1 (
		rundll32 user32.dll,MessageBeep
	)

	CALL :Countdown

	GOTO :EOF
