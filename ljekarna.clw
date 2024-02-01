   PROGRAM



   INCLUDE('ABERROR.INC'),ONCE
   INCLUDE('ABFILE.INC'),ONCE
   INCLUDE('ABUTIL.INC'),ONCE
   INCLUDE('ERRORS.CLW'),ONCE
   INCLUDE('KEYCODES.CLW'),ONCE
   INCLUDE('ABFUZZY.INC'),ONCE

   MAP
     MODULE('LJEKARNA_BC.CLW')
DctInit     PROCEDURE                                      ! Initializes the dictionary definition module
DctKill     PROCEDURE                                      ! Kills the dictionary definition module
     END
!--- Application Global and Exported Procedure Definitions --------------------------------------------
     MODULE('LJEKARNA001.CLW')
Glavni_izbornik        PROCEDURE   !
     END
   END

SilentRunning        BYTE(0)                               ! Set true when application is running in 'silent mode'

!region File Declaration
PROIZVODJAC          FILE,DRIVER('TOPSPEED'),NAME('PROIZVODJAC'),PRE(PRO),CREATE,BINDABLE,THREAD !                    
pk_pro                   KEY(PRO:s_pro),NAME('Sifra proizvodjaca'),NOCASE,PRIMARY !                    
Record                   RECORD,PRE()
s_pro                       LONG                           !Sifra proizvodjaca  
Naziv                       STRING(30)                     !Naziv proizvodjaca  
Kontakt                     STRING(20)                     !Kontakt proizvodjaca
                         END
                     END                       

LIJEK                FILE,DRIVER('TOPSPEED'),NAME('LIJEK'),PRE(LIJ),CREATE,BINDABLE,THREAD !                    
pk_lij                   KEY(LIJ:s_lij),NAME('Sifra lijeka'),NOCASE,PRIMARY !                    
fk_pro                   KEY(LIJ:s_pro),DUP,NAME('Sifra proizvodjaca'),NOCASE !                    
Record                   RECORD,PRE()
s_lij                       LONG                           !Sifra lijeka        
Ime_lijeka                  STRING(40)                     !Ime lijeka          
Vrsta                       STRING(20)                     !Vrsta lijeka        
Cijena                      DECIMAL(7,2)                   !Cijena lijeka       
Opis_lijeka                 STRING(9999)                   !Opis lijeka         
s_pro                       LONG                           !Sifra proizvodjaca  
                         END
                     END                       

KUPAC                FILE,DRIVER('TOPSPEED'),NAME('KUPAC'),PRE(KUP),CREATE,BINDABLE,THREAD !                    
pk_kup                   KEY(KUP:s_kup),NAME('Sifra kupca'),NOCASE,PRIMARY !                    
Record                   RECORD,PRE()
s_kup                       LONG                           !Sifra kupca         
Broj_kartice                STRING(20)                     !Broj kartice dopunskog
Ime                         STRING(20)                     !Ime kupca           
Prezime                     STRING(20)                     !Prezime kupca       
                         END
                     END                       

LJEKARNIK            FILE,DRIVER('TOPSPEED'),NAME('LJEKARNIK'),PRE(LJK),CREATE,BINDABLE,THREAD !                    
pk_ljk                   KEY(LJK:s_ljk),NAME('Sifra ljekarnika'),NOCASE,PRIMARY !                    
sk_prezime               KEY(LJK:Prezime),DUP,NAME('Prezime ljekarnika'),NOCASE !                    
Record                   RECORD,PRE()
s_ljk                       LONG                           !Sifra ljekarnika    
Ime                         STRING(20)                     !Ime ljekarnika      
Prezime                     STRING(20)                     !Prezime ljekarnika  
Datum                       DATE                           !Datum rodenja       
Adresa                      STRING(40)                     !Adresa prebivalista 
                         END
                     END                       

PRODAJE              FILE,DRIVER('TOPSPEED'),NAME('PRODAJE'),PRE(PRD),CREATE,BINDABLE,THREAD !                    
pk_PRD                   KEY(PRD:s_ljk,PRD:rbr),NAME('Sifra ljekarnika i redni broj prodaje'),NOCASE,PRIMARY !                    
fk_LIJ                   KEY(PRD:s_lij),DUP,NAME('Sifra lijeka'),NOCASE !                    
fk_KUP                   KEY(PRD:s_kup),DUP,NAME('Sifra kupca'),NOCASE !                    
Record                   RECORD,PRE()
s_ljk                       LONG                           !Sifra ljekarnika    
rbr                         LONG                           !Redni broj          
Datum_prodaje               DATE                           !Datum prodaje lijeka
s_lij                       LONG                           !Sifra lijeka        
Jedinicna_cijena            DECIMAL(7,2)                   !Jedinièna cijena lijeka
Na_recept                   BYTE                           !Je li lijek na recept?
Subvencija                  LONG                           !Postotak subvencije na cijenu lijeka
Kolicina                    LONG                           !Kolièina            
Iznos_lijeka                DECIMAL(7,2)                   !Iznos lijeka        
s_kup                       LONG                           !Sifra kupca         
                         END
                     END                       

!endregion

Access:PROIZVODJAC   &FileManager,THREAD                   ! FileManager for PROIZVODJAC
Relate:PROIZVODJAC   &RelationManager,THREAD               ! RelationManager for PROIZVODJAC
Access:LIJEK         &FileManager,THREAD                   ! FileManager for LIJEK
Relate:LIJEK         &RelationManager,THREAD               ! RelationManager for LIJEK
Access:KUPAC         &FileManager,THREAD                   ! FileManager for KUPAC
Relate:KUPAC         &RelationManager,THREAD               ! RelationManager for KUPAC
Access:LJEKARNIK     &FileManager,THREAD                   ! FileManager for LJEKARNIK
Relate:LJEKARNIK     &RelationManager,THREAD               ! RelationManager for LJEKARNIK
Access:PRODAJE       &FileManager,THREAD                   ! FileManager for PRODAJE
Relate:PRODAJE       &RelationManager,THREAD               ! RelationManager for PRODAJE

FuzzyMatcher         FuzzyClass                            ! Global fuzzy matcher
GlobalErrorStatus    ErrorStatusClass,THREAD
GlobalErrors         ErrorClass                            ! Global error manager
INIMgr               INIClass                              ! Global non-volatile storage manager
GlobalRequest        BYTE(0),THREAD                        ! Set when a browse calls a form, to let it know action to perform
GlobalResponse       BYTE(0),THREAD                        ! Set to the response from the form
VCRRequest           LONG(0),THREAD                        ! Set to the request from the VCR buttons

Dictionary           CLASS,THREAD
Construct              PROCEDURE
Destruct               PROCEDURE
                     END


  CODE
  GlobalErrors.Init(GlobalErrorStatus)
  FuzzyMatcher.Init                                        ! Initilaize the browse 'fuzzy matcher'
  FuzzyMatcher.SetOption(MatchOption:NoCase, 1)            ! Configure case matching
  FuzzyMatcher.SetOption(MatchOption:WordOnly, 0)          ! Configure 'word only' matching
  INIMgr.Init('.\ljekarna.INI', NVD_INI)                   ! Configure INIManager to use INI file
  DctInit
  Glavni_izbornik
  INIMgr.Update
  INIMgr.Kill                                              ! Destroy INI manager
  FuzzyMatcher.Kill                                        ! Destroy fuzzy matcher


Dictionary.Construct PROCEDURE

  CODE
  IF THREAD()<>1
     DctInit()
  END


Dictionary.Destruct PROCEDURE

  CODE
  DctKill()

