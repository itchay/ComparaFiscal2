unit UnClasseRegistro0150_Participante;

interface

uses
  UnETipoParticipante, UnClasseUtils, Generics.Collections;

type
  // Tabela de Cadastro do Participante (Fornecedores, Clientes)
  TRegistro0150 = class(TObject)
    private
      sRegistro: String;
      sCod_Part,
      sNome,
      sCod_Pais,
      sCNPJ,
      sCPF,
      sIE,
      sCod_Mun,
      sSuframa,
      sEndereco,
      sNum,
      sCompl,
      sBairro: String;
      ftipo: ETipoParticipante;

      procedure setCod_Part(lCod_Part: String);
      procedure setNome(lNome: String);
      procedure setCod_Pais(lCod_Pais: String);
      procedure setCNPJ(lCNPJ: String);
      procedure setCPF(lCPF: String);
      procedure setIE(lIE: String);
      procedure setCod_Mun(lCod_Mun: String);
      procedure setSuframa(lSuframa: String);
      procedure setEnd(lEnd: String);
      procedure setNum(lNum: String);
      procedure setCompl(lCompl: String);
      procedure setBairro(lBairro: String);

      const
        _TAMANHO_CNPJ = 14;
        _TAMANHO_CPF = 11;
        _TAMANHO_COD_MUNICIPIO = 07;
        _TAMANHO_NUM_ID_PART_SUFRAMA = 09;

    public

      property Registro: String
        read sRegistro
        write sRegistro;
      property Cod_Part: String
        read sCod_Part
        write setCod_Part;
      property Nome: String
        read sNome
        write setNome;
      property Cod_Pais: String
        read sCod_Pais
        write setCod_Pais;
      property CNPJ: String
        read sCNPJ
        write setCNPJ;
      property CPF: String
        read sCPF
        write setCPF;
      property IE: String
        read sIE
        write setIE;
      property Cod_Mun: String
        read sCod_Mun
        write setCod_Mun;
      property Suframa: String
        read sSuframa
        write setSuframa;
      property Endereco: String
        read sEndereco
        write setEnd;
      property Num: String
        read sNum
        write setNum;
      property Compl: String
        read sCompl
        write setCompl;
      property Bairro: String
        read sBairro
        write setBairro;

      property Tipo: ETipoParticipante
        read ftipo
        write ftipo;

      function ToString: String; override;
      function salvar(lIdSPED: integer): boolean;
      procedure excluir(lIdSPED: integer);
      function listar(lIdSped: string): TObjectList<TRegistro0150>;

      constructor Create();
  end;

implementation

uses
  System.SysUtils, UnConstantes, IBQuery, UnClassePool_BD_IB;

{ TRegistro0150 }

constructor TRegistro0150.Create;
begin
  //inherited Create();
  sRegistro:= '0150';
  sCod_Part:= '';
  sNome:= '';
  sCod_Pais:= '';
  sCNPJ:= '';
  sCPF:= '';
  sIE:= '';
  sCod_Mun:= '';
  sSuframa:= '';
  sEndereco:= '';
  sNum:= '';
  sCompl:= '';
  sBairro:= '';
  ftipo := tpFornecedor;
end;

function TRegistro0150.listar(lIdSped: string): TObjectList<TRegistro0150>;
var
  aux0150: TRegistro0150;
  i: Integer;
  query: TIBQuery;
  ini, fim: string;
begin
  query := PoolDeConexoes.getConexao(_BD_COMPARA_FISCAL).createNewQuery;
  Result:= TObjectList<TRegistro0150>.Create();
  try
    with query do
    begin
      SQL.Text:=     ' SELECT     Cod_Part,' +
                          '       Nome,' +
                          '       Cod_Pais,' +
                          '       CNPJ,' +
                          '       CPF,' +
                          '       IE,' +
                          '       Cod_Mun,' +
                          '       Suframa,' +
                          '       Endereco,' +
                          '       Num,' +
                          '       Compl,' +
                          '       Bairro' +
                    ' FROM R0150_PARTICIPANTES p' +
                    ' WHERE p.ID_SPED = ' + QuotedStr(lIdSped);

      Open;
      if not IsEmpty then
      begin
        First();
        while not Eof do
        begin
          aux0150:= TRegistro0150.Create();
          with aux0150 do
          begin
            Cod_Part := FieldByName('Cod_Part').AsString;
            Nome :=  FieldByName('Nome').AsString;
            Cod_Pais :=  FieldByName('Cod_Pais').AsString;
            CNPJ :=  FieldByName('CNPJ').AsString;
            CPF :=  FieldByName('CPF').AsString;
            IE :=  FieldByName('IE').AsString;
            Cod_Mun :=  FieldByName('Cod_Mun').AsString;
            Suframa :=  FieldByName('Suframa').AsString;
            Endereco :=  FieldByName('Endereco').AsString;
            Num :=  FieldByName('Num').AsString;
            Compl :=  FieldByName('Compl').AsString;
            Bairro :=  FieldByName('Bairro').AsString;
          end;

          Result.Add(aux0150);
          Next();
        end;
      end;
      Close;
    end;
  finally
    FreeAndNil(query);
  end;
