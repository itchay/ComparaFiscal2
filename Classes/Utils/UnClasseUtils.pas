unit UnClasseUtils;

interface

uses
  ExtCtrls, ActnList, StdCtrls, Grids, CheckLst, Graphics, DateUtils, Forms,
  Classes, Vcl.ComCtrls, Vcl.Controls, Generics.Collections, System.Win.ComObj,
  TypInfo, Vcl.Clipbrd, Winapi.Windows, Winapi.Messages, System.SysUtils,  Vcl.Dialogs,  Vcl.Buttons,
  UnConstantes,IBQuery, UnClassePool_BD_IB;

//Sistema
function verificaValidade(): Boolean;
//Utilidades
procedure limparGrid(grid: TStringGrid; iniciarLinha: integer);

function retirarFormatacaoPasta(nome: String): String;
function excluirPasta(pastaRaiz : String): Boolean;
function mesEmExtenso (xMes : Variant) : string;
function encontrarSubPasta(const dirInicial: string;
                           const subPastaAEncontrar : String;
                           var caminhoPasta: String) : Boolean;

function retornarDadosDoArquivo(caminhoArquivo: String): TStringList;
function lerEntradaDoXML(localDaChaveNoXML, nomeDaChave: String): String;

procedure alterarCertificadoDigitalXML(nomeCertificado, numSerie: String);

function ambienteDeProgramacao(): Boolean;
function formataFloatParaBanco (Lstr_float : String): string;
function truncarValor(lValor: Real; lQtdeCasasDecimais: Integer): String;
function CompletaComZeros (Antes : Boolean; Palavra : String; digitos: Integer) : String;
function retiraCaractere(caractere: String; valor: String): String;
function retiraFormatacaoCPFCNPJ(lCPF_CNPJ: String): String;
function converteFormatoData(lData: string): string;
//function converteFormatoDataBD(lData: string): string;
function converteFormatoDataBD(lData: string; lDia:string = ''): string;

function StrToFloatCorrigido(const S: string): Extended;
function StrToDateTimeCorrigido(const S: string): TDateTime;

procedure validaTeclaNumericaEVirgula(Sender: TObject; var Key: Char);

const
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

  _MAX_VALOR_PERMITIDO = 1000000;

implementation

uses
  System.Win.Registry, System.Variants, Jpeg,
  XMLDoc, XMLIntf, ShellAPI, WinInet, IdDayTime;//, UnClasseBaseDados;

procedure limparGrid(grid: TStringGrid; iniciarLinha: integer);
var
  i: integer;
begin
  {with grid do
  begin
    Rows[1].Clear;
    RowCount:= 2;
  end;}

  for i := iniciarLinha to grid.RowCount - 1 do
    grid.Rows[i].Clear;
  grid.RowCount := 2;
end;

function verificaValidade(): Boolean;
var
  auxDataValidadeSoftware: TDate;
  auxDataAtual: TDate;
  query: TIBQuery;
begin
  query := PoolDeConexoes.getConexao(_BD_COMPARA_FISCAL).createNewQuery;
  with query do
  begin
    Close;
    SQL.Text:= ' SELECT e.validade' +
               ' FROM empresa e';
    Open;
    auxDataValidadeSoftware := FieldByName('validade').AsDateTime;
    auxDataAtual := Date();

    //verifica a data de validade do software, caso a data de validade seja menor que a data atual do computador apresenta mensagem de erro
    If auxDataValidadeSoftware < auxDataAtual then
    begin
      Application.MessageBox('Validade do software expirada!' + #13 +
                             'Por favor entre em contato com o nosso suporte(3322-5555).',
                             'Premium Key Expirada', MB_ICONERROR + MB_OK);
      result:= false;
    end
    else
    begin
      result:= true;

      //se o software expirar hoje avisa ao usuario
      if Round((auxDataValidadeSoftware - auxDataAtual)) = 0 then
        Application.MessageBox(PChar('Validade do software expira hoje as 23:59:59' + #13 +
                                         'Por favor entre em contato com o Administrador do sistema.'),
                                   'Aten��o', MB_ICONWARNING + MB_OK)

      //se faltar 7 ou menos dias para expirar o software avisa ao usuario
      else if Round((auxDataValidadeSoftware - auxDataAtual)) <= 7 then
        Application.MessageBox(PChar('Validade do software expira em ' + IntToStr(Round((auxDataValidadeSoftware - auxDataAtual))) + ' dia(s)' + #13 +
                                         'Por favor entre em contato com o Administrador do sistema.'),
                                   'Aten��o', MB_ICONWARNING + MB_OK);
    end;
  end;
end;

function converteFormatoData(lData: string): string;
var
  auxDataInicial, auxDataFinal: string;
begin
  Result := Copy(lData, 1, 2) + '/' +
            copy(lData, 3, 2) + '/' +
            Copy(lData, 5, 4);
end;

// MM/dd/yyyy
function converteFormatoDataBD(lData: string; lDia: string = ''): string;
var
  auxDataInicial, auxDataFinal: string;
begin
  lData := retiraCaractere('/', lData);

  if lDia <> '' then
    Result := Copy(lData, 3, 2) + '/' +
            ldia + '/' +
            Copy(lData, 5, 4)
  else
    Result := Copy(lData, 3, 2) + '/' +
            Copy(lData, 1, 2) + '/' +
            Copy(lData, 5, 4);
end;

function retirarFormatacaoPasta(nome: String): String;
var
  aux: String;
begin
  aux := StringReplace(nome, '\', '', [rfReplaceAll]);
  aux := StringReplace(aux, '/', '', [rfReplaceAll]);
  aux := StringReplace(aux, ':', '', [rfReplaceAll]);
  aux := StringReplace(aux, '*', '', [rfReplaceAll]);
  aux := StringReplace(aux, '?', '', [rfReplaceAll]);
  aux := StringReplace(aux, '"', '', [rfReplaceAll]);
  aux := StringReplace(aux, '>', '', [rfReplaceAll]);
  aux := StringReplace(aux, '<', '', [rfReplaceAll]);
  aux := StringReplace(aux, '|', '', [rfReplaceAll]);
  Result := aux;
end;

function excluirPasta(pastaRaiz : String): Boolean;
var
  r: TshFileOpStruct;
  LeaveFolder: Boolean;
begin
  Result := False;
  LeaveFolder := False;
  if not DirectoryExists(pastaRaiz) then
    Exit;
  if LeaveFolder then
    pastaRaiz := pastaRaiz + '*.*'
  else if pastaRaiz[Length(pastaRaiz)] = '\' then
    Delete(pastaRaiz, Length(pastaRaiz), 1);
  FillChar(r, SizeOf(r), 0);
  r.wFunc := FO_DELETE;
  r.pFrom := Pchar(pastaRaiz);
  r.fFlags := FOF_ALLOWUNDO or FOF_NOCONFIRMATION;
  Result := ((ShFileOperation(r) = 0) and (not r.fAnyOperationsAborted));
end;

function mesEmExtenso (xMes : Variant) : string;
Var
  Dia, Mes, Ano : Word;
begin
  Mes := 0;
  case VarType (xMes) of
    VarDate : DecodeDate (xMes, Ano, Mes, Dia);
    VarString :
    begin
      try
        Mes := StrToInt (xMes);
      except
      end;
    end
    else
      try
        Mes := Round (xMes);
      except
      end;
  end;

  case Mes of
    1: Result := 'Janeiro';
    2: Result := 'Fevereiro';
    3: Result := 'Mar�o';
    4: Result := 'Abril';
    5: Result := 'Maio';
    6: Result := 'Junho';
    7: Result := 'Julho';
    8: Result := 'Agosto';
    9: Result := 'Setembro';
    10: Result := 'Outubro';
    11: Result := 'Novembro';
    12: Result := 'Dezembro';
  else
    Result := ' ';
  end;
end;

function encontrarSubPasta(const dirInicial: string;
                           const subPastaAEncontrar : String;
                           var caminhoPasta: String) : Boolean;
var
  searchResult: TSearchRec;
begin
  Result := False;
  caminhoPasta := '';
  if FindFirst(dirInicial + '\*', faAnyFile, searchResult) = 0 then
  begin
    try
      repeat
        if (searchResult.Name <> '.') and (searchResult.Name <> '..') then
        begin
          if (searchResult.Name = subPastaAEncontrar) then
          begin
            caminhoPasta := IncludeTrailingBackSlash(dirInicial) + searchResult.Name;
            Result := True;
            Break;
          end
          else
          begin
            Result := encontrarSubPasta(IncludeTrailingBackSlash(dirInicial) + searchResult.Name,
                                        subPastaAEncontrar,
                                        caminhoPasta);
            if Result then
              Exit;
          end;
        end;
      until
        (FindNext(searchResult) <> 0)

    finally
      FindClose(searchResult);
    end;
  end;
end;

function retornarDadosDoArquivo(caminhoArquivo: String): TStringList;
var
  arquivo: TextFile;
  linha: String;
begin
  Result:= TStringList.Create;
  try
    AssignFile(arquivo, caminhoArquivo);
    Reset(arquivo);
    Readln(arquivo, linha);
    Result.Add(linha);
    while not Eof(arquivo) do
    begin
      Readln(arquivo, linha);
      Result.Add(linha);
    end;
    CloseFile(arquivo);
  except
    FreeAndNil(arquivo);
  end;
end;

function lerEntradaDoXML(localDaChaveNoXML, nomeDaChave: String): String;
var
  oArquivoXML_NFE, oNFEConfig: TXMLDocument;
  oNodeNFE, oNodeChave: IXMLNode;
begin
  Result:= '';
  if FileExists(ExtractFilePath(ParamStr(0)) + 'configMDFE.xml') then
  begin
    oArquivoXML_NFE:= TXMLDocument.Create(Application);
    oArquivoXML_NFE.Active:= True;
    oArquivoXML_NFE.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'configMDFE.xml');

    oNFEConfig:= TXMLDocument.Create(Application);
    with oNFEConfig do
    begin
      oNodeNFE:= oArquivoXML_NFE.DocumentElement.ChildNodes.FindNode('MDFE');
      if oNodeNFE <> Nil then
      begin
        oNodeChave:= oNodeNFE.ChildNodes.FindNode(localDaChaveNoXML);
        if oNodeChave <> Nil then
          Result:= oNodeChave.ChildNodes[nomeDaChave].Text;
      end;
    end;
  end;
