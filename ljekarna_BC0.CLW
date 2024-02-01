  MEMBER('ljekarna.clw')

  INCLUDE('ABFILE.INC'),ONCE

  MAP
ljekarna_BC0:DctInit    PROCEDURE
ljekarna_BC0:DctKill    PROCEDURE
ljekarna_BC0:FilesInit  PROCEDURE
  END

Hide:Access:PROIZVODJAC CLASS(FileManager),TYPE            ! FileManager for PROIZVODJAC
Init                   PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED
                     END


Hide:Relate:PROIZVODJAC CLASS(RelationManager),TYPE        ! RelationManager for PROIZVODJAC
Init                   PROCEDURE
DeferedAddRelations    PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
                     END

Hide:Access:LIJEK    CLASS(FileManager),TYPE               ! FileManager for LIJEK
Init                   PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED
ValidateFieldServer    PROCEDURE(UNSIGNED Id,BYTE HandleErrors),BYTE,PROC,DERIVED
                     END


Hide:Relate:LIJEK    CLASS(RelationManager),TYPE           ! RelationManager for LIJEK
Init                   PROCEDURE
DeferedAddRelations    PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
                     END

Hide:Access:KUPAC    CLASS(FileManager),TYPE               ! FileManager for KUPAC
Init                   PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED
                     END


Hide:Relate:KUPAC    CLASS(RelationManager),TYPE           ! RelationManager for KUPAC
Init                   PROCEDURE
DeferedAddRelations    PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
                     END

Hide:Access:LJEKARNIK CLASS(FileManager),TYPE              ! FileManager for LJEKARNIK
Init                   PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED
                     END


Hide:Relate:LJEKARNIK CLASS(RelationManager),TYPE          ! RelationManager for LJEKARNIK
Init                   PROCEDURE
DeferedAddRelations    PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
                     END

Hide:Access:PRODAJE  CLASS(FileManager),TYPE               ! FileManager for PRODAJE
Init                   PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED
ValidateFieldServer    PROCEDURE(UNSIGNED Id,BYTE HandleErrors),BYTE,PROC,DERIVED
                     END


Hide:Relate:PRODAJE  CLASS(RelationManager),TYPE           ! RelationManager for PRODAJE
Init                   PROCEDURE
DeferedAddRelations    PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
                     END


_Hide:Access:PROIZVODJAC &Hide:Access:PROIZVODJAC,AUTO,THREAD
_Hide:Relate:PROIZVODJAC &Hide:Relate:PROIZVODJAC,AUTO,THREAD
_Hide:Access:LIJEK   &Hide:Access:LIJEK,AUTO,THREAD
_Hide:Relate:LIJEK   &Hide:Relate:LIJEK,AUTO,THREAD
_Hide:Access:KUPAC   &Hide:Access:KUPAC,AUTO,THREAD
_Hide:Relate:KUPAC   &Hide:Relate:KUPAC,AUTO,THREAD
_Hide:Access:LJEKARNIK &Hide:Access:LJEKARNIK,AUTO,THREAD
_Hide:Relate:LJEKARNIK &Hide:Relate:LJEKARNIK,AUTO,THREAD
_Hide:Access:PRODAJE &Hide:Access:PRODAJE,AUTO,THREAD
_Hide:Relate:PRODAJE &Hide:Relate:PRODAJE,AUTO,THREAD


