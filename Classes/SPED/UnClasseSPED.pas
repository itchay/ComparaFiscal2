unit UnClasseSPED;

interface

uses
  Generics.Collections, UnClasseRegistro0000_Emitente, UnClasseRegistroC100_Notas, UnClasseRegistro0150_Participante,
  Dialogs, forms, Winapi.Windows;

type
  TSPED = class (TObject)
    private
      iId_SPED: integer;
      sCaminhoArquivo, sArquivo: string;
      oRegistro0000: TRegistro0000;

      oListaRegistros0150: TObjectList<TRegistro0150>;
      oListaRegistrosC100: TObjectList<TRegistroC100>;

      dtDataEntrada: TDateTime;

    public
      property Id_SPED: integer
        read iId_SPED
        write iId_SPED;

      property CaminhoArquivo: string
        read sCaminhoArquivo
        write sCaminhoArquivo;

      property Arquivo: string
        read sArquivo
        write sArquivo;

      property Registro0000: TRegistro0000
        read oRegistro0000
        write oRegistro0000;

      property ListaRegistros0150: TObjectList<TRegistro0150>
        read oListaRegistros0150
        write oListaRegistros0150;

      property ListaRegistrosC100: TObjectList<TRegistroC100>
        read oListaRegistrosC100
        write oListaRegistrosC100;

      property dataEntrada: TDateTime
        read dtDataEntrada
        write dtDataEntrada;

      function validar: boolean;
      function salvar(): integer;
      function retornarUltimaIdSPED: Integer;
      function listar(bPesquisaSimplificada: boolean; sCNPJ: string; dDataInicio, dDataFinal: TDateTime): TObjectList<TSPED>;
      procedure excluir;
      constructor Create();
  end;

implementation

uses
  IBQuery, SysUtils, UnClassePool_BD_IB, UnConstantes, UnClasseUtils;

{ TSPED }

constructor TSPED.Create;
begin
  inherited Create();
  iId_SPED:= 0;
  sCaminhoArquivo:= '';
  sArquivo:= '';
  oRegistro0000:= TRegistro0000.Create();
  oListaRegistros0150:= TObjectList<TRegistro0150>.Create();
  oListaRegistrosC100:= TObjectList<TRegistroC100>.Create();
  dtDataEntrada := now();
end;

function TSPED.validar: boolean;
var
  auxSPED: TSPED;
  auxC100: TRegistroC100;
  i: Integer;
  query: TIBQuery;
  ini, fim: string;
