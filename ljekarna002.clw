

   MEMBER('ljekarna.clw')                                  ! This is a MEMBER module


   INCLUDE('ABBROWSE.INC'),ONCE
   INCLUDE('ABREPORT.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABUTIL.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

                     MAP
                       INCLUDE('LJEKARNA002.INC'),ONCE        !Local module procedure declarations
                       INCLUDE('LJEKARNA001.INC'),ONCE        !Req'd for module callout resolution
                     END


!!! <summary>
!!! Generated from procedure template - Form
!!! </summary>
Azuriranje_PRD PROCEDURE (LONG __sifra)

ActionMessage        CSTRING(40)                           !
History::PRD:Record  LIKE(PRD:RECORD),THREAD
FormWindow           WINDOW('Azuriranje prodaje'),AT(,,265,150),FONT('Calibri',12),CENTER,COLOR(00DCF8FFh),GRAY, |
  MDI,SYSTEM
                       PROMPT('Ljekarnik:'),AT(41,6),USE(?PRD:s_ljk:Prompt)
                       ENTRY(@n-14),AT(76,5,36,10),USE(PRD:s_ljk),RIGHT(1),MSG('Sifra ljekarnika'),READONLY,REQ,SKIP, |
  TIP('Sifra ljekarnika')
                       STRING(@s20),AT(116,6,42),USE(LJK:Ime),RIGHT
                       STRING(@s20),AT(161,6,56),USE(LJK:Prezime)
                       PROMPT('Rbr:'),AT(41,19),USE(?PRD:rbr:Prompt)
                       ENTRY(@n-14),AT(76,19,36,10),USE(PRD:rbr),RIGHT(1),MSG('Redni broj'),REQ,SKIP,TIP('Redni broj')
                       PROMPT('Datum prodaje:'),AT(9,37),USE(?PRD:Datum_prodaje:Prompt)
                       SPIN(@D6),AT(66,37,60,10),USE(PRD:Datum_prodaje),MSG('Datum prodaje lijeka'),REQ,TIP('Datum prod' & |
  'aje lijeka')
                       BUTTON('...'),AT(130,36,12,12),USE(?Calendar)
                       PROMPT('Lijek:'),AT(9,51),USE(?PRD:s_lij:Prompt)
                       ENTRY(@n-14),AT(66,51,25,10),USE(PRD:s_lij),RIGHT(1),MSG('Sifra lijeka'),REQ,TIP('Sifra lijeka')
                       BUTTON('Odabir lijeka'),AT(95,50,47,12),USE(?CallLookup:2)
                       STRING(@s40),AT(145,51,72),USE(LIJ:Ime_lijeka)
                       PROMPT('Jedinicna cijena:'),AT(9,65),USE(?PRD:Jedinicna_cijena:Prompt)
                       ENTRY(@n-10.2),AT(66,64,60,10),USE(PRD:Jedinicna_cijena),DECIMAL(12),MSG('Jedinièna cij' & |
  'ena lijeka'),READONLY,TIP('Jedinièna cijena lijeka')
                       PROMPT('Subvencija:'),AT(9,78),USE(?PRD:Subvencija:Prompt)
                       SPIN(@n-14),AT(66,78,32,10),USE(PRD:Subvencija),RIGHT(1),MSG('Postotak subvencije na ci' & |
  'jenu lijeka'),TIP('Postotak subvencije na cijenu lijeka')
                       PROMPT('Kolicina:'),AT(9,92),USE(?PRD:Kolicina:Prompt)
                       SPIN(@n-14),AT(66,91,32,10),USE(PRD:Kolicina),RIGHT(1),MSG('Kolièina'),TIP('Kolièina')
                       PROMPT('Iznos lijeka:'),AT(9,105),USE(?PRD:Iznos_lijeka:Prompt)
                       ENTRY(@n-10.2),AT(66,105,60,10),USE(PRD:Iznos_lijeka),DECIMAL(12),MSG('Iznos lijeka'),READONLY, |
  TIP('Iznos lijeka')
                       CHECK('Na recept'),AT(173,77),USE(PRD:Na_recept),MSG('Je li lijek na recept?'),TIP('Je li lije' & |
  'k na recept?')
                       PROMPT('Kupac:'),AT(145,92),USE(?PRD:s_kup:Prompt)
                       ENTRY(@n-14),AT(174,91,24,10),USE(PRD:s_kup),RIGHT(1),MSG('Sifra kupca'),REQ,TIP('Sifra kupca')
                       BUTTON('...'),AT(202,90,12,12),USE(?CallLookup)
                       BUTTON('U redu'),AT(5,131,40,12),USE(?OK),DEFAULT,REQ
                       BUTTON('Zatvori'),AT(50,131,40,12),USE(?Cancel)
                       STRING(@S40),AT(95,131),USE(ActionMessage)
                     END

ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(USHORT Number,BYTE Request),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
TakeFieldEvent         PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
Calendar7            CalendarClass
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
    ActionMessage = 'Pregled prodaje'
  OF InsertRecord
    ActionMessage = 'Unos prodaje'
  OF ChangeRecord
    ActionMessage = 'Izmjena prodaje'
  OF DeleteRecord
    ActionMessage = 'Brisanje prodaje'
  END
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('Azuriranje_PRD')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?PRD:s_ljk:Prompt
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.HistoryKey = CtrlH
  SELF.AddHistoryFile(PRD:Record,History::PRD:Record)
  SELF.AddHistoryField(?PRD:s_ljk,1)
  SELF.AddHistoryField(?PRD:rbr,2)
  SELF.AddHistoryField(?PRD:Datum_prodaje,3)
  SELF.AddHistoryField(?PRD:s_lij,4)
  SELF.AddHistoryField(?PRD:Jedinicna_cijena,5)
  SELF.AddHistoryField(?PRD:Subvencija,7)
  SELF.AddHistoryField(?PRD:Kolicina,8)
  SELF.AddHistoryField(?PRD:Iznos_lijeka,9)
  SELF.AddHistoryField(?PRD:Na_recept,6)
  SELF.AddHistoryField(?PRD:s_kup,10)
  SELF.AddUpdateFile(Access:PRODAJE)
  SELF.AddItem(?Cancel,RequestCancelled)                   ! Add the cancel control to the window manager
  Relate:KUPAC.SetOpenRelated()
  Relate:KUPAC.Open                                        ! File KUPAC used by this procedure, so make sure it's RelationManager is open
  Access:LIJEK.UseFile                                     ! File referenced in 'Other Files' so need to inform it's FileManager
  Access:LJEKARNIK.UseFile                                 ! File referenced in 'Other Files' so need to inform it's FileManager
  SELF.FilesOpened = True
  PRD:s_ljk = __sifra
  SELF.Primary &= Relate:PRODAJE
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
  INIMgr.Fetch('Azuriranje_PRD',FormWindow)                ! Restore window settings from non-volatile store
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
    INIMgr.Update('Azuriranje_PRD',FormWindow)             ! Save window data to non-volatile store
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
    EXECUTE Number
      Popis_LIJ
      Popis_KUP
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
    OF ?Calendar
      ThisWindow.Update()
      Calendar7.SelectOnClose = True
      Calendar7.Ask('Select a Date',PRD:Datum_prodaje)
      IF Calendar7.Response = RequestCompleted THEN
      PRD:Datum_prodaje=Calendar7.SelectedDate
      DISPLAY(?PRD:Datum_prodaje)
      END
      ThisWindow.Reset(True)
    OF ?PRD:s_lij
      LIJ:s_lij = PRD:s_lij
      IF Access:LIJEK.TryFetch(LIJ:pk_lij)
        IF SELF.Run(1,SelectRecord) = RequestCompleted
          PRD:s_lij = LIJ:s_lij
        ELSE
          SELECT(?PRD:s_lij)
          CYCLE
        END
      END
      ThisWindow.Reset()
      IF Access:PRODAJE.TryValidateField(4)                ! Attempt to validate PRD:s_lij in PRODAJE
        SELECT(?PRD:s_lij)
        FormWindow{PROP:AcceptAll} = False
        CYCLE
      ELSE
        FieldColorQueue.Feq = ?PRD:s_lij
        GET(FieldColorQueue, FieldColorQueue.Feq)
        IF ERRORCODE() = 0
          ?PRD:s_lij{PROP:FontColor} = FieldColorQueue.OldColor
          DELETE(FieldColorQueue)
        END
      END
    OF ?CallLookup:2
      ThisWindow.Update()
      PRD:Jedinicna_cijena = LIJ:Cijena
      LIJ:s_lij = PRD:s_lij
      IF SELF.Run(1,SelectRecord) = RequestCompleted
        PRD:s_lij = LIJ:s_lij
      END
      ThisWindow.Reset(1)
    OF ?PRD:Subvencija
      PRD:Iznos_lijeka = PRD:Kolicina * (1 - PRD:Subvencija/100) * PRD:Jedinicna_cijena
    OF ?PRD:Kolicina
      PRD:Iznos_lijeka = PRD:Kolicina * (1 - PRD:Subvencija/100) * PRD:Jedinicna_cijena
    OF ?PRD:s_kup
      IF PRD:s_kup OR ?PRD:s_kup{PROP:Req}
        KUP:s_kup = PRD:s_kup
        IF Access:KUPAC.TryFetch(KUP:pk_kup)
          IF SELF.Run(2,SelectRecord) = RequestCompleted
            PRD:s_kup = KUP:s_kup
          ELSE
            SELECT(?PRD:s_kup)
            CYCLE
          END
        END
      END
      ThisWindow.Reset()
    OF ?CallLookup
      ThisWindow.Update()
      KUP:s_kup = PRD:s_kup
      IF SELF.Run(2,SelectRecord) = RequestCompleted
        PRD:s_kup = KUP:s_kup
      END
      ThisWindow.Reset(1)
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


ThisWindow.TakeFieldEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receives all field specific events
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeFieldEvent()
  CASE FIELD()
  OF ?PRD:Jedinicna_cijena
    CASE EVENT()
    OF EVENT:Selecting
      PRD:Jedinicna_cijena = LIJ:Cijena
    END
  END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue

!!! <summary>
!!! Generated from procedure template - Report
!!! </summary>
Izvjesce_LJK PROCEDURE 

Progress:Thermometer BYTE                                  !
Process:View         VIEW(LJEKARNIK)
                       PROJECT(LJK:Ime)
                       PROJECT(LJK:Prezime)
                       PROJECT(LJK:s_ljk)
                       JOIN(PRD:pk_PRD,LJK:s_ljk)
                         PROJECT(PRD:Datum_prodaje)
                         PROJECT(PRD:Iznos_lijeka)
                         PROJECT(PRD:Kolicina)
                         PROJECT(PRD:s_lij)
                         JOIN(LIJ:pk_lij,PRD:s_lij)
                           PROJECT(LIJ:Ime_lijeka)
                         END
                       END
                     END
ReportPageNumber     LONG,AUTO
ProgressWindow       WINDOW('Ispis ljekarnikovih prodaja'),AT(,,142,59),FONT('Calibri',12,,,CHARSET:DEFAULT),DOUBLE, |
  CENTER,GRAY,TIMER(1)
                       PROGRESS,AT(15,15,111,12),USE(Progress:Thermometer),RANGE(0,100)
                       STRING(''),AT(0,3,141,10),USE(?Progress:UserString),CENTER
                       STRING(''),AT(0,30,141,10),USE(?Progress:PctText),CENTER
                       BUTTON('Zatvori'),AT(45,42,50,15),USE(?Progress:Cancel)
                     END

Report               REPORT,AT(1000,2000,6250,7688),PRE(RPT),PAPER(PAPER:A4),FONT('Arial',10,,FONT:regular,CHARSET:ANSI), |
  THOUS
                       HEADER,AT(1000,1000,6250,1000),USE(?Header),FONT('Calibri',12,,,CHARSET:DEFAULT)
                         STRING('ISPIS PRODANIH LIJEKOVA'),AT(1917,385),USE(?STRING1),FONT(,16,,FONT:bold)
                       END
break1                 BREAK(LJK:s_ljk),USE(?BREAK1)
                         HEADER,AT(0,0,6250,750),USE(?GROUPHEADER1),FONT('Calibri',12,,,CHARSET:DEFAULT)
                           BOX,AT(42,42,6156,375),USE(?BOX1),COLOR(COLOR:Black),FILL(00DCF8FFh),LINEWIDTH(1)
                           STRING(@s20),AT(323,125),USE(LJK:Ime),FONT(,,,FONT:bold),RIGHT,COLOR(00DCF8FFh)
                           STRING(@s20),AT(2260,125),USE(LJK:Prezime),FONT(,,,FONT:bold),COLOR(00DCF8FFh)
                           STRING('Datum prodaje'),AT(177,479),USE(?STRING2)
                           STRING('Naziv lijeka'),AT(1917,479,1010,229),USE(?STRING2:2)
                           STRING('Kolièina'),AT(4240,479,531,229),USE(?STRING2:3)
                           STRING('Ukupna cijena'),AT(4833,479,1010,229),USE(?STRING2:4)
                         END
detail1                  DETAIL,AT(0,0,6250,302),USE(?DETAIL1),FONT('Calibri',12,,,CHARSET:DEFAULT)
                           STRING(@D6),AT(323,31),USE(PRD:Datum_prodaje)
                           STRING(@s40),AT(1344,31,2969),USE(LIJ:Ime_lijeka)
                           STRING(@n-14),AT(4469,31,302),USE(PRD:Kolicina),RIGHT(1)
                           STRING(@n-10.2),AT(4833,31),USE(PRD:Iznos_lijeka),RIGHT(12)
                         END
                         FOOTER,AT(0,0,6250,375),USE(?GROUPFOOTER1),FONT('Calibri',12,,,CHARSET:DEFAULT)
                           STRING(@n-10.2),AT(4833,31),USE(PRD:Iznos_lijeka,,?PRD:Iznos_lijeka:2),RIGHT(12),SUM,TALLY(detail1), |
  RESET(break1)
                           STRING('Sveukupna cijena:'),AT(3552,31),USE(?STRING3)
                         END
                       END
                       FOOTER,AT(1000,9688,6250,1000),USE(?Footer),FONT('Calibri',12,,,CHARSET:DEFAULT)
                         STRING(@N3),AT(5552,240),USE(ReportPageNumber)
                         STRING('Datum:'),AT(365,229),USE(?ReportDatePrompt),TRN
                         STRING('<<-- Date Stamp -->'),AT(958,240),USE(?ReportDateStamp),TRN
                       END
                       FORM,AT(1000,1000,6250,9688),USE(?Form)
                       END
                     END
ThisWindow           CLASS(ReportManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
OpenReport             PROCEDURE(),BYTE,PROC,DERIVED
                     END

ThisReport           CLASS(ProcessClass)                   ! Process Manager
TakeRecord             PROCEDURE(),BYTE,PROC,DERIVED
                     END

Previewer            PrintPreviewClass                     ! Print Previewer

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
  GlobalErrors.SetProcedureName('Izvjesce_LJK')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Progress:Thermometer
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  Relate:LJEKARNIK.SetOpenRelated()
  Relate:LJEKARNIK.Open                                    ! File LJEKARNIK used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Open(ProgressWindow)                                ! Open window
  Do DefineListboxStyle
  INIMgr.Fetch('Izvjesce_LJK',ProgressWindow)              ! Restore window settings from non-volatile store
  ThisReport.Init(Process:View, Relate:LJEKARNIK, ?Progress:PctText, Progress:Thermometer)
  ThisReport.AddSortOrder()
  ThisReport.SetFilter('PRD:Rbr<<>0')
  SELF.AddItem(?Progress:Cancel,RequestCancelled)
  SELF.Init(ThisReport,Report,Previewer)
  ?Progress:UserString{PROP:Text} = ''
  Relate:LJEKARNIK.SetQuickScan(1,Propagate:OneMany)
  ProgressWindow{PROP:Timer} = 10                          ! Assign timer interval
  SELF.SkipPreview = False
  Previewer.SetINIManager(INIMgr)
  Previewer.AllowUserZoom = True
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
    INIMgr.Update('Izvjesce_LJK',ProgressWindow)           ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.OpenReport PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.OpenReport()
  IF ReturnValue = Level:Benign
    Report$?ReportPageNumber{PROP:PageNo} = True
  END
  IF ReturnValue = Level:Benign
    SELF.Report $ ?ReportDateStamp{PROP:Text} = FORMAT(TODAY(),@D17)
  END
  RETURN ReturnValue


ThisReport.TakeRecord PROCEDURE

ReturnValue          BYTE,AUTO

SkipDetails BYTE
  CODE
  ReturnValue = PARENT.TakeRecord()
  PRINT(RPT:detail1)
  RETURN ReturnValue

!!! <summary>
!!! Generated from procedure template - Report
!!! </summary>
Izvjesce_LIJ PROCEDURE 

Progress:Thermometer BYTE                                  !
Process:View         VIEW(LIJEK)
                       PROJECT(LIJ:Cijena)
                       PROJECT(LIJ:Ime_lijeka)
                       PROJECT(LIJ:Opis_lijeka)
                       PROJECT(LIJ:Vrsta)
                       PROJECT(LIJ:s_lij)
                       PROJECT(LIJ:s_pro)
                       JOIN(PRO:pk_pro,LIJ:s_pro)
                         PROJECT(PRO:Naziv)
                       END
                     END
ReportPageNumber     LONG,AUTO
ProgressWindow       WINDOW('Ispis lijekova'),AT(,,142,59),FONT('Calibri',12,,,CHARSET:DEFAULT),DOUBLE,CENTER,GRAY, |
  TIMER(1)
                       PROGRESS,AT(15,15,111,12),USE(Progress:Thermometer),RANGE(0,100)
                       STRING(''),AT(0,3,141,10),USE(?Progress:UserString),CENTER
                       STRING(''),AT(0,30,141,10),USE(?Progress:PctText),CENTER
                       BUTTON('Zatvori'),AT(45,42,50,15),USE(?Progress:Cancel)
                     END

Report               REPORT,AT(1000,2000,6250,7688),PRE(RPT),PAPER(PAPER:A4),FONT('Arial',10,,FONT:regular,CHARSET:ANSI), |
  THOUS
                       HEADER,AT(1000,1000,6250,1000),USE(?Header),FONT('Calibri',12,,,CHARSET:DEFAULT)
                         BOX,AT(42,42,6156,687),USE(?BOX1),COLOR(00DCF8FFh),FILL(00DCF8FFh),LINEWIDTH(1)
                         STRING('ISPIS LIJEKOVA'),AT(2448,292),USE(?STRING1),FONT(,16,,FONT:bold),COLOR(00DCF8FFh)
                       END
Detail                 DETAIL,AT(0,0,6250,969),USE(?Detail),FONT('Calibri',12,,,CHARSET:DEFAULT)
                         STRING('Šifra:'),AT(333,42),USE(?STRING2)
                         STRING('Opis:'),AT(333,625,354,229),USE(?STRING2:2)
                         STRING('Cijena:'),AT(2448,333,510,229),USE(?STRING2:3)
                         STRING('Vrsta:'),AT(3802,333,448,229),USE(?STRING2:4)
                         STRING('Proizvodjac: '),AT(333,333,865,229),USE(?STRING2:5)
                         STRING('Ime lijeka:'),AT(2208,42,750,229),USE(?STRING2:6)
                         STRING(@n-14),AT(750,42,562),USE(LIJ:s_lij),RIGHT(1)
                         STRING(@s40),AT(3021,42,3167),USE(LIJ:Ime_lijeka)
                         STRING(@s30),AT(1167,333,1115),USE(PRO:Naziv)
                         STRING(@s20),AT(4312,333),USE(LIJ:Vrsta)
                         STRING(@n-10.2),AT(3021,333,604),USE(LIJ:Cijena),RIGHT(12)
                         STRING(@s255),AT(750,625,5260),USE(LIJ:Opis_lijeka)
                         LINE,AT(62,927,6115,0),USE(?LINE1)
                       END
                       FOOTER,AT(1000,9688,6250,1000),USE(?Footer),FONT('Calibri',12,,,CHARSET:DEFAULT)
                         STRING('Datum:'),AT(333,312),USE(?ReportDatePrompt),TRN
                         STRING('<<-- Date Stamp -->'),AT(896,312),USE(?ReportDateStamp),TRN
                         STRING(@N3),AT(5510,312),USE(ReportPageNumber)
                       END
                       FORM,AT(1000,1000,6250,9688),USE(?Form)
                       END
                     END
ThisWindow           CLASS(ReportManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
OpenReport             PROCEDURE(),BYTE,PROC,DERIVED
                     END

ThisReport           CLASS(ProcessClass)                   ! Process Manager
TakeRecord             PROCEDURE(),BYTE,PROC,DERIVED
                     END

Previewer            PrintPreviewClass                     ! Print Previewer

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
  GlobalErrors.SetProcedureName('Izvjesce_LIJ')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Progress:Thermometer
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  Relate:LIJEK.SetOpenRelated()
  Relate:LIJEK.Open                                        ! File LIJEK used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Open(ProgressWindow)                                ! Open window
  Do DefineListboxStyle
  INIMgr.Fetch('Izvjesce_LIJ',ProgressWindow)              ! Restore window settings from non-volatile store
  ThisReport.Init(Process:View, Relate:LIJEK, ?Progress:PctText, Progress:Thermometer)
  ThisReport.AddSortOrder()
  SELF.AddItem(?Progress:Cancel,RequestCancelled)
  SELF.Init(ThisReport,Report,Previewer)
  ?Progress:UserString{PROP:Text} = ''
  Relate:LIJEK.SetQuickScan(1,Propagate:OneMany)
  ProgressWindow{PROP:Timer} = 10                          ! Assign timer interval
  SELF.SkipPreview = False
  Previewer.SetINIManager(INIMgr)
  Previewer.AllowUserZoom = True
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
    INIMgr.Update('Izvjesce_LIJ',ProgressWindow)           ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.OpenReport PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.OpenReport()
  IF ReturnValue = Level:Benign
    SELF.Report $ ?ReportDateStamp{PROP:Text} = FORMAT(TODAY(),@D17)
  END
  IF ReturnValue = Level:Benign
    Report$?ReportPageNumber{PROP:PageNo} = True
  END
  RETURN ReturnValue


ThisReport.TakeRecord PROCEDURE

ReturnValue          BYTE,AUTO

SkipDetails BYTE
  CODE
  ReturnValue = PARENT.TakeRecord()
  PRINT(RPT:Detail)
  RETURN ReturnValue

!!! <summary>
!!! Generated from procedure template - Report
!!! </summary>
Izvjesce_PRD PROCEDURE 

Progress:Thermometer BYTE                                  !
Process:View         VIEW(PRODAJE)
                       PROJECT(PRD:Datum_prodaje)
                       PROJECT(PRD:Iznos_lijeka)
                       PROJECT(PRD:Kolicina)
                       PROJECT(PRD:Subvencija)
                       PROJECT(PRD:rbr)
                       PROJECT(PRD:s_ljk)
                       PROJECT(PRD:s_lij)
                       PROJECT(PRD:s_kup)
                       JOIN(LJK:pk_ljk,PRD:s_ljk)
                         PROJECT(LJK:Ime)
                         PROJECT(LJK:Prezime)
                       END
                       JOIN(LIJ:pk_lij,PRD:s_lij)
                         PROJECT(LIJ:Cijena)
                         PROJECT(LIJ:Ime_lijeka)
                         PROJECT(LIJ:Vrsta)
                         PROJECT(LIJ:s_pro)
                         JOIN(PRO:pk_pro,LIJ:s_pro)
                         END
                       END
                       JOIN(KUP:pk_kup,PRD:s_kup)
                         PROJECT(KUP:Broj_kartice)
                         PROJECT(KUP:Ime)
                         PROJECT(KUP:Prezime)
                       END
                     END
ProgressWindow       WINDOW('Ispis prodaje'),AT(,,142,59),FONT('Calibri',12,,,CHARSET:DEFAULT),DOUBLE,CENTER,GRAY, |
  TIMER(1)
                       PROGRESS,AT(15,15,111,12),USE(Progress:Thermometer),RANGE(0,100)
                       STRING(''),AT(0,3,141,10),USE(?Progress:UserString),CENTER
                       STRING(''),AT(0,30,141,10),USE(?Progress:PctText),CENTER
                       BUTTON('Zatvori'),AT(45,42,50,15),USE(?Progress:Cancel)
                     END

Report               REPORT,AT(1000,2000,6250,7688),PRE(RPT),PAPER(PAPER:A4),FONT('Arial',10,,FONT:regular,CHARSET:ANSI), |
  THOUS
                       HEADER,AT(1000,1000,6250,1000),USE(?Header),FONT('Calibri',12,,,CHARSET:DEFAULT),COLOR(00F0FAFFh)
                         STRING('ISPIS PRODAJE'),AT(2448,333),USE(?STRING1),FONT(,16,,FONT:bold,CHARSET:ANSI)
                       END
Detail                 DETAIL,AT(0,0,6250,2354),USE(?Detail),FONT('Calibri',12,,,CHARSET:DEFAULT)
                         STRING(@D6),AT(1312,167),USE(PRD:Datum_prodaje)
                         STRING('Datum prodaje:'),AT(198,167),USE(?STRING2)
                         STRING('Lijek'),AT(521,552,1052,229),USE(?STRING2:2),FONT(,,,FONT:regular+FONT:underline)
                         STRING('Ljekarnik'),AT(4479,552,1052,229),USE(?STRING2:3),FONT(,,,FONT:regular+FONT:underline)
                         STRING(@s40),AT(198,844,1875),USE(LIJ:Ime_lijeka)
                         STRING(@s20),AT(198,1135),USE(LIJ:Vrsta)
                         STRING(@n-10.2),AT(198,1427),USE(LIJ:Cijena),RIGHT(12)
                         STRING('Raèun'),AT(2635,552,1052,229),USE(?STRING2:4),FONT(,,,FONT:regular+FONT:underline)
                         STRING(@n-14),AT(3104,844,312),USE(PRD:Kolicina),RIGHT(1)
                         STRING(@n-14),AT(3104,1135,312),USE(PRD:Subvencija),RIGHT(1)
                         STRING('%'),AT(3500,1135,187,229),USE(?STRING2:5)
                         STRING('Kolicina:'),AT(2448,844,583,229),USE(?STRING2:6)
                         STRING(@n-10.2),AT(2458,1427),USE(PRD:Iznos_lijeka),FONT(,,,FONT:bold),RIGHT(12)
                         STRING(@s20),AT(3698,844,1052),USE(LJK:Ime),RIGHT
                         STRING(@s20),AT(4812,844,1208),USE(LJK:Prezime)
                         STRING('Kupac'),AT(4583,1135,1052,229),USE(?STRING2:7),FONT(,,,FONT:regular+FONT:underline)
                         STRING(@P########P),AT(4479,1427),USE(KUP:Broj_kartice)
                         STRING(@s20),AT(3698,1719,1052),USE(KUP:Ime),RIGHT
                         STRING(@s20),AT(4812,1719,1208),USE(KUP:Prezime)
                         STRING('Subvencija:'),AT(2240,1135,802,229),USE(?STRING2:8)
                       END
                       FOOTER,AT(1000,9688,6250,1000),USE(?Footer),FONT('Calibri',12,,,CHARSET:DEFAULT)
                       END
                       FORM,AT(1000,1000,6250,9688),USE(?Form)
                       END
                     END
ThisWindow           CLASS(ReportManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
                     END

ThisReport           CLASS(ProcessClass)                   ! Process Manager
TakeRecord             PROCEDURE(),BYTE,PROC,DERIVED
                     END

ProgressMgr          StepLongClass                         ! Progress Manager
Previewer            PrintPreviewClass                     ! Print Previewer

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
  GlobalErrors.SetProcedureName('Izvjesce_PRD')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Progress:Thermometer
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  Relate:PRODAJE.SetOpenRelated()
  Relate:PRODAJE.Open                                      ! File PRODAJE used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Open(ProgressWindow)                                ! Open window
  Do DefineListboxStyle
  INIMgr.Fetch('Izvjesce_PRD',ProgressWindow)              ! Restore window settings from non-volatile store
  ProgressMgr.Init(ScrollSort:AllowNumeric,)
  ThisReport.Init(Process:View, Relate:PRODAJE, ?Progress:PctText, Progress:Thermometer, ProgressMgr, PRD:s_ljk)
  ThisReport.AddSortOrder(PRD:pk_PRD)
  ThisReport.AddRange(PRD:rbr)
  SELF.AddItem(?Progress:Cancel,RequestCancelled)
  SELF.Init(ThisReport,Report,Previewer)
  ?Progress:UserString{PROP:Text} = ''
  Relate:PRODAJE.SetQuickScan(1,Propagate:OneMany)
  ProgressWindow{PROP:Timer} = 10                          ! Assign timer interval
  SELF.SkipPreview = False
  Previewer.SetINIManager(INIMgr)
  Previewer.AllowUserZoom = True
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:PRODAJE.Close
  END
  IF SELF.Opened
    INIMgr.Update('Izvjesce_PRD',ProgressWindow)           ! Save window data to non-volatile store
  END
  ProgressMgr.Kill()
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisReport.TakeRecord PROCEDURE

ReturnValue          BYTE,AUTO

SkipDetails BYTE
  CODE
  ReturnValue = PARENT.TakeRecord()
  PRINT(RPT:Detail)
  RETURN ReturnValue