end;

procedure TRegistro0150.excluir(lIdSPED: integer);
var
  query: TIBQuery;
begin
  query := PoolDeConexoes.getConexao(_BD_COMPARA_FISCAL).createNewQuery;
  try
    with query do
    begin
      SQL.Text := ' DELETE FROM R0150_Participantes p' +
                  ' WHERE p.id_sped = ' + QuotedStr(IntToStr(lIdSPED));
      ExecSQL;
      Transaction.Commit;
      Close;
    end;
  finally
    FreeAndNil(query);
  end;
end;

function TRegistro0150.salvar(lIdSPED: integer): boolean;
var
  i: Integer;
  query1, query2: TIBQuery;
begin
  Result := false;
  query1 := PoolDeConexoes.getConexao(_BD_COMPARA_FISCAL).createNewQuery;
  try
    with query1 do
    begin
        SQL.Text:= ' INSERT INTO R0150_Participantes(ID_SPED,' +
                                            '       Cod_Part,' +
                                            '       Nome,' +
                                            '       Cod_Pais,' +
                                            '       CNPJ,' +
                                            '       CPF,' +
                                            '       IE,' +
                                            '       Cod_Mun,' +
                                            '       Suframa,' +
                                            '       Endereco,' +
                                            '       Num,' +
                                            '       Compl,' +
                                            '       Bairro)' +
                   ' VALUES (' + QuotedStr(IntToStr(lIdSPED)) + ',' +
                   '         ' + QuotedStr(Self.Cod_Part) + ',' +
                   '         ' + QuotedStr(self.nome) + ',' +
                   '         ' + QuotedStr(self.Cod_Pais) + ',' +
                   '         ' + QuotedStr(self.cnpj) + ',' +
                   '         ' + QuotedStr(self.cpf) + ',' +
                   '         ' + QuotedStr(self.ie) + ',' +
                   '         ' + QuotedStr(self.Cod_Mun) + ',' +
                   '         ' + QuotedStr(self.sSUFRAMA) + ',' +
                   '         ' + QuotedStr(self.Endereco) + ',' +
                   '         ' + QuotedStr(self.num) + ',' +
                   '         ' + QuotedStr(self.Compl) + ',' +
                   '         ' + QuotedStr(self.bairro) + ')';

        ExecSQL;
        Transaction.Commit;
        Close;

        Result := true;
    end;

  finally
    FreeAndNil(query1);
  end;
end;

procedure TRegistro0150.setBairro(lBairro: String);
begin
  Self.sBairro:= lBairro;
end;

procedure TRegistro0150.setCNPJ(lCNPJ: String);
begin
  Self.sCNPJ:= lCNPJ;
end;

procedure TRegistro0150.setCod_Mun(lCod_Mun: String);
begin
  Self.sCod_Mun:= lCod_Mun;
end;

procedure TRegistro0150.setCod_Pais(lCod_Pais: String);
begin
  Self.sCod_Pais:= lCod_Pais;
end;

procedure TRegistro0150.setCod_Part(lCod_Part: String);
begin
  Self.sCod_Part:= lCod_Part;
end;

procedure TRegistro0150.setCompl(lCompl: String);
begin
  Self.sCompl:= lCompl;
end;

procedure TRegistro0150.setCPF(lCPF: String);
begin
  Self.sCPF:= lCPF;
end;

procedure TRegistro0150.setEnd(lEnd: String);
begin
  Self.sEndereco:= lEnd;
end;

procedure TRegistro0150.setIE(lIE: String);
begin
  Self.sIE:= lIE;
end;

procedure TRegistro0150.setNome(lNome: String);
begin
  Self.sNome:= lNome;
end;

procedure TRegistro0150.setNum(lNum: String);
begin
  Self.sNum:= lNum;
end;

procedure TRegistro0150.setSuframa(lSuframa: String);
begin
  Self.sSuframa:= lSuframa;
end;

function TRegistro0150.ToString: String;
begin
  Result:= '|' + sRegistro + '|' + sCod_Part + '|' + sNome + '|' + sCod_Pais  +
           '|' + sCNPJ + '|' + sCPF + '|' + sIE + '|' + sCod_Mun +
           '|' + sSuframa + '|' + sEndereco + '|' + sNum + '|' + sCompl +
           '|' + sBairro + '|';
end;

end.

