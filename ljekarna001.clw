

   MEMBER('ljekarna.clw')                                  ! This is a MEMBER module


   INCLUDE('ABBROWSE.INC'),ONCE
   INCLUDE('ABDROPS.INC'),ONCE
   INCLUDE('ABEIP.INC'),ONCE
   INCLUDE('ABPOPUP.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABUTIL.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE
   INCLUDE('BRWEXT.INC'),ONCE

                     MAP
                       INCLUDE('LJEKARNA001.INC'),ONCE        !Local module procedure declarations
                       INCLUDE('LJEKARNA002.INC'),ONCE        !Req'd for module callout resolution
                     END


!!! <summary>
!!! Generated from procedure template - Frame
!!! </summary>
Glavni_izbornik PROCEDURE 

SplashProcedureThread LONG
DisplayDayString STRING('Sunday   Monday   Tuesday  WednesdayThursday Friday   Saturday ')
DisplayDayText   STRING(9),DIM(7),OVER(DisplayDayString)
AppFrame             APPLICATION('Ljekarna'),AT(,,419,176),FONT('Calibri',12),RESIZE,MAX,STATUS(-1,80,120,45),SYSTEM, |
  WALLPAPER('pozadina.jpg'),IMM
                       MENUBAR,USE(?MENUBAR1)
                         MENU('Popisi'),USE(?MENU3)
                           ITEM('Proizvodjac'),USE(?ITEM1)
                           ITEM('Lijek'),USE(?ITEM2)
                           ITEM('Ljekarnik'),USE(?ITEM3)
                           ITEM('Kupac'),USE(?ITEM4)
                         END
                         MENU('Izvjesca'),USE(?MENU4)
                           ITEM('Ispis lijekova'),USE(?ITEM6)
                           ITEM('Ispis prodanih lijekova kod svakog ljekarnika'),USE(?ITEM5)
                         END
                         MENU('Datoteka'),USE(?FileMenu),RIGHT
                           ITEM('P&rint Setup...'),USE(?PrintSetup),MSG('Setup Printer'),STD(STD:PrintSetup)
                           ITEM,USE(?SEPARATOR1),SEPARATOR
                           ITEM('E&xit'),USE(?Exit),MSG('Exit this application'),STD(STD:Close)
                         END
                         MENU('Uredi'),USE(?EditMenu),RIGHT
                           ITEM('Cu&t'),USE(?Cut),MSG('Remove item to Windows Clipboard'),STD(STD:Cut)
                           ITEM('&Copy'),USE(?Copy),MSG('Copy item to Windows Clipboard'),STD(STD:Copy)
                           ITEM('&Paste'),USE(?Paste),MSG('Paste contents of Windows Clipboard'),STD(STD:Paste)
                         END
                         MENU('Prozor'),USE(?MENU1),MSG('Create and Arrange windows'),RIGHT,STD(STD:WindowList)
                           ITEM('T&ile'),USE(?Tile),MSG('Make all open windows visible'),STD(STD:TileWindow)
                           ITEM('&Cascade'),USE(?Cascade),MSG('Stack all open windows'),STD(STD:CascadeWindow)
                           ITEM('&Arrange Icons'),USE(?Arrange),MSG('Align all window icons'),STD(STD:ArrangeIcons)
                         END
                         MENU('Pomoc'),USE(?MENU2),MSG('Windows Help'),RIGHT
                           ITEM('&Contents'),USE(?Helpindex),MSG('View the contents of the help file'),STD(STD:HelpIndex)
                           ITEM('&Search for Help On...'),USE(?HelpSearch),MSG('Search for help on a subject'),STD(STD:HelpSearch)
                           ITEM('&How to Use Help'),USE(?HelpOnHelp),MSG('How to use Windows Help'),STD(STD:HelpOnHelp)
                         END
                       END
                       TOOLBAR,AT(0,0,419,17),USE(?TOOLBAR1)
                         BUTTON('LIJEK'),AT(166,0),USE(?BUTTON1)
                         BUTTON('LJEKARNIK'),AT(202,0),USE(?BUTTON2)
                       END
                     END

ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
TakeWindowEvent        PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------
Menu::MENUBAR1 ROUTINE                                     ! Code for menu items on ?MENUBAR1
Menu::MENU3 ROUTINE                                        ! Code for menu items on ?MENU3
  CASE ACCEPTED()
  OF ?ITEM1
    START(Popis_PRO, 50000)
  OF ?ITEM2
    START(Popis_LIJ, 50000)
  OF ?ITEM3
    START(Popis_LJK, 50000)
  OF ?ITEM4
    START(Popis_KUP, 50000)
  END
Menu::MENU4 ROUTINE                                        ! Code for menu items on ?MENU4
  CASE ACCEPTED()
  OF ?ITEM6
    START(Izvjesce_LIJ, 50000)
  OF ?ITEM5
    START(Izvjesce_LJK, 50000)
  END
Menu::FileMenu ROUTINE                                     ! Code for menu items on ?FileMenu
Menu::EditMenu ROUTINE                                     ! Code for menu items on ?EditMenu
Menu::MENU1 ROUTINE                                        ! Code for menu items on ?MENU1
Menu::MENU2 ROUTINE                                        ! Code for menu items on ?MENU2

ThisWindow.Ask PROCEDURE

  CODE
  IF NOT INRANGE(AppFrame{PROP:Timer},1,100)
    AppFrame{PROP:Timer} = 100
  END
    AppFrame{Prop:StatusText,3} = CLIP(DisplayDayText[(TODAY()%7)+1]) & ', ' & FORMAT(TODAY(),@D6)
    AppFrame{PROP:StatusText,4} = FORMAT(CLOCK(),@T2)
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('Glavni_izbornik')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = 1
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.Open(AppFrame)                                      ! Open window
  Do DefineListboxStyle
  INIMgr.Fetch('Glavni_izbornik',AppFrame)                 ! Restore window settings from non-volatile store
  SELF.SetAlerts()
      AppFrame{PROP:TabBarVisible}  = False
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.Opened
    INIMgr.Update('Glavni_izbornik',AppFrame)              ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.TakeAccepted PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receive all EVENT:Accepted's
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
    CASE ACCEPTED()
    ELSE
      DO Menu::MENUBAR1                                    ! Process menu items on ?MENUBAR1 menu
      DO Menu::MENU3                                       ! Process menu items on ?MENU3 menu
      DO Menu::MENU4                                       ! Process menu items on ?MENU4 menu
      DO Menu::FileMenu                                    ! Process menu items on ?FileMenu menu
      DO Menu::EditMenu                                    ! Process menu items on ?EditMenu menu
      DO Menu::MENU1                                       ! Process menu items on ?MENU1 menu
      DO Menu::MENU2                                       ! Process menu items on ?MENU2 menu
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?BUTTON1
      START(Popis_LIJ, 50000)
    OF ?BUTTON2
      START(Popis_LJK, 50000)
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeWindowEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receives all window specific events
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeWindowEvent()
    CASE EVENT()
    OF EVENT:OpenWindow
      SplashProcedureThread = START(Skocni_prozor)         ! Run the splash window procedure
    OF EVENT:Timer
      AppFrame{Prop:StatusText,3} = CLIP(DisplayDayText[(TODAY()%7)+1]) & ', ' & FORMAT(TODAY(),@D6)
      AppFrame{PROP:StatusText,4} = FORMAT(CLOCK(),@T2)
    ELSE
      IF SplashProcedureThread
        IF EVENT() = Event:Accepted
          POST(Event:CloseWindow,,SplashProcedureThread)   ! Close the splash window
          SplashPRocedureThread = 0
        END
     END
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue

!!! <summary>
!!! Generated from procedure template - Splash
!!! </summary>
Skocni_prozor PROCEDURE 

window               WINDOW,AT(,,204,112),FONT('Calibri',11),NOFRAME,CENTER,GRAY,MDI
                       PANEL,AT(0,-42,204,154),USE(?PANEL1),BEVEL(6)
                       PANEL,AT(7,6,191,98),USE(?PANEL2),BEVEL(-2,1)
                       STRING('Aplikacija za poslovanje ljekarne'),AT(13,12,182,10),USE(?String2),CENTER
                       IMAGE('sv_small.jpg'),AT(68,61),USE(?Image1)
                       PANEL,AT(12,33,182,12),USE(?PANEL3),BEVEL(-1,1,9)
                       STRING('Izradila: Mia Brusiæ'),AT(13,48,182,10),USE(?String1),CENTER
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
TakeWindowEvent        PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('Skocni_prozor')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?PANEL1
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.Open(window)                                        ! Open window
  Do DefineListboxStyle
  INIMgr.Fetch('Skocni_prozor',window)                     ! Restore window settings from non-volatile store
  TARGET{Prop:Timer} = 700                                 ! Close window on timer event, so configure timer
  TARGET{Prop:Alrt,255} = MouseLeft                        ! Alert mouse clicks that will close window
  TARGET{Prop:Alrt,254} = MouseLeft2
  TARGET{Prop:Alrt,253} = MouseRight
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.Opened
    INIMgr.Update('Skocni_prozor',window)                  ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.TakeWindowEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receives all window specific events
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeWindowEvent()
    CASE EVENT()
    OF EVENT:AlertKey
      CASE KEYCODE()
      OF MouseLeft
      OROF MouseLeft2
      OROF MouseRight
        POST(Event:CloseWindow)                            ! Splash window will close on mouse click
      END
    OF EVENT:LoseFocus
        POST(Event:CloseWindow)                            ! Splash window will close when focus is lost
    OF Event:Timer
      POST(Event:CloseWindow)                              ! Splash window will close on event timer
    OF Event:AlertKey
      CASE KEYCODE()                                       ! Splash window will close on mouse click
      OF MouseLeft
      OROF MouseLeft2
      OROF MouseRight
        POST(Event:CloseWindow)
      END
    ELSE
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue

!!! <summary>
!!! Generated from procedure template - Browse
!!! </summary>
Popis_PRO PROCEDURE 

BRW1::View:Browse    VIEW(PROIZVODJAC)
                       PROJECT(PRO:s_pro)
                       PROJECT(PRO:Naziv)
                       PROJECT(PRO:Kontakt)
                     END
Queue:Browse         QUEUE                            !Queue declaration for browse/combo box using ?List
PRO:s_pro              LIKE(PRO:s_pro)                !List box control field - type derived from field
PRO:Naziv              LIKE(PRO:Naziv)                !List box control field - type derived from field
PRO:Kontakt            LIKE(PRO:Kontakt)              !List box control field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
BrowseWindow         WINDOW('Popis proizvodjaca'),AT(0,0,247,140),FONT('Calibri',12),COLOR(00E6F5FDh),GRAY,MDI, |
  SYSTEM
                       LIST,AT(5,5,235,100),USE(?List),HVSCROLL,FORMAT('60L(2)|M~Sifra~C(0)@n-14@96L(2)|M~Nazi' & |
  'v~C(0)@s30@80L(2)|M~Kontakt~C(0)@S20@'),FROM(Queue:Browse),IMM,MSG('Browsing Records')
                       BUTTON('Unos'),AT(5,110,40,12),USE(?Insert)
                       BUTTON('Izmjena'),AT(50,110,40,12),USE(?Change),DEFAULT
                       BUTTON('Brisanje'),AT(95,110,40,12),USE(?Delete)
                       BUTTON('Odabir'),AT(145,110,40,12),USE(?Select)
                       BUTTON('Izlaz'),AT(200,110,40,12),USE(?Close)
                     END

BRW1::LastSortOrder       BYTE
BRW1::SortHeader  CLASS(SortHeaderClassType) !Declare SortHeader Class
QueueResorted          PROCEDURE(STRING pString),VIRTUAL
                  END
ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(USHORT Number,BYTE Request),BYTE,PROC,DERIVED
SetAlerts              PROCEDURE(),DERIVED
TakeEvent              PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
BRW1                 CLASS(BrowseClass)                    ! Browse using ?List
Q                      &Queue:Browse                  !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
SetSort                PROCEDURE(BYTE NewOrder,BYTE Force),BYTE,PROC,DERIVED
                     END

BRW1::Sort0:Locator  StepLocatorClass                      ! Default Locator
BRW1::EIPManager     BrowseEIPManager                      ! Browse EIP Manager for Browse using ?List
EditInPlace::PRO:s_pro EditEntryClass                      ! Edit-in-place class for field PRO:s_pro
EditInPlace::PRO:Naziv EditEntryClass                      ! Edit-in-place class for field PRO:Naziv
EditInPlace::PRO:Kontakt EditEntryClass                    ! Edit-in-place class for field PRO:Kontakt

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('Popis_PRO')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?List
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  IF SELF.Request = SelectRecord
     SELF.AddItem(?Close,RequestCancelled)                 ! Add the close control to the window manger
  ELSE
     SELF.AddItem(?Close,RequestCompleted)                 ! Add the close control to the window manger
  END
  Relate:PROIZVODJAC.SetOpenRelated()
  Relate:PROIZVODJAC.Open                                  ! File PROIZVODJAC used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  BRW1.Init(?List,Queue:Browse.ViewPosition,BRW1::View:Browse,Queue:Browse,Relate:PROIZVODJAC,SELF) ! Initialize the browse manager
  SELF.Open(BrowseWindow)                                  ! Open window
  Do DefineListboxStyle
  BRW1.Q &= Queue:Browse
  BRW1.AddSortOrder(,PRO:pk_pro)                           ! Add the sort order for PRO:pk_pro for sort order 1
  BRW1.AddLocator(BRW1::Sort0:Locator)                     ! Browse has a locator for sort order 1
  BRW1::Sort0:Locator.Init(,PRO:s_pro,1,BRW1)              ! Initialize the browse locator using  using key: PRO:pk_pro , PRO:s_pro
  BRW1.AddField(PRO:s_pro,BRW1.Q.PRO:s_pro)                ! Field PRO:s_pro is a hot field or requires assignment from browse
  BRW1.AddField(PRO:Naziv,BRW1.Q.PRO:Naziv)                ! Field PRO:Naziv is a hot field or requires assignment from browse
  BRW1.AddField(PRO:Kontakt,BRW1.Q.PRO:Kontakt)            ! Field PRO:Kontakt is a hot field or requires assignment from browse
  INIMgr.Fetch('Popis_PRO',BrowseWindow)                   ! Restore window settings from non-volatile store
  BRW1.AddToolbarTarget(Toolbar)                           ! Browse accepts toolbar control
  SELF.SetAlerts()
  !Initialize the Sort Header using the Browse Queue and Browse Control
  BRW1::SortHeader.Init(Queue:Browse,?List,'','',BRW1::View:Browse)
  BRW1::SortHeader.UseSortColors = False
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:PROIZVODJAC.Close
  !Kill the Sort Header
  BRW1::SortHeader.Kill()
  END
  IF SELF.Opened
    INIMgr.Update('Popis_PRO',BrowseWindow)                ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Run PROCEDURE(USHORT Number,BYTE Request)

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run(Number,Request)
  IF SELF.Request = ViewRecord
    ReturnValue = RequestCancelled                         ! Always return RequestCancelled if the form was opened in ViewRecord mode
  ELSE
    GlobalRequest = Request
    Azuriranje_PRO
    ReturnValue = GlobalResponse
  END
  RETURN ReturnValue


ThisWindow.SetAlerts PROCEDURE

  CODE
  PARENT.SetAlerts
  !Initialize the Sort Header using the Browse Queue and Browse Control
  BRW1::SortHeader.SetAlerts()


ThisWindow.TakeEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receives all events
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  !Take Sort Headers Events
  IF BRW1::SortHeader.TakeEvents()
     RETURN Level:Notify
  END
  ReturnValue = PARENT.TakeEvent()
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


BRW1.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  SELF.SelectControl = ?Select
  SELF.HideSelect = 1                                      ! Hide the select button when disabled
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  SELF.EIP &= BRW1::EIPManager                             ! Set the EIP manager
  SELF.AddEditControl(EditInPlace::PRO:s_pro,1)
  SELF.AddEditControl(EditInPlace::PRO:Naziv,2)
  SELF.AddEditControl(EditInPlace::PRO:Kontakt,3)
  SELF.DeleteAction = EIPAction:Always
  SELF.ArrowAction = EIPAction:Default+EIPAction:Remain+EIPAction:RetainColumn
  IF WM.Request <> ViewRecord                              ! If called for anything other than ViewMode, make the insert, change & delete controls available
    SELF.InsertControl=?Insert
    SELF.ChangeControl=?Change
    SELF.DeleteControl=?Delete
  END


BRW1.SetSort PROCEDURE(BYTE NewOrder,BYTE Force)

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.SetSort(NewOrder,Force)
  IF BRW1::LastSortOrder<>NewOrder THEN
     BRW1::SortHeader.ClearSort()
  END
  BRW1::LastSortOrder=NewOrder
  RETURN ReturnValue

BRW1::SortHeader.QueueResorted       PROCEDURE(STRING pString)
  CODE
    IF pString = ''
       BRW1.RestoreSort()
       BRW1.ResetSort(True)
    ELSE
       BRW1.ReplaceSort(pString,BRW1::Sort0:Locator)
       BRW1.SetLocatorFromSort()
    END
!!! <summary>
!!! Generated from procedure template - Browse
!!! </summary>
Popis_LIJ PROCEDURE 

BRW1::View:Browse    VIEW(LIJEK)
                       PROJECT(LIJ:s_lij)
                       PROJECT(LIJ:Ime_lijeka)
                       PROJECT(LIJ:Vrsta)
                       PROJECT(LIJ:Cijena)
                       PROJECT(LIJ:s_pro)
                       JOIN(PRO:pk_pro,LIJ:s_pro)
                         PROJECT(PRO:Naziv)
                         PROJECT(PRO:s_pro)
                       END
                     END
Queue:Browse         QUEUE                            !Queue declaration for browse/combo box using ?List
LIJ:s_lij              LIKE(LIJ:s_lij)                !List box control field - type derived from field
LIJ:Ime_lijeka         LIKE(LIJ:Ime_lijeka)           !List box control field - type derived from field
LIJ:Vrsta              LIKE(LIJ:Vrsta)                !List box control field - type derived from field
LIJ:Cijena             LIKE(LIJ:Cijena)               !List box control field - type derived from field
PRO:Naziv              LIKE(PRO:Naziv)                !List box control field - type derived from field
PRO:s_pro              LIKE(PRO:s_pro)                !Related join file key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
BrowseWindow         WINDOW('Popis lijekova'),AT(0,0,247,131),FONT('Calibri',12,,,CHARSET:DEFAULT),COLOR(00E6F5FDh), |
  GRAY,MDI,SYSTEM
                       LIST,AT(5,5,235,100),USE(?List),HVSCROLL,FORMAT('32L(2)|M~Sifra~C(0)@n-14@69L(1)|M~Ime ' & |
  'lijeka~C(0)@s40@47L(1)|M~Vrsta~C(0)@s20@34L(1)|M~Cijena~C(0)@n-10.2@120L(1)|M~Poizvo' & |
  'djac~C(0)@s30@'),FROM(Queue:Browse),IMM,MSG('Browsing Records')
                       BUTTON('Unos'),AT(5,110,40,12),USE(?Insert)
                       BUTTON('Izmjena'),AT(50,110,40,12),USE(?Change),DEFAULT
                       BUTTON('Brisanje'),AT(95,110,40,12),USE(?Delete)
                       BUTTON('Odabir'),AT(145,110,40,12),USE(?Select)
                       BUTTON('Izlaz'),AT(200,110,40,12),USE(?Close)
                     END

BRW1::LastSortOrder       BYTE
BRW1::SortHeader  CLASS(SortHeaderClassType) !Declare SortHeader Class
QueueResorted          PROCEDURE(STRING pString),VIRTUAL
                  END
ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(USHORT Number,BYTE Request),BYTE,PROC,DERIVED
SetAlerts              PROCEDURE(),DERIVED
TakeEvent              PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
BRW1                 CLASS(BrowseClass)                    ! Browse using ?List
Q                      &Queue:Browse                  !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
SetSort                PROCEDURE(BYTE NewOrder,BYTE Force),BYTE,PROC,DERIVED
                     END

BRW1::Sort0:Locator  StepLocatorClass                      ! Default Locator

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('Popis_LIJ')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?List
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  IF SELF.Request = SelectRecord
     SELF.AddItem(?Close,RequestCancelled)                 ! Add the close control to the window manger
  ELSE
     SELF.AddItem(?Close,RequestCompleted)                 ! Add the close control to the window manger
  END
  Relate:LIJEK.SetOpenRelated()
  Relate:LIJEK.Open                                        ! File LIJEK used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  BRW1.Init(?List,Queue:Browse.ViewPosition,BRW1::View:Browse,Queue:Browse,Relate:LIJEK,SELF) ! Initialize the browse manager
  SELF.Open(BrowseWindow)                                  ! Open window
  Do DefineListboxStyle
  BRW1.Q &= Queue:Browse
  BRW1.AddSortOrder(,LIJ:pk_lij)                           ! Add the sort order for LIJ:pk_lij for sort order 1
  BRW1.AddLocator(BRW1::Sort0:Locator)                     ! Browse has a locator for sort order 1
  BRW1::Sort0:Locator.Init(,LIJ:s_lij,1,BRW1)              ! Initialize the browse locator using  using key: LIJ:pk_lij , LIJ:s_lij
  BRW1.AddField(LIJ:s_lij,BRW1.Q.LIJ:s_lij)                ! Field LIJ:s_lij is a hot field or requires assignment from browse
  BRW1.AddField(LIJ:Ime_lijeka,BRW1.Q.LIJ:Ime_lijeka)      ! Field LIJ:Ime_lijeka is a hot field or requires assignment from browse
  BRW1.AddField(LIJ:Vrsta,BRW1.Q.LIJ:Vrsta)                ! Field LIJ:Vrsta is a hot field or requires assignment from browse
  BRW1.AddField(LIJ:Cijena,BRW1.Q.LIJ:Cijena)              ! Field LIJ:Cijena is a hot field or requires assignment from browse
  BRW1.AddField(PRO:Naziv,BRW1.Q.PRO:Naziv)                ! Field PRO:Naziv is a hot field or requires assignment from browse
  BRW1.AddField(PRO:s_pro,BRW1.Q.PRO:s_pro)                ! Field PRO:s_pro is a hot field or requires assignment from browse
  INIMgr.Fetch('Popis_LIJ',BrowseWindow)                   ! Restore window settings from non-volatile store
  BRW1.AskProcedure = 1                                    ! Will call: Azuriranje_LIJ
  BRW1.AddToolbarTarget(Toolbar)                           ! Browse accepts toolbar control
  SELF.SetAlerts()
  !Initialize the Sort Header using the Browse Queue and Browse Control
  BRW1::SortHeader.Init(Queue:Browse,?List,'','',BRW1::View:Browse)
  BRW1::SortHeader.UseSortColors = False
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:LIJEK.Close
  !Kill the Sort Header
  BRW1::SortHeader.Kill()
  END
  IF SELF.Opened
    INIMgr.Update('Popis_LIJ',BrowseWindow)                ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Run PROCEDURE(USHORT Number,BYTE Request)

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run(Number,Request)
  IF SELF.Request = ViewRecord
    ReturnValue = RequestCancelled                         ! Always return RequestCancelled if the form was opened in ViewRecord mode
  ELSE
    GlobalRequest = Request
    Azuriranje_LIJ
    ReturnValue = GlobalResponse
  END
  RETURN ReturnValue


ThisWindow.SetAlerts PROCEDURE

  CODE
  PARENT.SetAlerts
  !Initialize the Sort Header using the Browse Queue and Browse Control
  BRW1::SortHeader.SetAlerts()


ThisWindow.TakeEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receives all events
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  !Take Sort Headers Events
  IF BRW1::SortHeader.TakeEvents()
     RETURN Level:Notify
  END
  ReturnValue = PARENT.TakeEvent()
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


BRW1.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  SELF.SelectControl = ?Select
  SELF.HideSelect = 1                                      ! Hide the select button when disabled
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord                              ! If called for anything other than ViewMode, make the insert, change & delete controls available
    SELF.InsertControl=?Insert
    SELF.ChangeControl=?Change
    SELF.DeleteControl=?Delete
  END


BRW1.SetSort PROCEDURE(BYTE NewOrder,BYTE Force)

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.SetSort(NewOrder,Force)
  IF BRW1::LastSortOrder<>NewOrder THEN
     BRW1::SortHeader.ClearSort()
  END
  BRW1::LastSortOrder=NewOrder
  RETURN ReturnValue

BRW1::SortHeader.QueueResorted       PROCEDURE(STRING pString)
  CODE
    IF pString = ''
       BRW1.RestoreSort()
       BRW1.ResetSort(True)
    ELSE
       BRW1.ReplaceSort(pString,BRW1::Sort0:Locator)
       BRW1.SetLocatorFromSort()
    END
!!! <summary>
!!! Generated from procedure template - Browse
!!! </summary>
Popis_LJK PROCEDURE 

Broj_prodaja         SHORT                                 !Broj prodanih lijekova
BRW1::View:Browse    VIEW(LJEKARNIK)
                       PROJECT(LJK:s_ljk)
                       PROJECT(LJK:Ime)
                       PROJECT(LJK:Prezime)
                       PROJECT(LJK:Datum)
                       PROJECT(LJK:Adresa)
                     END
Queue:Browse         QUEUE                            !Queue declaration for browse/combo box using ?List
LJK:s_ljk              LIKE(LJK:s_ljk)                !List box control field - type derived from field
LJK:Ime                LIKE(LJK:Ime)                  !List box control field - type derived from field
LJK:Prezime            LIKE(LJK:Prezime)              !List box control field - type derived from field
LJK:Datum              LIKE(LJK:Datum)                !List box control field - type derived from field
LJK:Adresa             LIKE(LJK:Adresa)               !List box control field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
BRW5::View:Browse    VIEW(PRODAJE)
                       PROJECT(PRD:Datum_prodaje)
                       PROJECT(PRD:Iznos_lijeka)
                       PROJECT(PRD:Na_recept)
                       PROJECT(PRD:Subvencija)
                       PROJECT(PRD:s_ljk)
                       PROJECT(PRD:rbr)
                       PROJECT(PRD:s_lij)
                       JOIN(LIJ:pk_lij,PRD:s_lij)
                         PROJECT(LIJ:Ime_lijeka)
                         PROJECT(LIJ:s_lij)
                       END
                     END
Queue:Browse:1       QUEUE                            !Queue declaration for browse/combo box using ?List:2
PRD:Datum_prodaje      LIKE(PRD:Datum_prodaje)        !List box control field - type derived from field
LIJ:Ime_lijeka         LIKE(LIJ:Ime_lijeka)           !List box control field - type derived from field
PRD:Iznos_lijeka       LIKE(PRD:Iznos_lijeka)         !List box control field - type derived from field
PRD:Na_recept          LIKE(PRD:Na_recept)            !List box control field - type derived from field
PRD:Subvencija         LIKE(PRD:Subvencija)           !List box control field - type derived from field
PRD:s_ljk              LIKE(PRD:s_ljk)                !Primary key field - type derived from field
PRD:rbr                LIKE(PRD:rbr)                  !Primary key field - type derived from field
LIJ:s_lij              LIKE(LIJ:s_lij)                !Related join file key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
BrowseWindow         WINDOW('Popis ljekarnika'),AT(0,0,270,190),FONT('Calibri',12,,,CHARSET:DEFAULT),COLOR(00E6F5FDh), |
  GRAY,MDI,SYSTEM
                       SHEET,AT(2,2,260,84),USE(?SHEET1)
                         TAB('Po sifra'),USE(?TAB1)
                         END
                         TAB('Po prezimenu'),USE(?TAB2)
                         END
                       END
                       LIST,AT(12,18,241,62),USE(?List),HVSCROLL,FORMAT('30L|M~Sifra~C(0)@n-14@49L(2)|M~Ime~C(' & |
  '0)@s20@56L(2)|M~Prezime~C(0)@s20@52L(2)|M~Datum rodenja~C(0)@d6@160L(2)|M~Adresa~C(0)@s40@'), |
  FROM(Queue:Browse),IMM,MSG('Browsing Records')
                       BUTTON('Unos'),AT(13,88,40,12),USE(?Insert)
                       BUTTON('Izmjena'),AT(58,88,40,12),USE(?Change),DEFAULT
                       BUTTON('Brisanje'),AT(103,88,40,12),USE(?Delete)
                       BUTTON('Odabir'),AT(153,88,40,12),USE(?Select)
                       LIST,AT(8,120,186,65),USE(?List:2),HVSCROLL,FORMAT('49L(2)|M~Datum prodaje~C(0)@D6@75L(' & |
  '2)|M~Lijek~C(0)@s40@57L(2)|M~Iznos lijeka~C(0)@n-10.2@[34L(2)|M~Na recept~D(0)@n3@60' & |
  'L(2)|M~Postotak subvencije~D(1)@n-14@]|~Preko socijalnog~'),FROM(Queue:Browse:1),IMM,MSG('Datum prod' & |
  'aje lijeka'),TIP('Datum prodaje lijeka')
                       BUTTON('Unos'),AT(200,139,42,12),USE(?Insert:2)
                       BUTTON('Izmjena'),AT(200,153,42,12),USE(?Change:2)
                       BUTTON('Brisanje'),AT(200,168,42,12),USE(?Delete:2)
                       PROMPT('Broj prodaja:'),AT(120,107),USE(?Broj_prodaja:Prompt)
                       STRING(@n-7),AT(164,107,30),USE(Broj_prodaja),RIGHT(1)
                       BUTTON('Ispis odabrane prodaje'),AT(201,107,53,21),USE(?BUTTON1)
                       BUTTON('Izlaz'),AT(214,88,40,12),USE(?Close)
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(USHORT Number,BYTE Request),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
BRW1                 CLASS(BrowseClass)                    ! Browse using ?List
Q                      &Queue:Browse                  !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
ResetSort              PROCEDURE(BYTE Force),BYTE,PROC,DERIVED
                     END

BRW1::Sort0:Locator  StepLocatorClass                      ! Default Locator
BRW1::Sort1:Locator  StepLocatorClass                      ! Conditional Locator - CHOICE(?SHEET1)=2
BRW5                 CLASS(BrowseClass)                    ! Browse using ?List:2
Q                      &Queue:Browse:1                !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
ResetFromView          PROCEDURE(),DERIVED
                     END

BRW5::Sort0:Locator  StepLocatorClass                      ! Default Locator

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('Popis_LJK')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?List
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  IF SELF.Request = SelectRecord
     SELF.AddItem(?Close,RequestCancelled)                 ! Add the close control to the window manger
  ELSE
     SELF.AddItem(?Close,RequestCompleted)                 ! Add the close control to the window manger
  END
  Relate:LJEKARNIK.SetOpenRelated()
  Relate:LJEKARNIK.Open                                    ! File LJEKARNIK used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  BRW1.Init(?List,Queue:Browse.ViewPosition,BRW1::View:Browse,Queue:Browse,Relate:LJEKARNIK,SELF) ! Initialize the browse manager
  BRW5.Init(?List:2,Queue:Browse:1.ViewPosition,BRW5::View:Browse,Queue:Browse:1,Relate:PRODAJE,SELF) ! Initialize the browse manager
  SELF.Open(BrowseWindow)                                  ! Open window
  Do DefineListboxStyle
  BRW1.Q &= Queue:Browse
  BRW1.AddSortOrder(,LJK:sk_prezime)                       ! Add the sort order for LJK:sk_prezime for sort order 1
  BRW1.AddLocator(BRW1::Sort1:Locator)                     ! Browse has a locator for sort order 1
  BRW1::Sort1:Locator.Init(,LJK:Prezime,1,BRW1)            ! Initialize the browse locator using  using key: LJK:sk_prezime , LJK:Prezime
  BRW1.AddSortOrder(,LJK:pk_ljk)                           ! Add the sort order for LJK:pk_ljk for sort order 2
  BRW1.AddLocator(BRW1::Sort0:Locator)                     ! Browse has a locator for sort order 2
  BRW1::Sort0:Locator.Init(,LJK:s_ljk,1,BRW1)              ! Initialize the browse locator using  using key: LJK:pk_ljk , LJK:s_ljk
  BRW1.AddField(LJK:s_ljk,BRW1.Q.LJK:s_ljk)                ! Field LJK:s_ljk is a hot field or requires assignment from browse
  BRW1.AddField(LJK:Ime,BRW1.Q.LJK:Ime)                    ! Field LJK:Ime is a hot field or requires assignment from browse
  BRW1.AddField(LJK:Prezime,BRW1.Q.LJK:Prezime)            ! Field LJK:Prezime is a hot field or requires assignment from browse
  BRW1.AddField(LJK:Datum,BRW1.Q.LJK:Datum)                ! Field LJK:Datum is a hot field or requires assignment from browse
  BRW1.AddField(LJK:Adresa,BRW1.Q.LJK:Adresa)              ! Field LJK:Adresa is a hot field or requires assignment from browse
  BRW5.Q &= Queue:Browse:1
  BRW5.AddSortOrder(,PRD:pk_PRD)                           ! Add the sort order for PRD:pk_PRD for sort order 1
  BRW5.AddRange(PRD:s_ljk,LJK:s_ljk)                       ! Add single value range limit for sort order 1
  BRW5.AddLocator(BRW5::Sort0:Locator)                     ! Browse has a locator for sort order 1
  BRW5::Sort0:Locator.Init(,PRD:rbr,1,BRW5)                ! Initialize the browse locator using  using key: PRD:pk_PRD , PRD:rbr
  BRW5.AddField(PRD:Datum_prodaje,BRW5.Q.PRD:Datum_prodaje) ! Field PRD:Datum_prodaje is a hot field or requires assignment from browse
  BRW5.AddField(LIJ:Ime_lijeka,BRW5.Q.LIJ:Ime_lijeka)      ! Field LIJ:Ime_lijeka is a hot field or requires assignment from browse
  BRW5.AddField(PRD:Iznos_lijeka,BRW5.Q.PRD:Iznos_lijeka)  ! Field PRD:Iznos_lijeka is a hot field or requires assignment from browse
  BRW5.AddField(PRD:Na_recept,BRW5.Q.PRD:Na_recept)        ! Field PRD:Na_recept is a hot field or requires assignment from browse
  BRW5.AddField(PRD:Subvencija,BRW5.Q.PRD:Subvencija)      ! Field PRD:Subvencija is a hot field or requires assignment from browse
  BRW5.AddField(PRD:s_ljk,BRW5.Q.PRD:s_ljk)                ! Field PRD:s_ljk is a hot field or requires assignment from browse
  BRW5.AddField(PRD:rbr,BRW5.Q.PRD:rbr)                    ! Field PRD:rbr is a hot field or requires assignment from browse
  BRW5.AddField(LIJ:s_lij,BRW5.Q.LIJ:s_lij)                ! Field LIJ:s_lij is a hot field or requires assignment from browse
  INIMgr.Fetch('Popis_LJK',BrowseWindow)                   ! Restore window settings from non-volatile store
  BRW1.AskProcedure = 1                                    ! Will call: Azuriranje_LJK
  BRW5.AskProcedure = 2                                    ! Will call: Azuriranje_PRD(LJK:s_LJK)
  BRW1.AddToolbarTarget(Toolbar)                           ! Browse accepts toolbar control
  BRW5.AddToolbarTarget(Toolbar)                           ! Browse accepts toolbar control
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:LJEKARNIK.Close
  END
  IF SELF.Opened
    INIMgr.Update('Popis_LJK',BrowseWindow)                ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Run PROCEDURE(USHORT Number,BYTE Request)

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run(Number,Request)
  IF SELF.Request = ViewRecord
    ReturnValue = RequestCancelled                         ! Always return RequestCancelled if the form was opened in ViewRecord mode
  ELSE
    GlobalRequest = Request
    EXECUTE Number
      Azuriranje_LJK
      Azuriranje_PRD(LJK:s_LJK)
    END
    ReturnValue = GlobalResponse
  END
  RETURN ReturnValue


ThisWindow.TakeAccepted PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receive all EVENT:Accepted's
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?BUTTON1
      ThisWindow.Update()
      Izvjesce_PRD()
      ThisWindow.Reset
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


BRW1.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  SELF.SelectControl = ?Select
  SELF.HideSelect = 1                                      ! Hide the select button when disabled
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord                              ! If called for anything other than ViewMode, make the insert, change & delete controls available
    SELF.InsertControl=?Insert
    SELF.ChangeControl=?Change
    SELF.DeleteControl=?Delete
  END


BRW1.ResetSort PROCEDURE(BYTE Force)

ReturnValue          BYTE,AUTO

  CODE
  IF CHOICE(?SHEET1)=2
    RETURN SELF.SetSort(1,Force)
  ELSE
    RETURN SELF.SetSort(2,Force)
  END
  ReturnValue = PARENT.ResetSort(Force)
  RETURN ReturnValue


BRW5.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord                              ! If called for anything other than ViewMode, make the insert, change & delete controls available
    SELF.InsertControl=?Insert:2
    SELF.ChangeControl=?Change:2
    SELF.DeleteControl=?Delete:2
  END


BRW5.ResetFromView PROCEDURE

Broj_prodaja:Cnt     LONG                                  ! Count variable for browse totals
  CODE
  SETCURSOR(Cursor:Wait)
  Relate:PRODAJE.SetQuickScan(1)
  SELF.Reset
  IF SELF.UseMRP
     IF SELF.View{PROP:IPRequestCount} = 0
          SELF.View{PROP:IPRequestCount} = 60
     END
  END
  LOOP
    IF SELF.UseMRP
       IF SELF.View{PROP:IPRequestCount} = 0
            SELF.View{PROP:IPRequestCount} = 60
       END
    END
    CASE SELF.Next()
    OF Level:Notify
      BREAK
    OF Level:Fatal
      SETCURSOR()
      RETURN
    END
    SELF.SetQueueRecord
    Broj_prodaja:Cnt += 1
  END
  SELF.View{PROP:IPRequestCount} = 0
  Broj_prodaja = Broj_prodaja:Cnt
  PARENT.ResetFromView
  Relate:PRODAJE.SetQuickScan(0)
  SETCURSOR()

!!! <summary>
!!! Generated from procedure template - Browse
!!! </summary>
Popis_KUP PROCEDURE 

BRW1::View:Browse    VIEW(KUPAC)
                       PROJECT(KUP:s_kup)
                       PROJECT(KUP:Broj_kartice)
                       PROJECT(KUP:Ime)
                       PROJECT(KUP:Prezime)
                     END
Queue:Browse         QUEUE                            !Queue declaration for browse/combo box using ?List
KUP:s_kup              LIKE(KUP:s_kup)                !List box control field - type derived from field
KUP:Broj_kartice       LIKE(KUP:Broj_kartice)         !List box control field - type derived from field
KUP:Ime                LIKE(KUP:Ime)                  !List box control field - type derived from field
KUP:Prezime            LIKE(KUP:Prezime)              !List box control field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
BrowseWindow         WINDOW('Popis kupaca'),AT(0,0,247,140),FONT('Calibri',12,,,CHARSET:DEFAULT),COLOR(00F0FAFFh), |
  GRAY,MDI,SYSTEM
                       LIST,AT(5,5,235,100),USE(?List),FONT('Calibri',12,,,CHARSET:DEFAULT),HVSCROLL,FORMAT('32L(2)|M~S' & |
  'ifra~C(0)@n-14@46L(2)|M~Broj kartice~C(0)@P########P@62L(2)|M~Ime~C(0)@s20@80L(2)|M~' & |
  'Prezime~C(0)@s20@'),FROM(Queue:Browse),IMM,MSG('Browsing Records')
                       BUTTON('Unos'),AT(5,110,40,12),USE(?Insert)
                       BUTTON('Izmjena'),AT(50,110,40,12),USE(?Change),DEFAULT
                       BUTTON('Brisanje'),AT(95,110,40,12),USE(?Delete)
                       BUTTON('Odabir'),AT(145,110,40,12),USE(?Select)
                       BUTTON('Izlaz'),AT(200,110,40,12),USE(?Close)
                     END

BRW1::LastSortOrder       BYTE
BRW1::SortHeader  CLASS(SortHeaderClassType) !Declare SortHeader Class
QueueResorted          PROCEDURE(STRING pString),VIRTUAL
                  END
ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(USHORT Number,BYTE Request),BYTE,PROC,DERIVED
SetAlerts              PROCEDURE(),DERIVED
TakeEvent              PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
BRW1                 CLASS(BrowseClass)                    ! Browse using ?List
Q                      &Queue:Browse                  !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
SetSort                PROCEDURE(BYTE NewOrder,BYTE Force),BYTE,PROC,DERIVED
                     END

BRW1::Sort0:Locator  StepLocatorClass                      ! Default Locator

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('Popis_KUP')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?List
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  IF SELF.Request = SelectRecord
     SELF.AddItem(?Close,RequestCancelled)                 ! Add the close control to the window manger
  ELSE
     SELF.AddItem(?Close,RequestCompleted)                 ! Add the close control to the window manger
  END
  Relate:KUPAC.Open                                        ! File KUPAC used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  BRW1.Init(?List,Queue:Browse.ViewPosition,BRW1::View:Browse,Queue:Browse,Relate:KUPAC,SELF) ! Initialize the browse manager
  SELF.Open(BrowseWindow)                                  ! Open window
  Do DefineListboxStyle
  BRW1.Q &= Queue:Browse
  BRW1.AddSortOrder(,KUP:pk_kup)                           ! Add the sort order for KUP:pk_kup for sort order 1
  BRW1.AddLocator(BRW1::Sort0:Locator)                     ! Browse has a locator for sort order 1
  BRW1::Sort0:Locator.Init(,KUP:s_kup,1,BRW1)              ! Initialize the browse locator using  using key: KUP:pk_kup , KUP:s_kup
  BRW1.AddField(KUP:s_kup,BRW1.Q.KUP:s_kup)                ! Field KUP:s_kup is a hot field or requires assignment from browse
  BRW1.AddField(KUP:Broj_kartice,BRW1.Q.KUP:Broj_kartice)  ! Field KUP:Broj_kartice is a hot field or requires assignment from browse
  BRW1.AddField(KUP:Ime,BRW1.Q.KUP:Ime)                    ! Field KUP:Ime is a hot field or requires assignment from browse
  BRW1.AddField(KUP:Prezime,BRW1.Q.KUP:Prezime)            ! Field KUP:Prezime is a hot field or requires assignment from browse
  INIMgr.Fetch('Popis_KUP',BrowseWindow)                   ! Restore window settings from non-volatile store
  BRW1.AskProcedure = 1                                    ! Will call: Azuriranje_KUP
  BRW1.AddToolbarTarget(Toolbar)                           ! Browse accepts toolbar control
  SELF.SetAlerts()
  !Initialize the Sort Header using the Browse Queue and Browse Control
  BRW1::SortHeader.Init(Queue:Browse,?List,'','',BRW1::View:Browse)
  BRW1::SortHeader.UseSortColors = False
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:KUPAC.Close
  !Kill the Sort Header
  BRW1::SortHeader.Kill()
  END
  IF SELF.Opened
    INIMgr.Update('Popis_KUP',BrowseWindow)                ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Run PROCEDURE(USHORT Number,BYTE Request)

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run(Number,Request)
  IF SELF.Request = ViewRecord
    ReturnValue = RequestCancelled                         ! Always return RequestCancelled if the form was opened in ViewRecord mode
  ELSE
    GlobalRequest = Request
    Azuriranje_KUP
    ReturnValue = GlobalResponse
  END
  RETURN ReturnValue


ThisWindow.SetAlerts PROCEDURE

  CODE
  PARENT.SetAlerts
  !Initialize the Sort Header using the Browse Queue and Browse Control
  BRW1::SortHeader.SetAlerts()


ThisWindow.TakeEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receives all events
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  !Take Sort Headers Events
  IF BRW1::SortHeader.TakeEvents()
     RETURN Level:Notify
  END
  ReturnValue = PARENT.TakeEvent()
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


BRW1.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  SELF.SelectControl = ?Select
  SELF.HideSelect = 1                                      ! Hide the select button when disabled
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord                              ! If called for anything other than ViewMode, make the insert, change & delete controls available
    SELF.InsertControl=?Insert
    SELF.ChangeControl=?Change
    SELF.DeleteControl=?Delete
  END


BRW1.SetSort PROCEDURE(BYTE NewOrder,BYTE Force)

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.SetSort(NewOrder,Force)
  IF BRW1::LastSortOrder<>NewOrder THEN
     BRW1::SortHeader.ClearSort()
  END
  BRW1::LastSortOrder=NewOrder
  RETURN ReturnValue

BRW1::SortHeader.QueueResorted       PROCEDURE(STRING pString)
  CODE
    IF pString = ''
       BRW1.RestoreSort()
       BRW1.ResetSort(True)
    ELSE
       BRW1.ReplaceSort(pString,BRW1::Sort0:Locator)
       BRW1.SetLocatorFromSort()
    END
!!! <summary>
!!! Generated from procedure template - Form
!!! </summary>
Azuriranje_KUP PROCEDURE 

ActionMessage        CSTRING(40)                           !
History::KUP:Record  LIKE(KUP:RECORD),THREAD
FormWindow           WINDOW('Azuriranje kupca'),AT(,,190,91),FONT('Calibri',12,,,CHARSET:DEFAULT),CENTER,COLOR(00DCF8FFh), |
  GRAY,MDI,SYSTEM
                       PROMPT('Sifra:'),AT(20,6),USE(?KUP:s_kup:Prompt)
                       ENTRY(@n-14),AT(69,6,60,10),USE(KUP:s_kup),RIGHT(1),MSG('Sifra kupca'),READONLY,REQ,SKIP,TIP('Sifra kupca')
                       PROMPT('Broj kartice:'),AT(20,20),USE(?KUP:Broj_kartice:Prompt)
                       ENTRY(@P########P),AT(69,19,60,10),USE(KUP:Broj_kartice),MSG('Broj kartice dopunskog'),REQ, |
  TIP('Broj kartice dopunskog')
                       PROMPT('Ime:'),AT(19,33),USE(?KUP:Ime:Prompt)
                       ENTRY(@s20),AT(69,33,60,10),USE(KUP:Ime),MSG('Ime kupca'),REQ,TIP('Ime kupca')
                       PROMPT('Prezime:'),AT(19,47),USE(?KUP:Prezime:Prompt)
                       ENTRY(@s20),AT(69,46,60,10),USE(KUP:Prezime),MSG('Prezime kupca'),REQ,TIP('Prezime kupca')
                       BUTTON('U redu'),AT(4,72,40,12),USE(?OK),DEFAULT,REQ
                       BUTTON('Zatvori'),AT(49,72,40,12),USE(?Cancel)
                       STRING(@S40),AT(94,72,89),USE(ActionMessage)
                     END

ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
ToolbarForm          ToolbarUpdateClass                    ! Form Toolbar Manager
CurCtrlFeq          LONG
FieldColorQueue     QUEUE
Feq                   LONG
OldColor              LONG
                    END

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Ask PROCEDURE

  CODE
  CASE SELF.Request                                        ! Configure the action message text
  OF ViewRecord
    ActionMessage = 'Pregled kupca'
  OF InsertRecord
    ActionMessage = 'Unos kupca'
  OF ChangeRecord
    ActionMessage = 'Izmjena kupca'
  OF DeleteRecord
    ActionMessage = 'Brisanje kupca'
  END
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('Azuriranje_KUP')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?KUP:s_kup:Prompt
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.HistoryKey = CtrlH
  SELF.AddHistoryFile(KUP:Record,History::KUP:Record)
  SELF.AddHistoryField(?KUP:s_kup,1)
  SELF.AddHistoryField(?KUP:Broj_kartice,2)
  SELF.AddHistoryField(?KUP:Ime,3)
  SELF.AddHistoryField(?KUP:Prezime,4)
  SELF.AddUpdateFile(Access:KUPAC)
  SELF.AddItem(?Cancel,RequestCancelled)                   ! Add the cancel control to the window manager
  Relate:KUPAC.Open                                        ! File KUPAC used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Primary &= Relate:KUPAC
  IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing ! Setup actions for ViewOnly Mode
    SELF.InsertAction = Insert:None
    SELF.DeleteAction = Delete:None
    SELF.ChangeAction = Change:None
    SELF.CancelAction = Cancel:Cancel
    SELF.OkControl = 0
  ELSE
    SELF.DeleteAction = Delete:Form                        ! Display form on delete
    SELF.ChangeAction = Change:Caller                      ! Changes allowed
    SELF.CancelAction = Cancel:Cancel                      ! No confirm cancel
    SELF.OkControl = ?OK
    IF SELF.PrimeUpdate() THEN RETURN Level:Notify.
  END
  SELF.Open(FormWindow)                                    ! Open window
  Do DefineListboxStyle
  INIMgr.Fetch('Azuriranje_KUP',FormWindow)                ! Restore window settings from non-volatile store
  SELF.AddItem(ToolbarForm)
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:KUPAC.Close
  END
  IF SELF.Opened
    INIMgr.Update('Azuriranje_KUP',FormWindow)             ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Run PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run()
  IF SELF.Request = ViewRecord                             ! In View Only mode always signal RequestCancelled
    ReturnValue = RequestCancelled
  END
  RETURN ReturnValue


ThisWindow.TakeAccepted PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receive all EVENT:Accepted's
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?OK
      ThisWindow.Update()
      IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing THEN
         POST(EVENT:CloseWindow)
      END
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue

!!! <summary>
!!! Generated from procedure template - Form
!!! </summary>
Azuriranje_PRO PROCEDURE 

ActionMessage        CSTRING(40)                           !
History::PRO:Record  LIKE(PRO:RECORD),THREAD
FormWindow           WINDOW('Azuriranje proizvodjaca'),AT(,,201,70),FONT('Calibri',12,,,CHARSET:DEFAULT),CENTER, |
  COLOR(00DCF8FFh),GRAY,MDI,SYSTEM
                       PROMPT('Sifra:'),AT(22,7),USE(?PRO:s_pro:Prompt)
                       ENTRY(@n-14),AT(57,6,60,10),USE(PRO:s_pro),RIGHT(1),MSG('Sifra proizvodjaca'),READONLY,REQ, |
  SKIP,TIP('Sifra proizvodjaca')
                       PROMPT('Naziv:'),AT(22,20),USE(?PRO:Naziv:Prompt)
                       ENTRY(@s30),AT(57,19,60,10),USE(PRO:Naziv),MSG('Naziv proizvodjaca'),REQ,TIP('Naziv proizvodjaca')
                       PROMPT('Kontakt:'),AT(22,33),USE(?PRO:Kontakt:Prompt)
                       ENTRY(@S20),AT(57,33,60,10),USE(PRO:Kontakt),MSG('Kontakt proizvodjaca'),TIP('Kontakt pr' & |
  'oizvodjaca')
                       BUTTON('U redu'),AT(4,52,40,12),USE(?OK),DEFAULT,REQ
                       BUTTON('Zatvori'),AT(49,52,40,12),USE(?Cancel)
                       STRING(@S40),AT(94,52,101),USE(ActionMessage)
                     END

ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
ToolbarForm          ToolbarUpdateClass                    ! Form Toolbar Manager
CurCtrlFeq          LONG
FieldColorQueue     QUEUE
Feq                   LONG
OldColor              LONG
                    END

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Ask PROCEDURE

  CODE
  CASE SELF.Request                                        ! Configure the action message text
  OF ViewRecord
    ActionMessage = 'Pregled proizvodjaca'
  OF InsertRecord
    ActionMessage = 'Unos proizvodjaca'
  OF ChangeRecord
    ActionMessage = 'Izmjena proizvodjaca'
  OF DeleteRecord
    ActionMessage = 'Brisanje proizvodjaca'
  END
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('Azuriranje_PRO')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?PRO:s_pro:Prompt
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.HistoryKey = CtrlH
  SELF.AddHistoryFile(PRO:Record,History::PRO:Record)
  SELF.AddHistoryField(?PRO:s_pro,1)
  SELF.AddHistoryField(?PRO:Naziv,2)
  SELF.AddHistoryField(?PRO:Kontakt,3)
  SELF.AddUpdateFile(Access:PROIZVODJAC)
  SELF.AddItem(?Cancel,RequestCancelled)                   ! Add the cancel control to the window manager
  Relate:PROIZVODJAC.SetOpenRelated()
  Relate:PROIZVODJAC.Open                                  ! File PROIZVODJAC used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Primary &= Relate:PROIZVODJAC
  IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing ! Setup actions for ViewOnly Mode
    SELF.InsertAction = Insert:None
    SELF.DeleteAction = Delete:None
    SELF.ChangeAction = Change:None
    SELF.CancelAction = Cancel:Cancel
    SELF.OkControl = 0
  ELSE
    SELF.DeleteAction = Delete:Form                        ! Display form on delete
    SELF.ChangeAction = Change:Caller                      ! Changes allowed
    SELF.CancelAction = Cancel:Cancel                      ! No confirm cancel
    SELF.OkControl = ?OK
    IF SELF.PrimeUpdate() THEN RETURN Level:Notify.
  END
  SELF.Open(FormWindow)                                    ! Open window
  Do DefineListboxStyle
  INIMgr.Fetch('Azuriranje_PRO',FormWindow)                ! Restore window settings from non-volatile store
  SELF.AddItem(ToolbarForm)
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:PROIZVODJAC.Close
  END
  IF SELF.Opened
    INIMgr.Update('Azuriranje_PRO',FormWindow)             ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Run PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run()
  IF SELF.Request = ViewRecord                             ! In View Only mode always signal RequestCancelled
    ReturnValue = RequestCancelled
  END
  RETURN ReturnValue


ThisWindow.TakeAccepted PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receive all EVENT:Accepted's
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?OK
      ThisWindow.Update()
      IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing THEN
         POST(EVENT:CloseWindow)
      END
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue

!!! <summary>
!!! Generated from procedure template - Form
!!! </summary>
Azuriranje_LIJ PROCEDURE 

ActionMessage        CSTRING(40)                           !
FDCB5::View:FileDropCombo VIEW(PROIZVODJAC)
                       PROJECT(PRO:s_pro)
                       PROJECT(PRO:Naziv)
                     END
Queue:FileDropCombo  QUEUE                            !Queue declaration for browse/combo box using ?LIJ:s_pro:2
PRO:s_pro              LIKE(PRO:s_pro)                !List box control field - type derived from field
PRO:Naziv              LIKE(PRO:Naziv)                !List box control field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
History::LIJ:Record  LIKE(LIJ:RECORD),THREAD
FormWindow           WINDOW('Azuriranje lijeka'),AT(,,289,123),FONT('Calibri',12,,,CHARSET:DEFAULT),CENTER,COLOR(00DCF8FFh), |
  GRAY,MDI,SYSTEM
                       PROMPT('Sifra:'),AT(25,8),USE(?LIJ:s_lij:Prompt)
                       ENTRY(@n-14),AT(66,7,60,10),USE(LIJ:s_lij),RIGHT(1),MSG('Sifra lijeka'),READONLY,REQ,SKIP, |
  TIP('Sifra lijeka')
                       PROMPT('Ime lijeka:'),AT(25,21),USE(?LIJ:Ime_lijeka:Prompt)
                       ENTRY(@s40),AT(66,21,60,10),USE(LIJ:Ime_lijeka),MSG('Ime lijeka'),REQ,TIP('Ime lijeka')
                       OPTION('Vrsta:'),AT(184,7,89,75),USE(LIJ:Vrsta),BOXED,MSG('Vrsta lijeka'),TIP('Vrsta lijeka')
                         RADIO('Tableta'),AT(196,16),USE(?LIJ:Vrsta:Radio1),VALUE('Tableta')
                         RADIO('Tableta u kapsuli'),AT(196,27,68),USE(?LIJ:Vrsta:Radio2),VALUE('Tableta u kapsuli')
                         RADIO('Sumeca tableta'),AT(196,37,64),USE(?LIJ:Vrsta:Radio3),VALUE('Sumeca tableta')
                         RADIO('Krema'),AT(196,48),USE(?LIJ:Vrsta:Radio4),VALUE('Krema')
                         RADIO('Kapi'),AT(196,58),USE(?LIJ:Vrsta:Radio5),VALUE('Kapi')
                         RADIO('Sirup'),AT(196,68),USE(?LIJ:Vrsta:Radio6),VALUE('Sirup')
                       END
                       PROMPT('Cijena:'),AT(25,35),USE(?LIJ:Cijena:Prompt)
                       ENTRY(@n-10.2),AT(66,35,60,10),USE(LIJ:Cijena),DECIMAL(12),MSG('Cijena lijeka'),TIP('Cijena lijeka')
                       PROMPT('Opis lijeka:'),AT(25,48),USE(?LIJ:Opis_lijeka:Prompt)
                       TEXT,AT(66,49,106,29),USE(LIJ:Opis_lijeka),MSG('Opis lijeka'),TIP('Opis lijeka')
                       PROMPT('Proizvodjac:'),AT(25,80),USE(?LIJ:s_pro:Prompt)
                       COMBO(@n-14),AT(66,81,106,9),USE(LIJ:s_pro,,?LIJ:s_pro:2),RIGHT(1),DROP(5),FORMAT('34L(2)|M~S' & |
  'ifra~L(1)@n-14@120L(2)|M~Naziv~L(0)@s30@'),FROM(Queue:FileDropCombo),IMM,MSG('Sifra proizvodjaca'), |
  TIP('Sifra proizvodjaca')
                       BUTTON('U redu'),AT(10,104,40,12),USE(?OK),DEFAULT,REQ
                       BUTTON('Zatvori'),AT(55,104,40,12),USE(?Cancel)
                       STRING(@S40),AT(100,104),USE(ActionMessage)
                     END

ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(USHORT Number,BYTE Request),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
ToolbarForm          ToolbarUpdateClass                    ! Form Toolbar Manager
FDCB5                CLASS(FileDropComboClass)             ! File drop combo manager
Q                      &Queue:FileDropCombo           !Reference to browse queue type
                     END

CurCtrlFeq          LONG
FieldColorQueue     QUEUE
Feq                   LONG
OldColor              LONG
                    END

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Ask PROCEDURE

  CODE
  CASE SELF.Request                                        ! Configure the action message text
  OF ViewRecord
    ActionMessage = 'Pregled lijeka'
  OF InsertRecord
    ActionMessage = 'Unos lijeka'
  OF ChangeRecord
    ActionMessage = 'Izmjena lijeka'
  OF DeleteRecord
    ActionMessage = 'Brisanje lijeka'
  END
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('Azuriranje_LIJ')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?LIJ:s_lij:Prompt
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.HistoryKey = CtrlH
  SELF.AddHistoryFile(LIJ:Record,History::LIJ:Record)
  SELF.AddHistoryField(?LIJ:s_lij,1)
  SELF.AddHistoryField(?LIJ:Ime_lijeka,2)
  SELF.AddHistoryField(?LIJ:Vrsta,3)
  SELF.AddHistoryField(?LIJ:Cijena,4)
  SELF.AddHistoryField(?LIJ:Opis_lijeka,5)
  SELF.AddHistoryField(?LIJ:s_pro:2,6)
  SELF.AddUpdateFile(Access:LIJEK)
  SELF.AddItem(?Cancel,RequestCancelled)                   ! Add the cancel control to the window manager
  Relate:LIJEK.SetOpenRelated()
  Relate:LIJEK.Open                                        ! File LIJEK used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Primary &= Relate:LIJEK
  IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing ! Setup actions for ViewOnly Mode
    SELF.InsertAction = Insert:None
    SELF.DeleteAction = Delete:None
    SELF.ChangeAction = Change:None
    SELF.CancelAction = Cancel:Cancel
    SELF.OkControl = 0
  ELSE
    SELF.DeleteAction = Delete:Form                        ! Display form on delete
    SELF.ChangeAction = Change:Caller                      ! Changes allowed
    SELF.CancelAction = Cancel:Cancel                      ! No confirm cancel
    SELF.OkControl = ?OK
    IF SELF.PrimeUpdate() THEN RETURN Level:Notify.
  END
  SELF.Open(FormWindow)                                    ! Open window
  Do DefineListboxStyle
  INIMgr.Fetch('Azuriranje_LIJ',FormWindow)                ! Restore window settings from non-volatile store
  SELF.AddItem(ToolbarForm)
  FDCB5.Init(LIJ:s_pro,?LIJ:s_pro:2,Queue:FileDropCombo.ViewPosition,FDCB5::View:FileDropCombo,Queue:FileDropCombo,Relate:PROIZVODJAC,ThisWindow,GlobalErrors,1,1,0)
  FDCB5.AskProcedure = 1
  FDCB5.Q &= Queue:FileDropCombo
  FDCB5.AddSortOrder(PRO:pk_pro)
  FDCB5.AddField(PRO:s_pro,FDCB5.Q.PRO:s_pro) !List box control field - type derived from field
  FDCB5.AddField(PRO:Naziv,FDCB5.Q.PRO:Naziv) !List box control field - type derived from field
  FDCB5.AddUpdateField(PRO:s_pro,LIJ:s_pro)
  ThisWindow.AddItem(FDCB5.WindowComponent)
  FDCB5.DefaultFill = 0
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:LIJEK.Close
  END
  IF SELF.Opened
    INIMgr.Update('Azuriranje_LIJ',FormWindow)             ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Run PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run()
  IF SELF.Request = ViewRecord                             ! In View Only mode always signal RequestCancelled
    ReturnValue = RequestCancelled
  END
  RETURN ReturnValue


ThisWindow.Run PROCEDURE(USHORT Number,BYTE Request)

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run(Number,Request)
  IF SELF.Request = ViewRecord
    ReturnValue = RequestCancelled                         ! Always return RequestCancelled if the form was opened in ViewRecord mode
  ELSE
    GlobalRequest = Request
    Azuriranje_PRO
    ReturnValue = GlobalResponse
  END
  RETURN ReturnValue


ThisWindow.TakeAccepted PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receive all EVENT:Accepted's
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?LIJ:s_pro:2
      FDCB5.TakeAccepted()
      IF Access:LIJEK.TryValidateField(6)                  ! Attempt to validate LIJ:s_pro in LIJEK
        SELECT(?LIJ:s_pro:2)
        FormWindow{PROP:AcceptAll} = False
        CYCLE
      ELSE
        FieldColorQueue.Feq = ?LIJ:s_pro:2
        GET(FieldColorQueue, FieldColorQueue.Feq)
        IF ERRORCODE() = 0
          ?LIJ:s_pro:2{PROP:FontColor} = FieldColorQueue.OldColor
          DELETE(FieldColorQueue)
        END
      END
    OF ?OK
      ThisWindow.Update()
      IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing THEN
         POST(EVENT:CloseWindow)
      END
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue

!!! <summary>
!!! Generated from procedure template - Form
!!! </summary>
Azuriranje_LJK PROCEDURE 

ActionMessage        CSTRING(40)                           !
History::LJK:Record  LIKE(LJK:RECORD),THREAD
FormWindow           WINDOW('Azuriranje ljekarnika'),AT(,,175,101),FONT('Calibri',12,,,CHARSET:DEFAULT),CENTER, |
  COLOR(00DCF8FFh),GRAY,MDI,SYSTEM
                       PROMPT('Sifra:'),AT(21,9),USE(?LJK:s_ljk:Prompt)
                       ENTRY(@n-14),AT(76,8,60,10),USE(LJK:s_ljk),RIGHT(1),MSG('Sifra ljekarnika'),READONLY,REQ,SKIP, |
  TIP('Sifra ljekarnika')
                       PROMPT('Ime:'),AT(21,22),USE(?LJK:Ime:Prompt)
                       ENTRY(@s20),AT(76,22,60,10),USE(LJK:Ime),MSG('Ime ljekarnika'),REQ,TIP('Ime ljekarnika')
                       PROMPT('Prezime:'),AT(21,36),USE(?LJK:Prezime:Prompt)
                       ENTRY(@s20),AT(76,35,60,10),USE(LJK:Prezime),MSG('Prezime ljekarnika'),REQ,TIP('Prezime ljekarnika')
                       PROMPT('Datum rodenja:'),AT(21,49),USE(?LJK:Datum:Prompt)
                       ENTRY(@d6),AT(76,48,48,10),USE(LJK:Datum),MSG('Datum rodenja'),TIP('Datum rodenja')
                       BUTTON('...'),AT(124,47,12,12),USE(?Calendar)
                       PROMPT('Adresa:'),AT(21,63),USE(?LJK:Adresa:Prompt)
                       ENTRY(@s40),AT(76,62,60,10),USE(LJK:Adresa),MSG('Adresa prebivalista'),TIP('Adresa prebivalista')
                       BUTTON('U redu'),AT(4,82,40,12),USE(?OK),DEFAULT,REQ
                       BUTTON('Zatvori'),AT(49,82,40,12),USE(?Cancel)
                       STRING(@S40),AT(94,82,70),USE(ActionMessage)
                     END

ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
ToolbarForm          ToolbarUpdateClass                    ! Form Toolbar Manager
Calendar5            CalendarClass
CurCtrlFeq          LONG
FieldColorQueue     QUEUE
Feq                   LONG
OldColor              LONG
                    END

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Ask PROCEDURE

  CODE
  CASE SELF.Request                                        ! Configure the action message text
  OF ViewRecord
    ActionMessage = 'Pregled ljekarnika'
  OF InsertRecord
    ActionMessage = 'Unos ljekarnika'
  OF ChangeRecord
    ActionMessage = 'Izmjena ljekarnika'
  OF DeleteRecord
    ActionMessage = 'Brisanje ljekarnika'
  END
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('Azuriranje_LJK')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?LJK:s_ljk:Prompt
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.HistoryKey = CtrlH
  SELF.AddHistoryFile(LJK:Record,History::LJK:Record)
  SELF.AddHistoryField(?LJK:s_ljk,1)
  SELF.AddHistoryField(?LJK:Ime,2)
  SELF.AddHistoryField(?LJK:Prezime,3)
  SELF.AddHistoryField(?LJK:Datum,4)
  SELF.AddHistoryField(?LJK:Adresa,5)
  SELF.AddUpdateFile(Access:LJEKARNIK)
  SELF.AddItem(?Cancel,RequestCancelled)                   ! Add the cancel control to the window manager
  Relate:LJEKARNIK.SetOpenRelated()
  Relate:LJEKARNIK.Open                                    ! File LJEKARNIK used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Primary &= Relate:LJEKARNIK
  IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing ! Setup actions for ViewOnly Mode
    SELF.InsertAction = Insert:None
    SELF.DeleteAction = Delete:None
    SELF.ChangeAction = Change:None
    SELF.CancelAction = Cancel:Cancel
    SELF.OkControl = 0
  ELSE
    SELF.DeleteAction = Delete:Form                        ! Display form on delete
    SELF.ChangeAction = Change:Caller                      ! Changes allowed
    SELF.CancelAction = Cancel:Cancel                      ! No confirm cancel
    SELF.OkControl = ?OK
    IF SELF.PrimeUpdate() THEN RETURN Level:Notify.
  END
  SELF.Open(FormWindow)                                    ! Open window
  Do DefineListboxStyle
  INIMgr.Fetch('Azuriranje_LJK',FormWindow)                ! Restore window settings from non-volatile store
  SELF.AddItem(ToolbarForm)
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:LJEKARNIK.Close
  END
  IF SELF.Opened
    INIMgr.Update('Azuriranje_LJK',FormWindow)             ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Run PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run()
  IF SELF.Request = ViewRecord                             ! In View Only mode always signal RequestCancelled
    ReturnValue = RequestCancelled
  END
  RETURN ReturnValue


ThisWindow.TakeAccepted PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receive all EVENT:Accepted's
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?Calendar
      ThisWindow.Update()
      Calendar5.SelectOnClose = True
      Calendar5.Ask('Select a Date',LJK:Datum)
      IF Calendar5.Response = RequestCompleted THEN
      LJK:Datum=Calendar5.SelectedDate
      DISPLAY(?LJK:Datum)
      END
      ThisWindow.Reset(True)
    OF ?OK
      ThisWindow.Update()
      IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing THEN
         POST(EVENT:CloseWindow)
      END
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue

