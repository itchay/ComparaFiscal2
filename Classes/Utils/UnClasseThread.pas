unit UnClasseThread;

interface

uses
  Classes;

procedure executarThread(lMetodo: TThreadMethod);

{const
  _KEY = 'SUPERA';
  _DLL_DE_IMAGENS = 'Images.dll';
  _DLL_COMPANYTEC = 'Companytec.dll';
  _DLL_PCSCALE = 'PcScale.dll';

  _INVALIDO = 0;
  _BEMATECH = 1;
  _DARUMA = 2;
  _EPSON = 3;
  _PCSCALE = 4;
  _COMPANYTEC = 5;

  _MAX_VALOR_PERMITIDO = 1000000;}

implementation

//uses
  //System.Win.Registry, System.Variants;

procedure executarThread(lMetodo: TThreadMethod);
begin
  TThread.CreateAnonymousThread(procedure
                                begin
                                  TThread.Synchronize(TThread.CurrentThread, lMetodo);
                                end).Start;
end;

end.



