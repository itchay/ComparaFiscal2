unit UnClasseATF;

interface

uses
  Generics.Collections, UnClasseATF_Emitente, UnClasseATF_Nota, Dialogs, forms, Winapi.Windows, DateUtils;

type
  TATF = class (TObject)
    private
      iId_ATF: integer;
      sCaminhoArquivo, sArquivo: string;
      oEmitente: TATF_Emitente;
      oListaNotas: TObjectList<TATF_Nota>;

      dtDataEntrada: TDateTime;
      dDataEmissao: TDate;

      function carregaDataEmissaoNotas(): TDate;

    public
      property Id_ATF: integer
        read iId_ATF
        write iId_ATF;

      property CaminhoArquivo: string
        read sCaminhoArquivo
        write sCaminhoArquivo;

      property Arquivo: string
        read sArquivo
        write sArquivo;

      property Emitente: TATF_Emitente
        read oEmitente
        write oEmitente;

      property ListaNotas: TObjectList<TATF_Nota>
        read oListaNotas
        write oListaNotas;

      property dataEntrada: TDateTime
        read dtDataEntrada
        write dtDataEntrada;

      property DataEmissao: TDate
        read dDataEmissao
        write dDataEmissao;

      function validar: boolean;
      function salvar(): integer;
      function retornarUltimaIdATF: Integer;
      function listar(bPesquisaSimplificada: boolean; sCNPJ: string; dDataInicio, dDataFinal: TDateTime): TObjectList<TATF>;
      procedure excluir;
      constructor Create();
  end;

implementation

uses
  IBQuery, SysUtils, UnClassePool_BD_IB, UnConstantes, UnClasseUtils;

{ TATF }

constructor TATF.Create;
begin
  inherited Create();
  iId_ATF:= 0;
  sCaminhoArquivo:= '';
  sArquivo:= '';
  oEmitente:= TATF_Emitente.Create();
  oListaNotas:= TObjectList<TATF_Nota>.Create();
  dtDataEntrada := now();
  dDataEmissao := now();
end;

function TATF.validar: boolean;
var
  auxATF: TATF;
  i: Integer;
  query: TIBQuery;
  ini, fim: string;
  auxString: string;
