      ******************************************************************
      *                     IDENTIFICATION DIVISION                    *
      ******************************************************************
      * A12K
       IDENTIFICATION DIVISION.
       PROGRAM-ID. StockCon.
       AUTHOR. Amanda.
       INSTALLATION. WorkShop.
       DATE-WRITTEN. May 18, 1996.
       DATE-COMPILED. May 18, 1996.
       SECURITY. For use by workshop only.

      ******************************************************************
      *                     ENVIRONMENT DIVISION                       *
      ******************************************************************

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. COMPAC-CONTURA-4-25CX.
       OBJECT-COMPUTER. COMPAC-CONTURA-4-25CX.

      ******************************************************************
      *                      INPUT-OUTPUT SECTION                      *
      ******************************************************************

       INPUT-OUTPUT SECTION.

       FILE-CONTROL.

           SELECT ToolStock
           ASSIGN TO DISK
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS ToolStockKey
               FILE STATUS IS ToolStockStatus.

           SELECT HireTransactions
           ASSIGN TO DISK
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS HireTransactionsKey
               FILE STATUS IS HireTransactionsStatus.

           SELECT SalesTransactions
           ASSIGN TO DISK
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS SalesTransactionsKey
               FILE STATUS IS SalesTransactionsStatus.

      ******************************************************************
      *                         DATA DIVISION                          *
      ******************************************************************

       DATA DIVISION.

       FILE SECTION.

       FD ToolStock
          VALUE OF FILE-ID IS "TOOLSTOC.DAT".

       01 ToolStockRecord.
          05 ToolStockKey.
             10 ToolStockStocknum PIC 9(3).
          05 ToolStockCodesell PIC X(5).
          05 ToolStockCodehire PIC X(5).
          05 ToolStockLevelhire PIC 9.
          05 ToolStockLevelsell PIC 9(3).

       FD HireTransactions
          VALUE OF FILE-ID IS "HIRETRAN.DAT".

          01 HireTransactionsRecord.
             05 HireTransactionsKey.
                10 HTCustNum PIC X(5).
             05 HTCodeHire.
                10 HTType PIC A.
                10 HTSerial PIC 9(3).
                10 HTSorh PIC A.
             05 HTQuantity PIC 9(2).
             05 HTUnitprice PIC 9(5)V9(2).
             05 HTTaxrate PIC 9(3).
             05 HTNumhire PIC 9(3).
             05 HTChgday PIC 9(6).
             05 HTTotal PIC 9(9).

       FD SalesTransactions
          VALUE OF FILE-ID IS "SALESTRA.DAT".

       01 SalesTransactionsRecord.
          05 SalesTransactionsKey.
             10 STInvNum PIC 9(5).
          05 STCodesell.
             10 STType PIC A.
             10 STSerial PIC 9(3).
             10 STSorh PIC A.
          05 STQuantity PIC 9(2).
          05 STUnitPrice PIC 9(5)V9(2).
          05 STTaxRate PIC 9(3).
          05 STTotal PIC 9(9).

      ******************************************************************
      *                    WORKING STORAGE SECTION                     *
      ******************************************************************

       WORKING-STORAGE SECTION.

      ******************************************************************
      *                       General Constants                        *
      ******************************************************************

       78  ItIsFalse                             VALUE 0               .
       78  ItIsTrue                              VALUE 1               .

      ******************************************************************
      *             File Input Output Control Constants                *
      ******************************************************************

       78  InputOutputIsSuccessful                           VALUE "00".

      ******************************************************************
      *                  Flow of Control Constants                     +
      ******************************************************************

       78  StockFileWillBeMaintained                         VALUE    1.
       78  HiredToolsFileWillBeMaintained                    VALUE    2.
       78  SoldToolsFileWillBeMaintained                     VALUE    3.
       78  ProgramWillBeQuit                                 VALUE    4.
       78  StockDataWillBeAdded                              VALUE    1.
       78  StockDataWillBeUpdated                            VALUE    2.
       78  StockDataWillBeDeleted                            VALUE    3.
       78  StockDataWillBeInquired                           VALUE    4.
       78  StockMenuWillBeQuit                               VALUE    5.

      ******************************************************************
      *                  Flow of Control Switches                      *
      ******************************************************************

       77  FatalIOErrorHasOccured                PIC 9(001)            .
       77  MainProcessIsOver                     PIC 9(001)            .
       77  StockFileMaintenanceIsOver            PIC 9(001)            .

      ******************************************************************
      *                       General Variables                        *
      ******************************************************************

       77  ToolStockStatus                       PIC X(002)            .
       77  HireTransactionsStatus                PIC X(002)            .
       77  SalesTransactionsStatus               PIC X(002)            .
       77  ResponseOfUser                        PIC 9(001)            .

       01 WToolStockRecord.
          05 WToolStockKey.
             10 WToolStockStocknum PIC 9(3).
          05 WToolStockCodesell PIC X(5).
          05 WToolStockCodehire PIC X(5).
          05 WToolStockLevelhire PIC 9.
          05 WToolStockLevelsell PIC 9(3).

       01 WHireTransactionsRecord.
          05 WHireTransactionsKey.
             10 WHTCustNum PIC X(5).
          05 HTCodeHire.
             10 WHTType PIC A.
             10 WHTSerial PIC 9(3).
             10 WHTSorh PIC A.
          05 WHTQuantity PIC 9(2).
          05 WHTUnitprice PIC ZZZZ9.99.
          05 WHTTaxrate PIC ZZ9.
          05 WHTNumhire PIC 9(3).
          05 WHTChgday PIC 9(6).
          05 WHTTotal PIC 9(9).

       01 WSalesTransactionsRecord.
          05 WSalesTransactionsKey.
             10 WSTInvNum PIC 9(5).
          05 WSTCodesell.
             10 WSTType PIC A.
             10 WSTSerial PIC 9(3).
             10 WSTSorh PIC A.
          05 WSTQuantity PIC 9(2).
          05 WSTUnitPrice PIC ZZZZ9.99.
          05 WSTTaxRate PIC ZZ9.
          05 WSTTotal PIC 9(9).

      ******************************************************************
      *                      PROCEDURE DIVISION                        *
      ******************************************************************
 
       PROCEDURE DIVISION.

      ******************************************************************
      *                        DECLARATIVES                            *
      ******************************************************************

       DECLARATIVES.

       INPUT-OUTPUT-ERROR SECTION.
           USE AFTER STANDARD ERROR PROCEDURE ON I-O.
       CheckFatalErrors.
           Move ItIsTrue to FatalIOErrorHasOccured.
           Perform A113-Terminate-Program.

       END DECLARATIVES.

      ******************************************************************
      *                         Main Procedure                         *
      ******************************************************************

       A000-ProgramStockCon.
           Perform A111-Start-Program.
           Perform A112-DoMainProcess.
           Perform A113-Terminate-Program.

      ******************************************************************
      *                         Start Program                          *
      ******************************************************************

       A111-Start-Program.
           Move ItIsFalse to FatalIOErrorHasOccured.
           Perform A11Q-CheckIfFilesExists.
           Perform A114-OpenToolStock.
           Perform A115-OpenHireTransactions.
           Perform A116-OpenSalesTransactions.

      ******************************************************************
      *                    Check if files exist                        *
      ******************************************************************

       A11Q-CheckIfFilesExists.
           Open Input ToolStock.
           If ToolStockStatus = InputOutputIsSuccessful
               Perform A11J-CloseToolStockFile
           Else
               Display "Files have not yet been created! "
               Display "1) Create the files 2) Quit the program"
               Accept ResponseOfUser
               Perform A11R-ExecuteSelectedFunction
           End-if.

      ******************************************************************
      *                         Close ToolStock                        *
      ******************************************************************

       A11J-CloseToolStockFile.
           Close ToolStock.
           If ToolStockStatus not = InputOutputIsSuccessful
               Perform A11K-HandleFatalError
           End-If.

      ******************************************************************
      *                        Handle Fatal Error                      *
      ******************************************************************

       A11K-HandleFatalError.
           Display "Fatal error in A11K ".
           Display "SalesTransactionsStatus = " SalesTransactionsStatus.
           Stop Run.

      ******************************************************************
      *                  Execute Selected Function                     *
      ******************************************************************

       A11R-ExecuteSelectedFunction.
           Evaluate True
               When ResponseOfUser = 1
                   Perform A11S-CreateFiles
               When ResponseOfUser = 2
                   Perform A11T-ExitProgram
           End-Evaluate.

      ******************************************************************
      *                          Create Files                          *
      ******************************************************************

       A11S-CreateFiles.
           Perform A11U-CreateToolStock.
           Perform A11W-CreateHireTransactions.
           Perform A11X-CreateSalesTransactions.

      ******************************************************************
      *                       Create ToolStock                         *
      ******************************************************************

       A11U-CreateToolStock.
           Open Output ToolStock.
           If ToolStockStatus = InputOutputIsSuccessful
               Perform A11J-CloseToolStockFile
           Else
               Perform A11V-HandleFatalError
           End-If.

      ******************************************************************
      *                        Handle Fatal Error                      *
      ******************************************************************

       A11V-HandleFatalError.
           Display "Fatal error in A11V ".
           Display "ToolStockStatus = " ToolStockStatus.
           Stop Run.

      ******************************************************************
      *                    Create HireTransactions                     *
      ******************************************************************

       A11W-CreateHireTransactions.
           Open Output HireTransactions.
           If HireTransactionsStatus = InputOutputIsSuccessful
               Perform A11L-CloseHiredToolsFile
           Else
               Perform A11Y-HandleFatalError
           End-If.

      ******************************************************************
      *                      Close HiredToolsFile                      *
      ******************************************************************

       A11L-CloseHiredToolsFile.
           Close HireTransactions.
           If HireTransactionsStatus not = InputOutputIsSuccessful
               Perform A11M-HandleFatalError
           End-If.

      ******************************************************************
      *                        Handle Fatal Error                      *
      ******************************************************************

       A11M-HandleFatalError.
           Display "Fatal error in A11M ".
           Display "HireTransactionsStatus = " HireTransactionsStatus.
           Stop Run.

      ******************************************************************
      *                        Handle Fatal Error                      *
      ******************************************************************

       A11Y-HandleFatalError.
           Display "Fatal error in A11Y ".
           Display "HireTransactionsStatus = " HireTransactionsStatus.
           Stop Run.

      ******************************************************************
      *                   Create SalesTransactions                     *
      ******************************************************************

       A11X-CreateSalesTransactions.
           Open Output SalesTransactions.
           if SalesTransactionsStatus = InputOutputIsSuccessful
               Perform A11N-CloseSoldToolsFile
           Else
               Perform A11Z-HandleFatalError
           end-if.

      ******************************************************************
      *                    Close SalesTransactions                     *
      ******************************************************************

       A11N-CloseSoldToolsFile.
           Close SalesTransactions.
           if SalesTransactionsStatus not = InputOutputIsSuccessful
               Perform A11O-HandleFatalError
           end-if.

      ******************************************************************
      *                        Handle Fatal Error                      *
      ******************************************************************

       A11O-HandleFatalError.
           Display "Fatal error in A11O ".
           Display "SalesTransactionsStatus = " SalesTransactionsStatus.
           Stop Run.

      ******************************************************************
      *                        Handle Fatal Error                      *
      ******************************************************************

       A11Z-HandleFatalError.
           Display "Fatal error in A11Z ".
           Display "SalesTransactionsStatus = " SalesTransactionsStatus.
           Stop Run.

      ******************************************************************
      *                          Exit Program                          *
      ******************************************************************

       A11T-ExitProgram.
           Display "Please strike Enter to quit".
           STOP " ".
           Stop Run.

      ******************************************************************
      *                        Open ToolStock                          *
      ******************************************************************

       A114-OpenToolStock.
           Open i-o ToolStock.
           If ToolStockStatus not = InputOutputIsSuccessful
               Perform A117-HandleFatalError
           End-If.

      ******************************************************************
      *                        Handle Fatal Error                      *
      ******************************************************************

       A117-HandleFatalError.
           Display "Fatal error in A117 ".
           Display "ToolStockStatus = " ToolStockStatus.
           Stop Run.

      ******************************************************************
      *                    OpenHireTransactions                        *
      ******************************************************************

       A115-OpenHireTransactions.
           Open i-o HireTransactions.
           If HireTransactionsStatus not = InputOutputIsSuccessful
               Perform A118-HandleFatalError
           End-If.

      ******************************************************************
      *                        Handle Fatal Error                      *
      ******************************************************************

       A118-HandleFatalError.
           Display "Fatal error in A118 ".
           Display "HireTransactionsStatus = " HireTransactionsStatus.
           Stop Run.

      ******************************************************************
      *                    OpenSalesTransactions                       *
      ******************************************************************

       A116-OpenSalesTransactions.
           Open i-o SalesTransactions.
           if SalesTransactionsStatus not = InputOutputIsSuccessful
               Perform A119-HandleFatalError
           end-if.

      ******************************************************************
      *                        Handle Fatal Error                      *
      ******************************************************************

       A119-HandleFatalError.
           Display "Fatal error in A119 ".
           Display "SalesTransactionsStatus = " SalesTransactionsStatus.
           Stop Run.

      ******************************************************************
      *                         Do Main Process                        *
      ******************************************************************

       A112-DoMainProcess.
           Perform A11A-InitializeFunction.
           Perform A11B-HandleMainProcess.

      ******************************************************************
      *                      Initialize Function                       *
      ******************************************************************

       A11A-InitializeFunction.
           Move ItIsFalse to MainProcessIsOver.

      ******************************************************************
      *                      Handle Main Process                       *
      ******************************************************************

       A11B-HandleMainProcess.
           Perform A11C-HandleMainProcess
           until MainProcessIsOver = ItIsTrue.

       A11C-HandleMainProcess.
           Perform A11D-DisplayMainMenu.
           Perform A11E-GetUserChoice.
           Perform A11F-ExecuteSelectedFunction.

      ******************************************************************
      *                       Display Main Menu                        *
      ******************************************************************

       A11D-DisplayMainMenu.
           Display "1) Stock 2) Hired tools 3) Sold tools 4) Quit"
           Display "Your choice: ".

      ******************************************************************
      *                         Get User Choice                        *
      ******************************************************************

       A11E-GetUserChoice.
           Accept ResponseOfUser.

      ******************************************************************
      *                  Execute Selected Function                     *
      ******************************************************************

       A11F-ExecuteSelectedFunction.
           Evaluate True
               When ResponseOfUser = StockFileWillBeMaintained
                   Perform A11G-MaintainStockFile
               When ResponseOfUser = HiredToolsFileWillBeMaintained
                   Perform A11H-MaintainHiredToolsFile
               When ResponseOfUser = SoldToolsFileWillBeMaintained
                   Perform A11I-MaintainSoldToolsFile
               When ResponseOfUser = ProgramWillBeQuit
                   Move ItIsTrue to MainProcessIsOver
               When Other
                   Display "Wrong choice! Please try again"
           End-Evaluate.

      ******************************************************************
      *                      Maintain Stock File                       *
      ******************************************************************

       A11G-MaintainStockFile.
           Perform A12A-InitializeFunction.
           Perform A12B-DoMaintainStockFile.

      ******************************************************************
      *                      Initialize Function                       *
      ******************************************************************

       A12A-InitializeFunction.
           Move ItIsFalse to StockFileMaintenanceIsOver.

      ******************************************************************
      *                    Do Maintain Stock File                      *
      ******************************************************************

       A12B-DoMaintainStockFile.
           Perform A12C-DoMaintainStockFile
           until StockFileMaintenanceIsOver = ItIsTrue.

       A12C-DoMaintainStockFile.
           Perform A12H-GetUserChoice.
           Perform A12I-ExecuteSelectedFunction.

      ******************************************************************
      *                         Get User Choice                        *
      ******************************************************************

       A12H-GetUserChoice.
           Display "1) Add record 2) Update record 3) Delete Record 4) I
      -    "quire record 5) Quit"
           Accept ResponseOfUser.

      ******************************************************************
      *                  Execute Selected Function                     *
      ******************************************************************

       A12I-ExecuteSelectedFunction.
           Evaluate True
               When ResponseOfUser = StockDataWillBeAdded
                   Perform A12D-AddStockData
               When ResponseOfUser = StockDataWillBeUpdated
                   Perform A12E-UpdateStockData
               When ResponseOfUser = StockDataWillBeDeleted
                   Perform A12F-DeleteStcokData
               When ResponseOfUser = StockDataWillBeInquired
                   Perform A12G-InquireStcokRecord
               When ResponseOfUser = StockMenuWillBeQuit
                   Move ItIsTrue to StockFileMaintenanceIsOver
               When Other
                   Display "Wrong choice! Please try again"
           End-Evaluate.

      ******************************************************************
      *                        Add Stock Data                          *
      ******************************************************************

       A12D-AddStockData.
           Perform A121-EnterStockData.
           Perform A122-FillStockRecord.
           Write ToolStockRecord.
           If ToolStockStatus not = InputOutputIsSuccessful
               Perform A123-HandleFatalError
           End-If.

      ******************************************************************
      *                        Enter Stock Data                        *
      ******************************************************************

       A121-EnterStockData.
           Display "Enter NUMBER OF STOCK".
           Accept WToolStockStocknum.
           Display "Enter TOOL CODE SELL".
           Accept WToolStockCodesell.
           Display "Enter TOOL CODE HIRE".
           Accept WToolStockCodehire.
           Display "Enter STOCK LEVEL HIRE".
           Accept WToolStockLevelhire.
           Display "Enter STOCK LEVEL SELL".
           Accept WToolStockLevelsell.

      ******************************************************************
      *                      Write Stock Record                        *
      ******************************************************************

       A122-FillStockRecord.
           Move WToolStockStocknum to ToolStockStocknum.
           Move WToolStockCodesell to ToolStockCodesell.
           Move WToolStockCodehire to ToolStockCodehire.
           Move WToolStockLevelhire to ToolStockLevelhire.
           Move WToolStockLevelsell to ToolStockLevelsell.

      ******************************************************************
      *                        Handle Fatal Error                      *
      ******************************************************************

       A123-HandleFatalError.
           Display "Fatal error in A123 ".
           Display "ToolStockStatus = " ToolStockStatus.
           Stop Run.

      ******************************************************************
      *                        Update Stock Data                       *
      ******************************************************************

       A12E-UpdateStockData.
           Display "This function is not completed yet".
           Display "Please strike any key to continue".
           Stop " ".

      ******************************************************************
      *                 Maintain Hired Tools File                      *
      ******************************************************************

       A12F-DeleteStcokData.
           Display "This function is not completed yet".
           Display "Please strike any key to continue".
           Stop " ".

      ******************************************************************
      *                     Inquire Stock Record                       *
      ******************************************************************

       A12G-InquireStcokRecord.
           Display "Enter NUMBER OF STOCK".
           Accept WToolStockStocknum.
           Move WToolStockStocknum to ToolStockStocknum.
           Read ToolStock.
           If ToolStockStatus = InputOutputIsSuccessful
               Perform A12J-MoveStockRecordToDisplay
               Perform A12K-DisplayStockRecord
           Else
               Display "Stock record is not found in the file"
               Display "Please strike any key to continue"
               Stop " "
           End-If.

      ******************************************************************
      *             Move Stock Record to Display Variables             *
      ******************************************************************

       A12J-MoveStockRecordToDisplay.
           Move ToolStockStocknum to WToolStockStocknum.
           Move ToolStockCodesell to WToolStockCodesell.
           Move ToolStockCodehire to WToolStockCodehire.
           Move ToolStockLevelhire to WToolStockLevelhire.
           Move ToolStockLevelsell to WToolStockLevelsell.

      ******************************************************************
      *                    Display Stock Record                        *
      ******************************************************************

       A12K-DisplayStockRecord.
           Display "NUMBER OF STOCK.: " WToolStockStocknum.
           Display "TOOL CODE SELL..: " WToolStockCodesell.
           Display "TOOL CODE HIRE..: " WToolStockCodehire.
           Display "STOCK LEVEL HIRE: " WToolStockLevelhire.
           Display "STOCK LEVEL SELL: " WToolStockLevelsell.

      ******************************************************************
      *                 Maintain Hired Tools File                      *
      ******************************************************************

       A11H-MaintainHiredToolsFile.
           Perform A124-EnterHiredToolData.
           Perform A125-FillHireTransRecord.
           Write HireTransactionsRecord.
           If HireTransactionsStatus not = InputOutputIsSuccessful
               Perform A126-HandleFatalError
           End-If.

      ******************************************************************
      *                     Enter Hired Tool Data                      *
      ******************************************************************

       A124-EnterHiredToolData.
           Display "Enter CUSTOMER NUMBER".
           Accept WHTCustNum.
           Display "Enter COMPLETE TOOL CODE HIRE".
           Display "First enter TYPE OF TOOL".
           Accept WHTType.
           Display "Now enter SERIAL NUMBER OF TOOL".
           Accept WHTSerial.
           Display "Finallly enter whether TOOL IS FOR HIRE `H` OR SALE
      -    "`S`".
           Accept WHTSorh.
           Display "Enter NUMBER OF QUANTITY".
           Accept WHTQuantity.
           Display "Enter UNIT PRICE".
           Accept WHTUnitprice.
           Display "Enter TAX RATE".
           Accept WHTTaxrate.
           Display "Enter NUMBER OF DAY HIRE".
           Accept WHTNumhire.
           Display "Enter HIRE CHRAGE PER DAY".
           Accept WHTChgday.
           Display "Enter TOTAL AMOUNT TO PAY".
           Accept WHTTotal.

      ******************************************************************
      *                  Fill HireTransactionsRecord                   *
      ******************************************************************

       A125-FillHireTransRecord.
           Move WHTCustNum to HTCustNum.
           Move WHTType to HTType.
           Move WHTSerial to STSerial.
           Move WHTSorh to HTSorh.
           Move WHTQuantity to HTQuantity.
           Move WHTUnitprice to HTUnitprice.
           Move WHTTaxrate to HTTaxrate.
           Move WHTNumhire to HTNumhire.
           Move WHTChgday to HTChgday.
           Move WHTTotal to HTTotal.

      ******************************************************************
      *                        Handle Fatal Error                      *
      ******************************************************************

       A126-HandleFatalError.
           Display "Fatal error in A126 ".
           Display "HireTransactionsStatus = " HireTransactionsStatus.
           Stop Run.

      ******************************************************************
      *                   Maintain Sold Tools File                     *
      ******************************************************************

       A11I-MaintainSoldToolsFile.
           Perform A127-EnterSoldToolData.
           Perform A128-FillSalesTransRecord.
           Write SalesTransactionsRecord.
           if SalesTransactionsStatus not = InputOutputIsSuccessful
               Perform A129-HandleFatalError
           end-if.

      ******************************************************************
      *                     Enter Sold Tool Data                       *
      ******************************************************************

       A127-EnterSoldToolData.
           Display "Enter INVOICE NUMBER".
           Accept WSTInvNum.
           Display "Enter COMPLETE TOOL CODE SELL".
           Display "First enter TYPE OF TOOL".
           Accept WSTType.
           Display "Now enter SERIAL NUMBER OF TOOL".
           Accept WSTSerial.
           Display "Finally enter whether TOOL IS FOR  HIRE `H` OR SALE
      -    "`S`".
           Accept WSTSorh.
           Display "Enter NUMBER OF QUANTITY".
           Accept WSTQuantity
           Display "Enter UNIT PRICE".
           Accept WSTUnitPrice.
           Display "Enter TAX RATE".
           Accept WSTTaxRate.
           Display "Enter TOTAL AMOUNT TO PAY".
           Accept WSTTotal.

      ******************************************************************
      *                  Fill SalesTransactionsRecord                  *
      ******************************************************************

       A128-FillSalesTransRecord.
           Move WSTInvNum to STInvNum.
           Move WSTType  to STType.
           Move WSTSerial to STSerial.
           Move WSTSorh to STSorh.
           Move WSTQuantity to STQuantity.
           Move WSTUnitPrice to STUnitPrice.
           Move WSTTaxRate to STTaxRate.
           Move WSTTotal to STTotal.

      ******************************************************************
      *                        Handle Fatal Error                      *
      ******************************************************************

       A129-HandleFatalError.
           Display "Fatal error in A129 ".
           Display "SalesTransactionsStatus = " SalesTransactionsStatus.
           Stop Run.

      ******************************************************************
      *                      Terminate Program                         *
      ******************************************************************

       A113-Terminate-Program.
           If FatalIOErrorHasOccured = ItIsTrue
               Perform A11P-HandleAbnormalEnd
           End-if.
           Perform A11J-CloseToolStockFile.
           Perform A11L-CloseHiredToolsFile.
           Perform A11N-CloseSoldToolsFile.
           Display "Program has ended successfully".
           Stop Run.

      ******************************************************************
      *                     Handle Abnormal End                        *
      ******************************************************************

       A11P-HandleAbnormalEnd.
           Display "Program has ended abnormally".
           Stop Run.
