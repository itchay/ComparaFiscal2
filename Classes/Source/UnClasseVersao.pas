unit UnClasseVersao;

interface

type

  TVersao = class(TObject)
    private
      lArquivo: String;
      lVersao: String;
      sNumero: String;

      procedure setNumero(lNumero: string);
    public

      constructor Create(nomeArquivo: String); overload;
      constructor Create(); overload;

      function toString(): String;

      property Numero: String
        read sNumero
        write setNumero;

    protected

  end;

implementation

uses
  Types, Windows, SysUtils, Forms;

{ TVersao }

constructor TVersao.Create(nomeArquivo: String);
begin
  Self.lArquivo:= nomeArquivo;
  Self.lVersao:= Self.ToString();
end;

constructor TVersao.Create;
begin
  lArquivo:= '';
  lVersao:= '';
end;

procedure TVersao.setNumero(lNumero: string);
begin
  Self.sNumero:= lNumero;
end;

function TVersao.toString: string;
type
  PFFI = ^vs_FixedFileInfo;
var
  F : PFFI;
  Handle : Dword;
  Len : Longint;
  Data : Pchar;
  Buffer : Pointer;
  Tamanho : Dword;
  Parquivo: Pchar;
  Arquivo : AnsiString;
begin
  Arquivo := Application.ExeName;
  Parquivo := StrAlloc(Length(Arquivo) + 1);
  StrPcopy(Parquivo, Arquivo);
  Len := GetFileVersionInfoSize(Parquivo, Handle);
  Result := '';
  if Len > 0 then
  begin
    Data:=StrAlloc(Len+1);
    if GetFileVersionInfo(Parquivo,Handle,Len,Data) then
    begin
      VerQueryValue(Data, '\',Buffer,Tamanho);
      F := PFFI(Buffer);
      Result := Format('%d.%d.%d.%d',
      [HiWord(F^.dwFileVersionMs),
      LoWord(F^.dwFileVersionMs),
      HiWord(F^.dwFileVersionLs),
      Loword(F^.dwFileVersionLs)]);
    end;
    StrDispose(Data);
  end;
  StrDispose(Parquivo);
end;

end.


