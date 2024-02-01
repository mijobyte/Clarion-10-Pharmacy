  MEMBER('ljekarna.clw')

  PRAGMA('define(init_priority=>3)')

  MAP
    MODULE('ljekarna_BC0.CLW')
ljekarna_BC0:DctInit             PROCEDURE
ljekarna_BC0:DctKill             PROCEDURE
ljekarna_BC0:FilesInit           PROCEDURE
    END
  END

DctInit PROCEDURE
  CODE
  ljekarna_BC0:DctInit
  ljekarna_BC0:FilesInit


DctKill PROCEDURE
  CODE
  ljekarna_BC0:DctKill

