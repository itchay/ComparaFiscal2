unit UnClasseComparaFiscal;

interface

uses
  UnClasseLOG_Txt, UnClasseConfiguracao, {UnClasseOferta,} UnClasseVersao, Vcl.Forms, Windows;
  //Forms, Windows, DB, IBDatabase, IBQuery, UnConstanteBD_IB, Generics.Collections;

type
  TComparaFiscal = class
  private
    oConfiguracao: TConfiguracao;
    //oNovaOferta: TOferta;
    oLOG: TLOG_Txt;
    oVersao: TVersao;

  public
    constructor Create();
    function verificaValidade: Boolean;

    property configuracao : TConfiguracao
      read oConfiguracao
      write oConfiguracao;
    {property novaOferta : TOferta
      read oNovaOferta
      write oNovaOferta;}
    property Log : TLOG_Txt
      read oLOG
      write oLOG;
    property Versao : TVersao
      read oVersao
      write oVersao;

  end;

  var
    oComparaFiscal : TComparaFiscal;

implementation

uses
  System.SysUtils, UnConstantes, IBQuery, UnClassePool_BD_IB;

{ TScanntech }

constructor TComparaFiscal.Create();
begin
  oConfiguracao := TConfiguracao.Create();
  //oNovaOferta := TOferta.Create();
  oLog := TLOG_Txt.Create(now, now, '', '');
  oVersao := TVersao.Create(Application.ExeName);

  if verificaValidade = false then
    Application.Terminate();
end;

function TComparaFiscal.verificaValidade: Boolean;
var
  auxDataValidadeSoftware: TDate;
  auxDataAtual: TDate;
  query1: TIBQuery;
begin
  query1 := PoolDeConexoes.getConexao(_BD_COMPARA_FISCAL).createNewQuery;
  try
    with query1 do
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
                               'Por favor entre em contato com o nosso suporte (83) 3322-5555.',
                               'Premium Key Expirada', MB_ICONERROR + MB_OK);
        result:= false;
      end
      else
      begin
        //se o software expirar hoje avisa ao usuario
        if Round((auxDataValidadeSoftware - auxDataAtual)) = 0 then
          Application.MessageBox(PChar('Validade do software expira hoje as 23:59:59' + #13 +
                                           'Por favor entre em contato com o Administrador do sistema.'),
                                     'Atenção', MB_ICONWARNING + MB_OK)

        //se faltar 7 ou menos dias para expirar o software avisa ao usuario
        else if Round((auxDataValidadeSoftware - auxDataAtual)) <= 7 then
          Application.MessageBox(PChar('Validade do software expira em ' + IntToStr(Round((auxDataValidadeSoftware - auxDataAtual))) + ' dia(s)' + #13 +
                                           'Por favor entre em contato com o Administrador do sistema.'),
                                     'Atenção', MB_ICONWARNING + MB_OK);
      end;
    end;
  finally
    FreeAndNil(query1);
  end;
end;

end.