begin
  query := PoolDeConexoes.getConexao(_BD_COMPARA_FISCAL).createNewQuery;
  Result:= true;
  carregaDataEmissaoNotas();

  //verifica se o periodo do arquivo j� foi inserido no banco de dados
  try
    with query do
    begin
      SQL.Text:=    ' SELECT  a.ID_ATF' +
                    ' FROM atf a' +
                    ' INNER JOIN atf_emitente e on e.id_ATF = a.id_ATF' +
                    ' WHERE e.cnpj = ' + QuotedStr(self.oEmitente.CNPJ) +
                    '         AND a.data_emissao between ''' + converteFormatoDataBD(FormatDateTime('dd/mm/yyyy', self.dDataEmissao), '01')
                                                       + ''' AND ''' + converteFormatoDataBD(FormatDateTime('dd/mm/yyyy', self.dDataEmissao), intToStr(daysinmonth(self.dDataEmissao))) + '''';

      auxString := SQL.Text;
      Open;
      if not IsEmpty then
        result := false;

      Close;
    end;
  finally
    FreeAndNil(query);
  end;
end;

//arquivo ATF n�o possui data de emissao bem definida, ent�o retorna essa informa��o baseada nas notas
function TATF.carregaDataEmissaoNotas(): TDate;
var
  y: integer;
  auxMenorDataEmissao: TDate;
begin
  for y := 0 to oListaNotas.Count - 1 do
  begin
    If (y = 0) OR (oListaNotas[y].DATA_EMISSAO < auxMenorDataEmissao) then
      auxMenorDataEmissao := oListaNotas[y].DATA_EMISSAO;
  end;

  self.dDataEmissao := auxMenorDataEmissao;
  result := auxMenorDataEmissao;
end;

function TATF.salvar(): integer;
var
  i: Integer;
  query1, query2: TIBQuery;
begin
  Result := 0;
  query1 := PoolDeConexoes.getConexao(_BD_COMPARA_FISCAL).createNewQuery;

  carregaDataEmissaoNotas();
  try
    with query1 do
    begin
        SQL.Text:= ' INSERT INTO ATF(CAMINHO_ARQUIVO,' +
                    '                 DATA_EMISSAO,' +
                    '                 ARQUIVO)' +
                   ' VALUES (' + QuotedStr(self.sCaminhoArquivo) + ',' +
                   '         ' + QuotedStr(formatDateTime('mm/dd/yyyy', self.dDataEmissao))+ ',' +
                   '         ' + QuotedStr(Self.sArquivo) + ')';

        ExecSQL;
        Transaction.Commit;
        Close;

        Self.iId_ATF := retornarUltimaIdATF();
        Result := Self.iId_ATF;
    end;

    oEmitente.salvar(Self.iId_ATF);
    //Notas Fiscais
    for i := 0 to oListaNotas.Count - 1 do
    begin
      oListaNotas[i].Salvar(Self.iId_ATF);
    end;

  finally
    FreeAndNil(query1);
  end;
end;

function TATF.retornarUltimaIdATF: Integer;
var
  query: TIBQuery;
begin
  query := PoolDeConexoes.getConexao(_BD_COMPARA_FISCAL).createNewQuery();
  try
    with query do
    begin
      SQL.Text := ' SELECT FIRST (1) s.id_ATF' +
                  ' FROM ATF s' +
                  ' ORDER BY s.id_ATF DESC';
      Open;
      if not IsEmpty then
        Result := FieldByName('id_ATF').AsInteger;
      Close;
    end;
  finally
    FreeAndNil(query);
  end;
end;

function TATF.listar(bPesquisaSimplificada: boolean; sCNPJ: string; dDataInicio, dDataFinal: TDateTime): TObjectList<TATF>;
var
  auxATF: TATF;
  auxNota: TATF_Nota;
  i: Integer;
  query: TIBQuery;
  ini, fim: string;
begin
  query := PoolDeConexoes.getConexao(_BD_COMPARA_FISCAL).createNewQuery;
  Result:= TObjectList<TATF>.Create();
  try
    with query do
    begin
      SQL.Text:=    ' SELECT          a.ID_ATF,' +
                    '                 a.CAMINHO_ARQUIVO,' +
                    '                 a.ARQUIVO,' +
                    '                 a.ENTRADA,' +
                    '                 a.DATA_EMISSAO,' +
                    '                 e.RAZAO_SOCIAL,' +
                    '                 e.CNPJ,' +
                    '                 e.INSCRICAO_ESTADUAL,' +
                    '                 e.SIGLA_UF' +
                    ' FROM ATF a' +
                    ' INNER JOIN atf_emitente e on e.id_ATF = a.id_ATF' +
                    ' WHERE ';


      If (dDataInicio <> 0) and
         (dDataFinal <> 0) then
      begin
         ini := FormatDateTime('mm/dd/yyyy', dDataInicio);
         fim := FormatDateTime('mm/dd/yyyy', dDataFinal + 1);

         SQL.Text:= SQL.Text + ' a.data_emissao between ''' + ini + ''' AND ''' + fim + '''';
      end
      else
      begin
        Application.MessageBox('O Per�odo Inicial e Final s�o requeridos para efetuar a consulta!','Per�odo Inv�lido',mb_Ok + mb_IconStop);
        exit;
      end;

      if sCNPJ <> '' then
        SQL.Text:= SQL.Text + ' AND e.CNPJ = ' + QuotedStr(sCNPJ);

      SQL.Text:= SQL.Text + ' ORDER BY a.id_ATF desc';

      Open;
      if not IsEmpty then
      begin
        First();
        while not Eof do
        begin
          auxATF:= TATF.Create();
          with auxATF do
          begin
            //Identifica��o
            Id_ATF := FieldByName('ID_ATF').AsInteger;
            CaminhoArquivo := FieldByName('CAMINHO_ARQUIVO').AsString;
            Arquivo := FieldByName('ARQUIVO').AsString;
            dataEntrada := FieldByName('ENTRADA').AsDateTime;
            DataEmissao := FieldByName('DATA_EMISSAO').AsDateTime;

            With Emitente do
            begin
              NomeEmpresa := FieldByName('RAZAO_SOCIAL').AsString;
              CNPJ := FieldByName('CNPJ').AsString;
              InscricaoEstadual := FieldByName('INSCRICAO_ESTADUAL').AsString;
              UF := FieldByName('SIGLA_UF').AsString;
              Id_ATF := Id_ATF;
            end;

            if bPesquisaSimplificada = false then
            begin
              //retorna sem a lista de Notas, para melhorar performance
              auxNota:= TATF_Nota.Create();
              auxATF.oListaNotas:= auxNota.listar(IntToStr(iId_ATF));
            end;

          end;

          Result.Add(auxATF);
          Next();
        end;
      end;
      Close;
    end;
  finally
    FreeAndNil(query);
  end;
end;

procedure TATF.excluir;
var
  query: TIBQuery;
  auxNota: TATF_Nota;
begin
  query := PoolDeConexoes.getConexao(_BD_COMPARA_FISCAL).createNewQuery;
  try
    with query do
    begin
      SQL.Text := ' DELETE FROM ATF a' +
                  ' WHERE a.id_ATF = ' + QuotedStr(IntToStr(self.Id_ATF));
      ExecSQL;
      Transaction.Commit;
      Close;
    end;

    //excluir registros
    With Self do
    begin
      oEmitente.excluir(self.Id_ATF);

      auxNota := TATF_Nota.Create();
      auxNota.excluir(Self.Id_ATF);
    end;

  finally
    FreeAndNil(query);
  end;
end;

end.