ljekarna_BC0:DctInit PROCEDURE
  CODE
  _Hide:Access:PROIZVODJAC &= NEW(Hide:Access:PROIZVODJAC)
  _Hide:Relate:PROIZVODJAC &= NEW(Hide:Relate:PROIZVODJAC)
  _Hide:Access:LIJEK &= NEW(Hide:Access:LIJEK)
  _Hide:Relate:LIJEK &= NEW(Hide:Relate:LIJEK)
  _Hide:Access:KUPAC &= NEW(Hide:Access:KUPAC)
  _Hide:Relate:KUPAC &= NEW(Hide:Relate:KUPAC)
  _Hide:Access:LJEKARNIK &= NEW(Hide:Access:LJEKARNIK)
  _Hide:Relate:LJEKARNIK &= NEW(Hide:Relate:LJEKARNIK)
  _Hide:Access:PRODAJE &= NEW(Hide:Access:PRODAJE)
  _Hide:Relate:PRODAJE &= NEW(Hide:Relate:PRODAJE)
  Relate:PROIZVODJAC &= _Hide:Relate:PROIZVODJAC
  Relate:LIJEK &= _Hide:Relate:LIJEK
  Relate:KUPAC &= _Hide:Relate:KUPAC
  Relate:LJEKARNIK &= _Hide:Relate:LJEKARNIK
  Relate:PRODAJE &= _Hide:Relate:PRODAJE


ljekarna_BC0:FilesInit PROCEDURE
  CODE
  _Hide:Relate:PROIZVODJAC.Init
  _Hide:Relate:LIJEK.Init
  _Hide:Relate:KUPAC.Init
  _Hide:Relate:LJEKARNIK.Init
  _Hide:Relate:PRODAJE.Init


ljekarna_BC0:DctKill PROCEDURE
  CODE
  _Hide:Relate:PROIZVODJAC.Kill
  DISPOSE(_Hide:Relate:PROIZVODJAC)
  _Hide:Relate:LIJEK.Kill
  DISPOSE(_Hide:Relate:LIJEK)
  _Hide:Relate:KUPAC.Kill
  DISPOSE(_Hide:Relate:KUPAC)
  _Hide:Relate:LJEKARNIK.Kill
  DISPOSE(_Hide:Relate:LJEKARNIK)
  _Hide:Relate:PRODAJE.Kill
  DISPOSE(_Hide:Relate:PRODAJE)


Hide:Relate:PROIZVODJAC.Init PROCEDURE
  CODE
  _Hide:Access:PROIZVODJAC.Init
  SELF.Init(Access:PROIZVODJAC,1)


Hide:Access:PROIZVODJAC.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= PRO:Record
  SELF.FileNameValue = 'PROIZVODJAC'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= PROIZVODJAC
  PARENT.Init
  Access:PROIZVODJAC &= SELF


Hide:Access:PROIZVODJAC.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:PROIZVODJAC &= NULL                               ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:PROIZVODJAC.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(PROIZVODJAC,GlobalErrors)
    SELF.Create = 1
    SELF.LockRecover = 10
    SELF.AddKey(PRO:pk_pro,'PRO:pk_pro',1)
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Relate:PROIZVODJAC.DeferedAddRelations PROCEDURE

  CODE
  DO AddRelations_1
  
  PARENT.DeferedAddRelations

AddRelations_1 ROUTINE
  SELF.AddRelation(Relate:LIJEK,RI:CASCADE,RI:RESTRICT,LIJ:fk_pro)
  SELF.AddRelationLink(PRO:s_pro,LIJ:s_pro)


Hide:Relate:PROIZVODJAC.Kill PROCEDURE

  CODE
  _Hide:Access:PROIZVODJAC.Kill                            ! Kill the file manager
  PARENT.Kill
  Relate:PROIZVODJAC &= NULL                               ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:PROIZVODJAC)                        ! destroy the file manager


Hide:Relate:LIJEK.Init PROCEDURE
  CODE
  _Hide:Access:LIJEK.Init
  SELF.Init(Access:LIJEK,1)


Hide:Access:LIJEK.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= LIJ:Record
  SELF.FileNameValue = 'LIJEK'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= LIJEK
  PARENT.Init
  Access:LIJEK &= SELF


Hide:Access:LIJEK.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:LIJEK &= NULL                                     ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:LIJEK.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(LIJEK,GlobalErrors)
    SELF.Create = 1
    SELF.LockRecover = 10
    SELF.AddKey(LIJ:pk_lij,'LIJ:pk_lij',1)
    SELF.AddKey(LIJ:fk_pro,'LIJ:fk_pro',0)
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Access:LIJEK.ValidateFieldServer PROCEDURE(UNSIGNED Id,BYTE HandleErrors)