end;

procedure alterarCertificadoDigitalXML(nomeCertificado, numSerie: String);
var
  oArquivoXMLConfig: TXMLDocument;
  oNodeMDFE, oNodeCertificadoDigital: IXMLNode;
begin
  {oArquivoXMLConfig:= TXMLDocument.Create(Application);
  oArquivoXMLConfig.Active:= True;
  oArquivoXMLConfig.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'configMDFE.xml');

  with oBaseDados do
  begin
    oNodeMDFE:= oArquivoXMLConfig.DocumentElement.ChildNodes.FindNode('MDFE');
    if oNodeMDFE <> Nil then
    begin
      oNodeCertificadoDigital:= oNodeMDFE.ChildNodes.FindNode('CertificadoDigital');
      if oNodeCertificadoDigital <> Nil then
      begin
        CertificadoDigital.Nome.Dados := nomeCertificado;
        oNodeCertificadoDigital.ChildNodes[CertificadoDigital.Nome.Nome].Text := CertificadoDigital.Nome.Dados;
        CertificadoDigital.NumeroSerie.Dados := numSerie;
        oNodeCertificadoDigital.ChildNodes[CertificadoDigital.NumeroSerie.Nome].Text := CertificadoDigital.NumeroSerie.Dados;
      end;
    end;
  end;
  oArquivoXMLConfig.SaveToFile(ExtractFilePath(ParamStr(0)) + 'configMDFE.xml'); }
end;

function ambienteDeProgramacao(): Boolean;
begin
  Result := FileExists('C:\APMDFE');
