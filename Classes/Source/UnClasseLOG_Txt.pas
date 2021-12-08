unit UnClasseLOG_Txt;

interface

//uses UnInterfaceLogavel, UnClasseUsuario;

type
  TLOG_Txt = class(TObject)

  private
    dData: TDate;
    tHora: TTime;

    sMsg: String;
    sCaminhoArquivo: String;
    sNomeArquivo: String;
    oArquivoTxt: TextFile;

    procedure setData(data: TDate);
    function getData():TDate;
    procedure setHora(hora: TTime);
    function getHora():TTime;

    procedure setMsg(mensagem: String);
    function getMsg(): String;

    function gerarArquivo(): Boolean;
    function criarPasta(const caminhoPasta: string): boolean;

  public
    constructor Create(lData: TDate;
                       lHora: TTime;
                       lTipoMsg,
                       lMsg: String);
    destructor Destroy();
    function salvar(): Boolean;

     property Data: TDate
      read getData
      write setData;
    property Hora: TTime
      read getHora
      write setHora;
    property Mensagem: String
      read getMsg
      write setMsg;

  end;

implementation

uses
  SysUtils, Dialogs, Forms;

{ TLOG_Txt }

constructor TLOG_Txt.Create(lData: TDate;
                            lHora: TTime;
                            lTipoMsg,
                            lMsg: String);
begin
  dData := lData;
  tHora := lHora;
  if lTipoMsg <> '' then
    sMsg := FormatDateTime('[dd/mm/yy ', dData) + FormatDateTime('hh:nn:ss] ', tHora) + lTipoMsg + ' - ' + lMsg
  else
    sMsg := '';
  sCaminhoArquivo:= ExtractFilePath(Application.ExeName) + 'LOG\';
  sNomeArquivo:= 'Log(' + StringReplace(FormatDateTime('ddddd', dData), '/', '-', [rfReplaceAll]) + ').txt';
  gerarArquivo();
end;

destructor TLOG_Txt.Destroy;
begin
  FreeAndNil(oArquivoTxt);
end;

function TLOG_Txt.gerarArquivo(): Boolean;
begin
  Result := False;
  if FileExists(sCaminhoArquivo + sNomeArquivo) then
  begin
    try
      AssignFile(oArquivoTxt, sCaminhoArquivo + sNomeArquivo);
    except
      ShowMessage('Não foi possível criar o arquivo de LOG!');
    end;
    try
      Append(oArquivoTxt);
      if self.sMsg <> '' then
        Writeln(oArquivoTxt, Self.sMsg);
      CloseFile(oArquivoTxt);
      Result := True;
    except
      CloseFile(oArquivoTxt);
    end;
  end
  else
  begin
    try
      AssignFile(oArquivoTxt, sCaminhoArquivo + sNomeArquivo);
    except
      ShowMessage('Não foi possível criar o arquivo de LOG!');
    end;
    try
      Rewrite(oArquivoTxt);
      if self.sMsg <> '' then
        Writeln(oArquivoTxt, Self.sMsg);
      CloseFile(oArquivoTxt);
      Result := True;
    except
      CloseFile(oArquivoTxt);
    end;
  end;
end;

function TLOG_Txt.getData: TDate;
begin
  Result:= Self.dData;
end;

function TLOG_Txt.getHora: TTime;
begin
  Result:= tHora;
end;

function TLOG_Txt.getMsg: String;
begin
  Result:= Self.sMsg;
end;

function TLOG_Txt.salvar: Boolean;
begin
  Result := False;
  if not DirectoryExists(sCaminhoArquivo) then
  begin
    if criarPasta(sCaminhoArquivo) then
      Result := gerarArquivo();
  end
  else
    Result := gerarArquivo();
end;

procedure TLOG_Txt.setData(data: TDate);
begin
  Self.dData:= data;
end;

procedure TLOG_Txt.setHora(hora: TTime);
begin
  Self.tHora:= hora;
end;

procedure TLOG_Txt.setMsg(mensagem: String);
begin
  Self.sMsg:= mensagem;
end;

function TLOG_Txt.criarPasta(const caminhoPasta: string): boolean;
begin
  if DirectoryExists(caminhoPasta) then
    Result := true
  else
    Result := CreateDir(caminhoPasta);
end;

end.