ReturnValue          BYTE,AUTO

Save:PROIZVODJAC6  USHORT,AUTO
  CODE
  ReturnValue = PARENT.ValidateFieldServer(Id,HandleErrors)
  CASE Id
  OF 3
    GlobalErrors.SetField('Vrsta lijeka')
    IF INSTRING(']' & CLIP(LIJ:Vrsta) & '[', ']Tableta[]Tableta u kapsuli[]Sumeca tableta[]Krema[]Kapi[]Sirup[', 1, 1) = 0
      ReturnValue = Level:Notify
    END
    IF ReturnValue <> Level:Benign
      IF HandleErrors
        ReturnValue = GlobalErrors.ThrowMessage(Msg:FieldNotInList,'''Tableta'',''Tableta u kapsuli'',''Sumeca tableta'',''Krema'',''Kapi'',''Sirup''')
      END
    END
  OF 6
    GlobalErrors.SetField('Sifra proizvodjaca')
    Save:PROIZVODJAC6 = Access:PROIZVODJAC.SaveFile()
    PRO:s_pro = LIJ:s_pro
    ReturnValue = Access:PROIZVODJAC.TryFetch(PRO:pk_pro)
    IF ReturnValue <> Level:Benign
      IF HandleErrors                                      ! Display message if handling errors
        ReturnValue = GlobalErrors.ThrowMessage(Msg:FieldNotInFile,'PROIZVODJAC')
      END
    END
    Access:PROIZVODJAC.RestoreFile(Save:PROIZVODJAC6)
  END
  RETURN ReturnValue


Hide:Relate:LIJEK.DeferedAddRelations PROCEDURE

  CODE
  DO AddRelations_1
  
  PARENT.DeferedAddRelations

AddRelations_1 ROUTINE
  SELF.AddRelation(Relate:PROIZVODJAC)

  SELF.AddRelation(Relate:PRODAJE,RI:CASCADE,RI:RESTRICT,PRD:fk_LIJ)
  SELF.AddRelationLink(LIJ:s_lij,PRD:s_lij)


Hide:Relate:LIJEK.Kill PROCEDURE

  CODE
  _Hide:Access:LIJEK.Kill                                  ! Kill the file manager
  PARENT.Kill
  Relate:LIJEK &= NULL                                     ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:LIJEK)                              ! destroy the file manager


Hide:Relate:KUPAC.Init PROCEDURE
  CODE
  _Hide:Access:KUPAC.Init
  SELF.Init(Access:KUPAC,1)


Hide:Access:KUPAC.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= KUP:Record
  SELF.FileNameValue = 'KUPAC'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= KUPAC
  PARENT.Init
  Access:KUPAC &= SELF


Hide:Access:KUPAC.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:KUPAC &= NULL                                     ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:KUPAC.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(KUPAC,GlobalErrors)
    SELF.Create = 1
    SELF.LockRecover = 10
    SELF.AddKey(KUP:pk_kup,'KUP:pk_kup',1)
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Relate:KUPAC.DeferedAddRelations PROCEDURE

  CODE
  DO AddRelations_1
  
  PARENT.DeferedAddRelations

AddRelations_1 ROUTINE
  SELF.AddRelation(Relate:PRODAJE,RI:CASCADE,RI:RESTRICT,PRD:fk_KUP)
  SELF.AddRelationLink(KUP:s_kup,PRD:s_kup)


Hide:Relate:KUPAC.Kill PROCEDURE

  CODE
  _Hide:Access:KUPAC.Kill                                  ! Kill the file manager
  PARENT.Kill
  Relate:KUPAC &= NULL                                     ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:KUPAC)                              ! destroy the file manager


