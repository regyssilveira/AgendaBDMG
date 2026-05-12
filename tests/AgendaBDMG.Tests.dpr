program AgendaBDMG.Tests;

{$DEFINE GUI}
{.$DEFINE TESTINSIGHT}

{$IFDEF CI}
  {$APPTYPE CONSOLE}
{$ELSE}
  {$IFNDEF GUI}
    {$IFNDEF TESTINSIGHT}
      {$APPTYPE CONSOLE}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

uses
  System.SysUtils,
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.Loggers.GUI.VCL,
  DUnitX.TestFramework,
  AgendaBDMG.Tests.Model.Tarefa in 'src\AgendaBDMG.Tests.Model.Tarefa.pas',
  AgendaBDMG.Tests.Mocks in 'src\AgendaBDMG.Tests.Mocks.pas',
  AgendaBDMG.Tests.Service.Tarefa in 'src\AgendaBDMG.Tests.Service.Tarefa.pas',
  AgendaBDMG.Tests.Utils.Json in 'src\AgendaBDMG.Tests.Utils.Json.pas',
  AgendaBDMG.Tests.Client.Utils in 'src\AgendaBDMG.Tests.Client.Utils.pas',
  AgendaBDMG.Client.Utils in '..\client\src\utils\AgendaBDMG.Client.Utils.pas',
  AgendaBDMG.Tests.Client.Config in 'src\AgendaBDMG.Tests.Client.Config.pas',
  AgendaBDMG.Client.Config in '..\client\src\utils\AgendaBDMG.Client.Config.pas';

var
  runner: ITestRunner;
  results: IRunResults;
  logger: ITestLogger;
  nunitLogger : ITestLogger;
begin
  Assert.IgnoreCaseDefault := False;

{$IFNDEF CI}
  {$IFDEF GUI}
    DUnitX.Loggers.GUI.VCL.Run;
    exit;
  {$ENDIF}

  {$IFDEF TESTINSIGHT}
    TestInsight.DUnitX.RunRegisteredTests;
    exit;
  {$ENDIF}
{$ENDIF}


  try
    // Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    // Create the test runner
    runner := TDUnitX.CreateRunner;
    // Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    // Tell the runner how we will log things
    // Log to the console window if desired
    logger := TDUnitXConsoleLogger.Create(True);
    runner.AddLogger(logger);
    // Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);

    // Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    // We don't want this happening when running under CI.
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
end.