end;

function formataFloatParaBanco (Lstr_float : String): string;
var
  I: integer;
  CharSet1, CharSet2: TSysCharSet;
begin
  CharSet1:= ['.'];
  CharSet2:= [','];
  Result := '';
  for I := 1 to Length(Lstr_float) do
  begin
    if CharInSet(Lstr_float[I], CharSet2) then
    begin
      Result := Result + '.';
    end
    else
    if CharInSet(Lstr_float[I], CharSet1) then
    begin
      Result := Result;
    end
    else
    begin
      Result := Result + Lstr_float[I];
    end;
  end;
end;

function truncarValor(lValor: Real; lQtdeCasasDecimais: Integer): String;
var
  lParteInteira : String;
  lParteFracionaria : String;
  aux : String;
//  lParteInteira : Int64;
//  lParteFracionaria : Int64;

begin
  if (lQtdeCasasDecimais <> 0) then
  begin
    if (lValor <> 0) then
    begin
      if lValor > _MAX_VALOR_PERMITIDO then
        raise Exception.Create('O valor ultrapassa o permitido. (m�ximo ' + IntToStr(_MAX_VALOR_PERMITIDO) + ')' + #13 +
                               'Valor: ' + FloatToStrF(lValor, ffNumber, 15, 02));
      aux := FloatToStrF(lValor, ffNumber, 15, lQtdeCasasDecimais + 1);
      lParteFracionaria := Copy(aux, Pos(',', aux) + 1, Length(aux) - Pos(',', aux) - 1);
      lParteInteira := Copy(aux, 1, Pos(',', aux) - 1);
      Result := lParteInteira + ',' + CompletaComZeros(False, lParteFracionaria, lQtdeCasasDecimais);
      Result := StringReplace(Result, '.', '', [rfReplaceAll, rfIgnoreCase]);
    end
    else
      Result := '0,' + CompletaComZeros(true, '', lQtdeCasasDecimais);
  end
  else
    Result := IntToStr(trunc(lValor));
end;

function CompletaComZeros (Antes : Boolean; Palavra : String; digitos: Integer) : String;
var
  i : Integer;
  Aux: String;
begin
  Result:= '';
  if digitos >= Length (Palavra) then
  begin
    Aux:= Palavra;
    for i := 0 to (digitos - Length (Palavra) - 1) do
    begin
      if Antes then
      begin
        Aux := '0' + Aux;
      end
      else
      begin
        Aux := Aux + '0';
      end;
    end;
    Result:= Aux;
  end
  else
  begin
    Result:= Copy(Palavra, 1, digitos);
  end;
end;

procedure validaTeclaNumericaEVirgula(Sender: TObject; var Key: Char);
var
  digitosNumericos: TSysCharSet;
begin
  digitosNumericos:= ['0'..'9', ',', #8 , #13];
  if not (Key in digitosNumericos) then
  //if not CharInSet(Key, digitosNumericos) then
  begin
    Key:= #0;
    Beep();
  end;

  if Key = ',' then
  begin
    if Pos(',', Trim((Sender as TEdit).Text)) <> 0 then
    begin
      Key := #0;
      Beep();
    end;
  end;

end;

function retiraCaractere(caractere: String; valor: String): String;
begin
  Result:= StringReplace(valor, caractere, '', [rfReplaceAll, rfIgnoreCase])
end;

function retiraFormatacaoCPFCNPJ(lCPF_CNPJ: String): String;
begin
  Result:= retiraCaractere('.', retiraCaractere('-', retiraCaractere('/', lCPF_CNPJ)));
end;

function StrToFloatCorrigido(const S: string): Extended;
begin
  //remove ponto e transforma strings vazias e invalidas em zero
  try
    result := System.SysUtils.StrToFloat(retiraCaractere('.', S));
  except
    result := 0;
  end;
end;

function StrToDateTimeCorrigido(const S: string): TDateTime;
begin
  try
    Result := StrToDateTime(S, FormatSettings);
  except
    result := 0
  end;
end;

end.