Hide:Relate:LJEKARNIK.Init PROCEDURE
  CODE
  _Hide:Access:LJEKARNIK.Init
  SELF.Init(Access:LJEKARNIK,1)


Hide:Access:LJEKARNIK.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= LJK:Record
  SELF.FileNameValue = 'LJEKARNIK'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= LJEKARNIK
  PARENT.Init
  Access:LJEKARNIK &= SELF


Hide:Access:LJEKARNIK.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:LJEKARNIK &= NULL                                 ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:LJEKARNIK.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(LJEKARNIK,GlobalErrors)
    SELF.Create = 1
    SELF.LockRecover = 10
    SELF.AddKey(LJK:pk_ljk,'LJK:pk_ljk',1)
    SELF.AddKey(LJK:sk_prezime,'LJK:sk_prezime',0)
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Relate:LJEKARNIK.DeferedAddRelations PROCEDURE

  CODE
  DO AddRelations_1
  
  PARENT.DeferedAddRelations

AddRelations_1 ROUTINE
  SELF.AddRelation(Relate:PRODAJE,RI:CASCADE,RI:CASCADE,PRD:pk_PRD)
  SELF.AddRelationLink(LJK:s_ljk,PRD:s_ljk)


Hide:Relate:LJEKARNIK.Kill PROCEDURE

  CODE
  _Hide:Access:LJEKARNIK.Kill                              ! Kill the file manager
  PARENT.Kill
  Relate:LJEKARNIK &= NULL                                 ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:LJEKARNIK)                          ! destroy the file manager


Hide:Relate:PRODAJE.Init PROCEDURE
  CODE
  _Hide:Access:PRODAJE.Init
  SELF.Init(Access:PRODAJE,1)


Hide:Access:PRODAJE.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= PRD:Record
  SELF.FileNameValue = 'PRODAJE'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= PRODAJE
  PARENT.Init
  Access:PRODAJE &= SELF


Hide:Access:PRODAJE.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:PRODAJE &= NULL                                   ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:PRODAJE.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(PRODAJE,GlobalErrors)
    SELF.Create = 1
    SELF.LockRecover = 10
    SELF.AddKey(PRD:pk_PRD,'PRD:pk_PRD',2)
    SELF.AddKey(PRD:fk_LIJ,'PRD:fk_LIJ',0)
    SELF.AddKey(PRD:fk_KUP,'PRD:fk_KUP',0)
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Access:PRODAJE.ValidateFieldServer PROCEDURE(UNSIGNED Id,BYTE HandleErrors)

ReturnValue          BYTE,AUTO

Save:LIJEK4        USHORT,AUTO
  CODE
  ReturnValue = PARENT.ValidateFieldServer(Id,HandleErrors)
  CASE Id
  OF 4
    GlobalErrors.SetField('Sifra lijeka')
    Save:LIJEK4 = Access:LIJEK.SaveFile()
    LIJ:s_lij = PRD:s_lij
    ReturnValue = Access:LIJEK.TryFetch(LIJ:pk_lij)
    IF ReturnValue <> Level:Benign
      IF HandleErrors                                      ! Display message if handling errors
        ReturnValue = GlobalErrors.ThrowMessage(Msg:FieldNotInFile,'LIJEK')
      END
    END
    Access:LIJEK.RestoreFile(Save:LIJEK4)
  END
  RETURN ReturnValue


Hide:Relate:PRODAJE.DeferedAddRelations PROCEDURE

  CODE
  DO AddRelations_1
  
  PARENT.DeferedAddRelations

AddRelations_1 ROUTINE
  SELF.AddRelation(Relate:LJEKARNIK)

  SELF.AddRelation(Relate:LIJEK)

  SELF.AddRelation(Relate:KUPAC)


Hide:Relate:PRODAJE.Kill PROCEDURE

  CODE
  _Hide:Access:PRODAJE.Kill                                ! Kill the file manager
  PARENT.Kill
  Relate:PRODAJE &= NULL                                   ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:PRODAJE)                            ! destroy the file manager