begin
  query := PoolDeConexoes.getConexao(_BD_COMPARA_FISCAL).createNewQuery;
  Result:= true;

  //verifica se o periodo do arquivo j� foi inserido no banco de dados
  try
    with query do
    begin
      SQL.Text:=    ' SELECT  s.ID_SPED' +
                    ' FROM SPED s' +
                    ' INNER JOIN R0000_emitente e on e.id_sped = s.id_sped' +
                    ' WHERE e.cnpj = ' + QuotedStr(self.oRegistro0000.CNPJ) +
                    '         AND e.data_inicial between ''' + converteFormatoDataBD(self.oRegistro0000.DataInicial)
                                                       + ''' AND ''' + converteFormatoDataBD(self.oRegistro0000.DataFinal) + '''';

      Open;
      if not IsEmpty then
        result := false;

      Close;
    end;
  finally
    FreeAndNil(query);
  end;
end;

function TSPED.salvar(): integer;
var
  i: Integer;
  query1, query2: TIBQuery;
begin
  Result := 0;
  query1 := PoolDeConexoes.getConexao(_BD_COMPARA_FISCAL).createNewQuery;
  try
    with query1 do
    begin
        SQL.Text:= ' INSERT INTO SPED(CAMINHO_ARQUIVO,' +
                    '                 ARQUIVO)' +
                   ' VALUES (' + QuotedStr(self.sCaminhoArquivo) + ',' +
                   '         ' + QuotedStr(Self.sArquivo) + ')';

        ExecSQL;
        Transaction.Commit;
        Close;

        Self.iId_SPED := retornarUltimaIdSPED();
        Result := Self.iId_SPED;
    end;

    oRegistro0000.salvar(Self.iId_SPED);

    //Participantes
    for i := 0 to oListaRegistros0150.Count - 1 do
      oListaRegistros0150[i].Salvar(Self.iId_SPED);

    //Notas Fiscais
    for i := 0 to oListaRegistrosC100.Count - 1 do
      oListaRegistrosC100[i].Salvar(Self.iId_SPED);

  finally
    FreeAndNil(query1);
  end;
end;

function TSPED.retornarUltimaIdSPED: Integer;
var
  query: TIBQuery;
begin
  query := PoolDeConexoes.getConexao(_BD_COMPARA_FISCAL).createNewQuery();
  try
    with query do
    begin
      SQL.Text := ' SELECT FIRST (1) s.id_sped' +
                  ' FROM sped s' +
                  ' ORDER BY s.id_sped DESC';
      Open;
      if not IsEmpty then
        Result := FieldByName('id_sped').AsInteger;
      Close;
    end;
  finally
    FreeAndNil(query);
  end;
end;

function TSPED.listar(bPesquisaSimplificada: boolean; sCNPJ: string; dDataInicio, dDataFinal: TDateTime): TObjectList<TSPED>;
var
  auxSPED: TSPED;
  auxC100: TRegistroC100;
  aux0150: TRegistro0150;
  i: Integer;
  query: TIBQuery;
  ini, fim: string;
begin
  query := PoolDeConexoes.getConexao(_BD_COMPARA_FISCAL).createNewQuery;
  Result:= TObjectList<TSPED>.Create();
  try
    with query do
    begin
      SQL.Text:=    ' SELECT          s.ID_SPED,' +
                    '                 s.CAMINHO_ARQUIVO,' +
                    '                 s.ARQUIVO,' +
                    '                 s.ENTRADA,' +
                    '                 e.CODIGO_FINALIDADE,' +
                    '                 e.CODIGO_VERSAO,' +
                    '                 e.DATA_INICIAL,' +
                    '                 e.DATA_FINAL,' +
                    '                 e.NOME_EMPRESA,' +
                    '                 e.CNPJ,' +
                    '                 e.INSCRICAO_ESTADUAL,' +
                    '                 e.UF,' +
                    '                 e.COD_MUN,' +
                    '                 e.SUFRAMA,' +
                    '                 e.IND_ATIV,' +
                    '                 e.CPF,' +
                    '                 e.INSCRICAO_MUNICIPAL' +
                    ' FROM SPED s' +
                    ' INNER JOIN R0000_emitente e on e.id_sped = s.id_sped' +
                    ' WHERE ';


      If (dDataInicio <> 0) and
         (dDataFinal <> 0) then
      begin
         ini := FormatDateTime('mm/dd/yyyy', dDataInicio);
         fim := FormatDateTime('mm/dd/yyyy', dDataFinal + 1);

         SQL.Text:= SQL.Text + ' e.data_inicial between ''' + ini + ''' AND ''' + fim + '''';
      end
      else
      begin
        Application.MessageBox('O Per�odo Inicial e Final s�o requeridos para efetuar a consulta!','Per�odo Inv�lido',mb_Ok + mb_IconStop);
        exit;
      end;

      if sCNPJ <> '' then
        SQL.Text:= SQL.Text + ' AND e.CNPJ = ' + QuotedStr(sCNPJ);

      SQL.Text:= SQL.Text + ' ORDER BY s.id_SPED desc';

      Open;
      if not IsEmpty then
      begin
        First();
        while not Eof do
        begin
          auxSPED:= TSPED.Create();
          with auxSPED do
          begin
            //Identifica��o
            Id_SPED := FieldByName('ID_SPED').AsInteger;
            CaminhoArquivo := FieldByName('CAMINHO_ARQUIVO').AsString;
            Arquivo := FieldByName('ARQUIVO').AsString;
            dataEntrada := FieldByName('ENTRADA').AsDateTime;

            With Registro0000 do
            begin
              CodigoFinalidadeArquivo := FieldByName('CODIGO_FINALIDADE').AsInteger;
              CodigoVersaoLeiaute := FieldByName('CODIGO_VERSAO').AsString;
              DataInicial := retiraCaractere('/', FieldByName('DATA_INICIAL').AsString);
              DataFinal := retiraCaractere('/', FieldByName('DATA_FINAL').AsString);
              NomeEmpresa := FieldByName('NOME_EMPRESA').AsString;
              CNPJ := FieldByName('CNPJ').AsString;
              InscricaoEstadual := FieldByName('INSCRICAO_ESTADUAL').AsString;
              UF := FieldByName('UF').AsString;
              COD_MUN:= FieldByName('COD_MUN').AsString;
              SUFRAMA := FieldByName('SUFRAMA').AsString;
              IND_ATIV := FieldByName('IND_ATIV').AsString;
              CPF := FieldByName('CPF').AsString;
              IM := FieldByName('INSCRICAO_MUNICIPAL').AsString;
              Id_SPED := Id_SPED;
            end;

            aux0150:= TRegistro0150.Create();
            auxSPED.oListaRegistros0150:= aux0150.listar(IntToStr(iId_SPED));

            if bPesquisaSimplificada = false then
            begin
              //retorna sem a lista de C100, para melhorar performance
              auxC100:= TRegistroC100.Create();
              auxSPED.oListaRegistrosC100:= auxC100.listar(IntToStr(iId_SPED));
            end;

          end;

          Result.Add(auxSPED);
          Next();
        end;
      end;
      Close;
    end;
  finally
    FreeAndNil(query);
  end;
end;

procedure TSPED.excluir;
var
  query: TIBQuery;
  auxC100: TRegistroC100;
  aux0150: TRegistro0150;
begin
  query := PoolDeConexoes.getConexao(_BD_COMPARA_FISCAL).createNewQuery;
  try
    with query do
    begin
      SQL.Text := ' DELETE FROM SPED s' +
                  ' WHERE s.id_sped = ' + QuotedStr(IntToStr(self.Id_SPED));
      ExecSQL;
      Transaction.Commit;
      Close;
    end;

    //excluir registros
    With Self do
    begin
      oRegistro0000.excluir(self.Id_SPED);

      aux0150 := TRegistro0150.Create();
      aux0150.excluir(Self.Id_SPED);

      auxC100 := TRegistroC100.Create();
      auxC100.excluir(Self.Id_SPED);
    end;

  finally
    FreeAndNil(query);
  end;
end;

end.

