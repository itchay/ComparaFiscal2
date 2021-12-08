unit UnFrmRelatoriosComparativo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  System.Actions, Vcl.ActnList, Vcl.Grids, Vcl.ComCtrls, UnClasseSPED, System.IOUtils, Generics.Collections,
  UnClasseATF, Vcl.Menus, ppParameter, ppDesignLayer, ppCtrls, ppBands, ppVar,
  ppPrnabl, ppClass, ppCache, ppProd, ppReport, Data.DB, ppComm, ppRelatv, ppDB,
  ppDBPipe, ppStrtch, ppCTMain, Datasnap.DBClient;

type
  TFrmRelatoriosComparativo = class(TForm)
    ActionList1: TActionList;
    ActFechar: TAction;
    PnlBotoes: TPanel;
    BtnGerar: TBitBtn;
    PnlInfoDoc: TPanel;
    GroupBox1: TGroupBox;
    DateSPEDInicial: TDateTimePicker;
    GroupBox4: TGroupBox;
    EdtIdSPED: TEdit;
    GroupBox3: TGroupBox;
    DateSPEDFinal: TDateTimePicker;
    BtnLimpar: TBitBtn;
    ActLimpar: TAction;
    StgATF: TStringGrid;
    GroupBox5: TGroupBox;
    StgSPED: TStringGrid;
    GroupBox2: TGroupBox;
    BtnSPEDAdicionar: TBitBtn;
    GroupBox7: TGroupBox;
    DateATF: TDateTimePicker;
    GroupBox8: TGroupBox;
    EdtIdATF: TEdit;
    BtnFechar: TBitBtn;
    GroupBox6: TGroupBox;
    GroupBox9: TGroupBox;
    RadioSaida: TRadioGroup;
    CmbTipoRelatorio: TComboBox;
    LblQtdeATFEncontrados: TLabel;
    LblQtdeSPEDEncontrados: TLabel;
    BtnATFAdicionar: TBitBtn;
    PopUpATF: TPopupMenu;
    MenuExcluirATF: TMenuItem;
    PopUpSPED: TPopupMenu;
    MenuExcluirSPED: TMenuItem;
    ppDBRelatorioValoresDivergentes: TppDBPipeline;
    DS_CVD: TDataSource;
    pprRelatorioChavesValoresDivergentes: TppReport;
    ppHeaderBand3: TppHeaderBand;
    ppShape3: TppShape;
    ppSystemVariable7: TppSystemVariable;
    ppLabel14: TppLabel;
    ppSystemVariable8: TppSystemVariable;
    ppSystemVariable9: TppSystemVariable;
    ppLabel15: TppLabel;
    PplTituloRelatorioVlrDivergente: TppLabel;
    ppLblTitulo01RelVlrDivergente: TppLabel;
    ppLblTitulo02RelVlrDivergente: TppLabel;
    ppLblSubTituloRelVlrDivergente: TppLabel;
    ppLabel35: TppLabel;
    ppLabel36: TppLabel;
    ppLine24: TppLine;
    ppLine25: TppLine;
    ppLine26: TppLine;
    ppLine27: TppLine;
    ppLabel37: TppLabel;
    ppLabel38: TppLabel;
    ppLabel39: TppLabel;
    ppLabel40: TppLabel;
    ppLabel41: TppLabel;
    ppLine38: TppLine;
    ppLabel31: TppLabel;
    ppDetailBand3: TppDetailBand;
    ppDBChaveAcessoVlrDivergente: TppDBText;
    ppLine28: TppLine;
    ppLine29: TppLine;
    ppLine30: TppLine;
    ppDBChaveValorVlrDivergente: TppDBText;
    ppLine31: TppLine;
    ppDBDataVlrDivergente: TppDBText;
    ppDBCNPJEmitenteVlrDivergente: TppDBText;
    ppDBNumeroVlrDivergente: TppDBText;
    ppLine32: TppLine;
    ppLine33: TppLine;
    ppLine35: TppLine;
    ppLine37: TppLine;
    ppDBChaveValorATFVlrDivergente: TppDBText;
    ppSummaryBand3: TppSummaryBand;
    ppLabel42: TppLabel;
    ppLabel43: TppLabel;
    ppLabel44: TppLabel;
    ppLabel45: TppLabel;
    ppLine36: TppLine;
    ppImage3: TppImage;
    ppLabel46: TppLabel;
    ppDesignLayers3: TppDesignLayers;
    ppDesignLayer3: TppDesignLayer;
    ppParameterList3: TppParameterList;
    ppDBCalc1: TppDBCalc;
    ppDBCalc2: TppDBCalc;
    ppDBCalc3: TppDBCalc;
    ppDBRelatorio: TppDBPipeline;
    pprRelatorioChavesNaoEncontradas: TppReport;
    ppHeaderBand1: TppHeaderBand;
    ppShape1: TppShape;
    ppSystemVariable3: TppSystemVariable;
    ppLabel11: TppLabel;
    ppSystemVariable5: TppSystemVariable;
    ppSystemVariable6: TppSystemVariable;
    ppLabel12: TppLabel;
    PplTituloRelatorio: TppLabel;
    ppLblTitulo01Rel: TppLabel;
    ppLblTitulo02Rel: TppLabel;
    ppLblSubTituloRel: TppLabel;
    ppLabel1: TppLabel;
    ppLabel2: TppLabel;
    ppLine8: TppLine;
    ppLine9: TppLine;
    ppLine10: TppLine;
    ppLine11: TppLine;
    ppLabel3: TppLabel;
    ppLabel4: TppLabel;
    ppLabel5: TppLabel;
    ppLabel6: TppLabel;
    ppLabel7: TppLabel;
    ppCrossTab1: TppCrossTab;
    ppDetailBand1: TppDetailBand;
    ppDBChaveAcesso: TppDBText;
    ppLine1: TppLine;
    ppLine2: TppLine;
    ppLine3: TppLine;
    ppDBChaveValor: TppDBText;
    ppLine4: TppLine;
    ppDBData: TppDBText;
    ppDBEmitente: TppDBText;
    ppDBNumero: TppDBText;
    ppLine5: TppLine;
    ppLine6: TppLine;
    ppLine7: TppLine;
    ppSummaryBand1: TppSummaryBand;
    ppLabel21: TppLabel;
    ppLabel22: TppLabel;
    ppLabel23: TppLabel;
    ppLabel24: TppLabel;
    ppLine34: TppLine;
    ppImage2: TppImage;
    ppLabel10: TppLabel;
    ppDesignLayers1: TppDesignLayers;
    ppDesignLayer1: TppDesignLayer;
    ppParameterList1: TppParameterList;
    DS_CDS: TDataSource;
    DS_SPED: TDataSource;
    pprRelatorioChavesNaoEncontradasSPED: TppReport;
    ppHeaderBand2: TppHeaderBand;
    ppShape2: TppShape;
    ppSystemVariable1: TppSystemVariable;
    ppLabel8: TppLabel;
    ppSystemVariable2: TppSystemVariable;
    ppSystemVariable4: TppSystemVariable;
    ppLabel9: TppLabel;
    PplTituloRelatorioSPED: TppLabel;
    ppLblTitulo01RelSPED: TppLabel;
    ppLblTitulo02RelSPED: TppLabel;
    ppLblSubTituloRelSPED: TppLabel;
    ppLabel16: TppLabel;
    ppLabel17: TppLabel;
    ppLine12: TppLine;
    ppLine13: TppLine;
    ppLine14: TppLine;
    ppLine15: TppLine;
    ppLabel18: TppLabel;
    ppLabel19: TppLabel;
    ppLabel20: TppLabel;
    ppLabel25: TppLabel;
    ppLabel26: TppLabel;
    ppDetailBand2: TppDetailBand;
    ppDBChaveAcessoSPED: TppDBText;
    ppLine16: TppLine;
    ppLine17: TppLine;
    ppLine18: TppLine;
    ppDBChaveValorSPED: TppDBText;
    ppLine19: TppLine;
    ppDBDataSPED: TppDBText;
    ppDBCNPJEmitenteSPED: TppDBText;
    ppDBNumeroSPED: TppDBText;
    ppLine20: TppLine;
    ppLine21: TppLine;
    ppLine22: TppLine;
    ppSummaryBand2: TppSummaryBand;
    ppLabel27: TppLabel;
    ppLabel28: TppLabel;
    ppLabel29: TppLabel;
    ppLabel30: TppLabel;
    ppLine23: TppLine;
    ppImage1: TppImage;
    ppLabel13: TppLabel;
    ppDesignLayers2: TppDesignLayers;
    ppDesignLayer2: TppDesignLayer;
    ppParameterList2: TppParameterList;
    ppDBRelatorioSPED: TppDBPipeline;
    ppDBCalc4: TppDBCalc;
    ppDBCalc5: TppDBCalc;
    ppDBCalc6: TppDBCalc;
    CDSChavesValoresDivergentes: TClientDataSet;
    CDSChavesNaoEncontradasSPED: TClientDataSet;
    CDSChavesValoresDivergenteschave_acesso: TStringField;
    CDSChavesValoresDivergenteschv_nfe: TStringField;
    CDSChavesValoresDivergentesnum_doc: TIntegerField;
    CDSChavesValoresDivergentesdata_emissao: TStringField;
    CDSChavesValoresDivergentesvalor_total_nfe: TFloatField;
    CDSChavesValoresDivergentesvl_doc: TFloatField;
    CDSChavesValoresDivergentesdiferenca: TFloatField;
    CDSChavesValoresDivergentesrazao_social: TStringField;
    CDSChavesNaoEncontradas: TClientDataSet;
    StringField1: TStringField;
    StringField2: TStringField;
    IntegerField1: TIntegerField;
    StringField3: TStringField;
    FloatField1: TFloatField;
    StringField4: TStringField;
    ppDBCalc7: TppDBCalc;
    ppDBCalc8: TppDBCalc;
    CkbRemoverDevolucaoPropria: TCheckBox;
    GbTipoNF: TGroupBox;
    CmbTipoNF: TComboBox;
    procedure ActFecharExecute(Sender: TObject);
    procedure ActLimparExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnGerarClick(Sender: TObject);
    procedure EdtIdATFKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EdtIdSPEDKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnATFAdicionarClick(Sender: TObject);
    procedure BtnSPEDAdicionarClick(Sender: TObject);
    procedure MenuExcluirATFClick(Sender: TObject);
    procedure MenuExcluirSPEDClick(Sender: TObject);
    procedure pprRelatorioChavesValoresDivergentesBeforePrint(Sender: TObject);
    procedure pprRelatorioChavesNaoEncontradasSPEDBeforePrint(Sender: TObject);
    procedure pprRelatorioChavesNaoEncontradasBeforePrint(Sender: TObject);
    procedure CmbTipoRelatorioChange(Sender: TObject);
  private
    { Private declarations }
    oListaSPED: TObjectList<TSPED>;
    oListaATF: TObjectList<TATF>;
    Procedure iniciaGridSPED();
    procedure carregaGridSPED();

    Procedure iniciaGridATF();
    procedure carregaGridATF();

    procedure gerarRelatorio;
    function montaSQLText: string;
  public
    { Public declarations }
  end;

var
  FrmRelatoriosComparativo: TFrmRelatoriosComparativo;

Const
  _ENTRADA = 1;
  _SAIDA = 2;

  _NAO_ENCONTRADOS_SPED = 0;
  _NAO_ENCONTRADOS_ATF = 1;
  _VALORES_DIVERGENTES = 2;

implementation

uses
  UnClasseUtils, UnClasseRegistroC100_Notas, UnFrmListarSPED, UnFrmListarATF, IBQuery, UnClassePool_BD_IB, UnConstantes,
  ppViewr, ppTypes, WinInet, UnClasseThread;

{$R *.dfm}

procedure TFrmRelatoriosComparativo.ActFecharExecute(Sender: TObject);
begin
  if Application.MessageBox('Os dados n�o salvos ser�o perdidos. Deseja continuar?','Aviso',mb_yesno + MB_ICONWARNING + MB_DEFBUTTON2) = id_yes then
    Close();
end;

procedure TFrmRelatoriosComparativo.ActLimparExecute(Sender: TObject);
begin
  RadioSaida.ItemIndex := 0;
  CmbTipoRelatorio.ItemIndex := 0;
  EdtIdSPED.Clear;
  EdtIdATF.Clear;
  DateATF.DateTime := now();
  DateSPEDInicial.DateTime := now();
  DateSPEDFinal.DateTime := now();

  oListaSPED := TObjectList<TSPED>.Create();
  oListaATF := TObjectList<TATF>.Create();
  iniciaGridSPED();
  iniciaGridATF();
  //EdtIdATF.SetFocus();
end;

procedure TFrmRelatoriosComparativo.BtnATFAdicionarClick(Sender: TObject);
  function validaArquivoATF(lListaATF: TObjectlist<TATF>): TObjectlist<TATF>;
  var
    i, y: integer;
    auxATF: TATF;
    flag: boolean;
  begin
    result := TObjectlist<TATF>.Create();

    for i :=  lListaATF.Count - 1 downto 0 do
    begin
      auxATF := lListaATF[i];
      //verificar se o ATF j� foi inserido na lista
      flag:= false;
      for y :=  oListaATF.Count - 1 downto 0 do
      begin
        if (oListaATF[y].Id_ATF = auxATF.id_atf) then
        begin
          flag:= true;
          break;
        end;
      end;

      //caso n�o exista na lista adiciona o arquivo
      if flag = false then
        result.Add(auxATF);
    end;
  end;
begin
  try
    FrmListarATF := TFrmListarATF.Create(Self);
    FrmListarATF.ShowModal();
    if FrmListarATF.oATFSelecionado.Id_ATF <> 0 then
    begin
      EdtIdATF.Text := IntToStr(FrmListarATF.oATFSelecionado.Id_ATF);
      DateATF.DateTime := FrmListarATF.oATFSelecionado.DataEmissao;
      //if Application.MessageBox('Deseja Inserir Arquivo ATF a Lista?','Inserir',mb_yesno + MB_ICONWARNING + MB_DEFBUTTON1) = id_yes then
      //begin
        oListaATF.AddRange(validaArquivoATF(FrmListarATF.oListaATFSelecionados));
        carregaGridATF();
      //end;
    end;
  finally
    FreeAndNil(FrmListarATF);
  end;
end;

procedure TFrmRelatoriosComparativo.BtnGerarClick(Sender: TObject);
  function verificaCamposAntesImpressao(): boolean;
  begin
    result := true;

    if oListaSPED.Count = 0 then
    begin
      Application.MessageBox('Insira Arquivos SPED','Erro',MB_OKCANCEL + MB_ICONERROR);
      result := false;
      exit;
    end;

    if oListaATF.Count = 0 then
    begin
      Application.MessageBox('Insira Arquivos ATF','Erro',MB_OKCANCEL + MB_ICONERROR);
      result := false;
      exit;
    end;

    if oListaATF.Count + oListaSPED.Count > 12 then
    begin
      if Application.MessageBox('Muitos Arquivos Selecionados De Uma Vez. Deseja continuar?','Aviso - Performance',mb_yesno + MB_ICONWARNING) <> id_yes then
      begin
        result := false;
        exit;
      end;
    end;
  end;
begin
  if verificaCamposAntesImpressao() then
  begin
    executarThread(gerarRelatorio);
    //gerarRelatorio();

    //salvar banco de dados
    {try
      oNovoSPED.Id_SPED:= oNovoSPED.salvar();
      ShowMessage('SPED Salvo com Sucesso!');
      //retorna ao estado inicial
      FormShow(self);
    except on E: Exception do
      ShowMessage('N�o foi poss�vel salvar o SPED!' + #13 +
                  'Mensagem de Erro: ' + E.Message);
    end;}
  end;
end;

function TFrmRelatoriosComparativo.montaSQLText: string;
var
  i: integer;
  auxSPED, auxATF: string;
begin
  //string responsavel por filtrar a pesquisa aos arquivos speds selecionados
  if oListaSPED.Count > 0 then
  begin
    for I := 0 to oListaSPED.Count - 1 do
    begin
      if i = 0 then
        auxSPED := auxSPED + ' AND (s.id_sped = ' + QuotedStr(IntToStr(oListaSPED[i].Id_SPED))
      else
        auxSPED := auxSPED + ' OR s.id_sped = ' + QuotedStr(IntToStr(oListaSPED[i].Id_SPED));
    end;
    auxSPED := auxSPED + ')';
  end;

  //string responsavel por filtrar a pesquisa aos arquivos ATF selecionados
  if oListaSPED.Count > 0 then
  begin
    for I := 0 to oListaATF.Count - 1 do
    begin
      if i = 0 then
        auxATF := auxATF + ' AND (a.id_ATF = ' + QuotedStr(IntToStr(oListaATF[i].Id_ATF))
      else
        auxATF := auxATF + ' OR a.id_ATF = ' + QuotedStr(IntToStr(oListaATF[i].Id_ATF));
    end;
    auxATF := auxATF + ')';
  end;

  //Relatorio de DADOS DO ATF QUE N�O FORAM ENCONTRADOS NO SPED
  if CmbTipoRelatorio.ItemIndex = _NAO_ENCONTRADOS_SPED then
  begin
    result:=     ' SELECT          a.CHAVE_ACESSO,' +
                 '                 s.chv_nfe,' +
                 '                 a.NUM_DOC ,' +
                 '                 a.valor_total_nota,' +
                 '                 a.DATA_EMISSAO,' +
                 '                 a.RAZAO_SOCIAL,' +
                 '                 e.CNPJ' +
                 ' FROM atf_notas a' +
                 ' LEFT JOIN atf_emitente e on e.id_ATF = a.id_ATF' +
                 ' LEFT JOIN rc100_notas s ON s.CHV_NFE = a.chave_acesso' +
                 '                         AND s.cod_mod = ' + QuotedStr('55') +
                                           auxSPED;

    result:= result + ' WHERE s.chv_nfe is null' +
                      auxATF;
  end
  //Relatorio de DADOS DO SPED QUE N�O FORAM ENCONTRADOS NO ATF
  else if CmbTipoRelatorio.ItemIndex = _NAO_ENCONTRADOS_ATF then
  begin
    result:=     ' SELECT          s.CHV_NFE as CHAVE_ACESSO,' +
                 '                 s.CHV_NFE,' +
                 '                 s.NUM_DOC ,' +
                 '                 s.vl_doc as VALOR_TOTAL_NOTA,' +
                 '                 e.DATA_INICIAL as DATA_EMISSAO,' +
                 '                 e.NOME_EMPRESA as RAZAO_SOCIAL,' +
                 '                 e.CNPJ' +
                 ' FROM rc100_notas s' +
                 ' LEFT JOIN R0000_emitente e on e.id_SPED = s.id_SPED' +
                 ' LEFT JOIN R0150_participantes p ON p.cod_part = s.cod_part' +
                 '                                 AND p.id_SPED = s.id_SPED' +
                 ' LEFT JOIN ATF_NOTAS a on a.chave_acesso = s.CHV_NFE' +
                                            auxATF;

    result := result + ' WHERE s.cod_mod = ' + Quotedstr('55') +
                       ' AND a.chave_acesso is null' +
                       auxSPED;
  end
  //Relatorio de Valores Divergentes
  else if CmbTipoRelatorio.ItemIndex = _VALORES_DIVERGENTES then
  begin
    result:=     ' SELECT          a.CHAVE_ACESSO,' +
                 '                 a.NUM_DOC ,' +
                 '                 a.valor_total_nota,' +
                 '                 s.vl_doc,' +
                 '                 s.vl_doc - a.valor_total_nota as DIFERENCA,' +
                 '                 a.DATA_EMISSAO,' +
                 '                 e.RAZAO_SOCIAL,' +
                 '                 e.CNPJ' +
                 ' FROM ATF_NOTAS a' +
                 ' LEFT JOIN atf_emitente e on e.id_ATF = a.id_ATF' +
                 ' LEFT JOIN RC100_NOTAS s on a.chave_acesso = s.CHV_NFE' +
                 '                          AND s.cod_mod = ' + QuotedStr('55') +
                                            auxSPED;

    result := result + ' WHERE a.valor_total_nota <> s.vl_doc' +
                       auxATF;

  end;

  //remove resultados de devolu��o propria (emitente e destinatario s�o o mesmo CNPJ)
  if (CkbRemoverDevolucaoPropria.Checked) then
  begin
    if (CmbTipoRelatorio.ItemIndex = _NAO_ENCONTRADOS_ATF) then //caso a tabela principal seja RC100_NOTAS
      result := result + ' AND e.cnpj <> p.cnpj'
    else //caso a tabela principal seja ATF_NOTAS
      result := result + ' AND a.cnpj <> a.CPF_CNPJ_DEST';
  end;

  //filtra notas por entrada ou saida
  if CmbTipoNF.ItemIndex = _SAIDA then
    result := result + ' AND s.ind_oper = ' + QuotedStr('1')
  else if CmbTipoNF.ItemIndex = _ENTRADA then
    result := result + ' AND s.ind_oper = ' + QuotedStr('0');

  //result := result + ' AND s.chv_nfe <> ' + QuotedStr('');

end;

procedure TFrmRelatoriosComparativo.gerarRelatorio;
var
  query: TIBQuery;
  auxCaminhoArqSPED, auxCaminhoArqATF: string;

  function retornaCaminhoArqSPED: string;
  var
    i: integer;
  begin
    //filtra arquivos speds selecionados
    for I := 0 to oListaSPED.Count - 1 do
        result := result + oListaSPED[i].Arquivo + ' [' + IntToStr(oListaSPED[i].Id_SPED) + '], ';
  end;
  function retornaCaminhoArqATF: string;
  var
    i: integer;
  begin
    //filtra arquivos atf selecionados
    for I := 0 to oListaATF.Count - 1 do
        result := result + oListaATF[i].Arquivo + ' [' + IntToStr(oListaATF[i].Id_ATF) + '], ';
  end;
begin
  query := PoolDeConexoes.getConexao(_BD_COMPARA_FISCAL).createNewQuery();
  try
    with query do
    begin
      SQL.Text := montaSQLText();
      
      Screen.Cursor := crHourGlass;
      Open;
      if not IsEmpty then
      begin
        CDSChavesValoresDivergentes.Close;
        CDSChavesValoresDivergentes.CreateDataSet;
        CDSChavesNaoEncontradas.Close;
        CDSChavesNaoEncontradas.CreateDataSet;

        query.First();
        while not query.Eof do
        begin
          //relatorio de valores divergentes
          if CmbTipoRelatorio.ItemIndex = 2 then
          begin
            CDSChavesValoresDivergentes.Append;
            CDSChavesValoresDivergentes.FieldByName('chave_acesso').AsString := FieldByName('chave_acesso').AsString;
            CDSChavesValoresDivergentes.FieldByName('num_doc').AsString := FieldByName('num_doc').AsString;
            CDSChavesValoresDivergentes.FieldByName('data_emissao').AsString := FieldByName('data_emissao').AsString;
            CDSChavesValoresDivergentes.FieldByName('vl_doc').AsString := FieldByName('vl_doc').AsString;
            CDSChavesValoresDivergentes.FieldByName('valor_total_nota').AsString := FieldByName('valor_total_nota').AsString;
            CDSChavesValoresDivergentes.FieldByName('diferenca').AsString := FieldByName('diferenca').AsString;
            CDSChavesValoresDivergentes.FieldByName('RAZAO_SOCIAL').AsString := FieldByName('RAZAO_SOCIAL').AsString;
            CDSChavesValoresDivergentes.Post;
          end
          else
          begin
            CDSChavesNaoEncontradas.Append;
            CDSChavesNaoEncontradas.FieldByName('chave_acesso').AsString := FieldByName('chave_acesso').AsString;
            CDSChavesNaoEncontradas.FieldByName('chv_nfe').AsString := FieldByName('chv_nfe').AsString;
            CDSChavesNaoEncontradas.FieldByName('num_doc').AsString := FieldByName('num_doc').AsString;
            CDSChavesNaoEncontradas.FieldByName('data_emissao').AsString := FieldByName('data_emissao').AsString;
            CDSChavesNaoEncontradas.FieldByName('valor_total_nota').AsString := FieldByName('valor_total_nota').AsString;
            CDSChavesNaoEncontradas.FieldByName('RAZAO_SOCIAL').AsString := FieldByName('RAZAO_SOCIAL').AsString;
            CDSChavesNaoEncontradas.Post;
          end;

          query.Next();
        end;

        //preenche os caminhos dos arquivos e os respectivos ids dos documentos
        auxCaminhoArqATF := retornaCaminhoArqATF();
        auxCaminhoArqSPED := retornaCaminhoArqSPED();

        //preenche informa��es do relatorio e imprime
        if CmbTipoRelatorio.ItemIndex = 0 then
        begin
          PplTituloRelatorio.Caption := oListaSPED[0].Registro0000.NomeEmpresa;
          ppLabel2.Caption := 'RELAT�RIO GERENCIAL - CONTABILIDADE';
          ppLblTitulo01Rel.Caption := 'Arquivos .txt ATF: ' + auxCaminhoArqATF;
          ppLblTitulo02Rel.Caption := 'Arquivos .txt SPED: ' + auxCaminhoArqSPED;
          ppLblSubTituloRel.Caption := 'Quantidade de Chave(s) de Acesso n�o encontrada(s) no .txt SPED: ';

          CDSChavesNaoEncontradas.Open();
          //DS_CDS.DataSet := query;
          ppDBRelatorio.DataSource := DS_CDS;
          ppDBRelatorio.OpenDataSource := True;
          pprRelatorioChavesNaoEncontradas.Print;
        end
        else if CmbTipoRelatorio.ItemIndex = 1 then
        begin
          PplTituloRelatorioSPED.Caption := oListaSPED[0].Registro0000.NomeEmpresa;
          ppLabel17.Caption := 'RELAT�RIO GERENCIAL - CONTABILIDADE';
          ppLblTitulo01RelSPED.Caption := 'Arquivos .txt ATF: ' + auxCaminhoArqATF;
          ppLblTitulo02RelSPED.Caption := 'Arquivos .txt SPED: ' + auxCaminhoArqSPED;
          ppLblSubTituloRelSPED.Caption := 'Quantidade de Chave(s) de Acesso n�o encontrada(s) no .txt ATF :';

          CDSChavesNaoEncontradas.Open();
          //DS_SPED.DataSet := query;
          ppDBRelatorioSPED.DataSource := DS_SPED;
          ppDBRelatorioSPED.OpenDataSource := True;
          pprRelatorioChavesNaoEncontradasSPED.Print;
        end
        else if CmbTipoRelatorio.ItemIndex = 2 then
        begin
          PplTituloRelatorioVlrDivergente.Caption := oListaSPED[0].Registro0000.NomeEmpresa;
          ppLabel36.Caption := 'RELAT�RIO GERENCIAL - CONTABILIDADE';
          ppLblTitulo01RelVlrDivergente.Caption := 'Arquivos .txt ATF: ' + auxCaminhoArqATF;
          ppLblTitulo02RelVlrDivergente.Caption := 'Arquivos .txt SPED: ' + auxCaminhoArqSPED;
          ppLblSubTituloRelVlrDivergente.Caption := 'Quantidade de Chave(s) de Acesso encontrada(s) com Valores Divergentes do .txt da Receita Estadual: ';

          CDSChavesValoresDivergentes.Open();
          //DS_CVD.DataSet := query;
          ppDBRelatorioValoresDivergentes.DataSource := DS_CVD;
          ppDBRelatorioValoresDivergentes.OpenDataSource := true;
          pprRelatorioChavesValoresDivergentes.Print;
        end;
      end
      else
      begin
        Application.MessageBox('Nenhum Resultado Foi Encontrado!', 'Aten��o', MB_ICONWARNING + MB_OK);
        CmbTipoRelatorio.SetFocus();
      end;
      Close;
    end;
  finally
    FreeAndNil(query);
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrmRelatoriosComparativo.pprRelatorioChavesNaoEncontradasBeforePrint(
  Sender: TObject);
begin
  TppViewer(pprRelatorioChavesNaoEncontradas.PreviewForm.Viewer).ZoomPercentage := 100;
  TppViewer(pprRelatorioChavesNaoEncontradas.PreviewForm.Viewer).ZoomSetting :=  zsPageWidth;
  pprRelatorioChavesNaoEncontradas.PreviewForm.WindowState:= wsMaximized;
end;

procedure TFrmRelatoriosComparativo.pprRelatorioChavesNaoEncontradasSPEDBeforePrint(
  Sender: TObject);
begin
  TppViewer(pprRelatorioChavesNaoEncontradasSPED.PreviewForm.Viewer).ZoomPercentage := 100;
  TppViewer(pprRelatorioChavesNaoEncontradasSPED.PreviewForm.Viewer).ZoomSetting :=  zsPageWidth;
  pprRelatorioChavesNaoEncontradasSPED.PreviewForm.WindowState:= wsMaximized;
end;

procedure TFrmRelatoriosComparativo.pprRelatorioChavesValoresDivergentesBeforePrint(
  Sender: TObject);
begin
  TppViewer(pprRelatorioChavesValoresDivergentes.PreviewForm.Viewer).ZoomPercentage := 100;
  TppViewer(pprRelatorioChavesValoresDivergentes.PreviewForm.Viewer).ZoomSetting :=  zsPageWidth;
  pprRelatorioChavesValoresDivergentes.PreviewForm.WindowState:= wsMaximized;
end;

procedure TFrmRelatoriosComparativo.BtnSPEDAdicionarClick(Sender: TObject);
  function validaArquivoSPED(lListaSPED: TObjectlist<TSPED>): TObjectlist<TSPED>;
  var
    i, y: integer;
    auxSPED: TSPED;
    flag: boolean;
  begin
    result := TObjectlist<TSPED>.Create();

    for i :=  lListaSPED.Count - 1 downto 0 do
    begin
      auxSPED := lListaSPED[i];
      //verificar se o SPED j� foi inserido na lista
      flag:= false;
      for y :=  oListaSPED.Count - 1 downto 0 do
      begin
        if (oListaSPED[y].Id_SPED = auxSPED.id_SPED) then
        begin
          flag:= true;
          break;
        end;
      end;

      //caso n�o exista na lista adiciona o arquivo
      if flag = false then
        result.Add(auxSPED);
    end;
  end;
begin
  try
    FrmListarSPED := TFrmListarSPED.Create(Self);
    FrmListarSPED.ShowModal();
    if FrmListarSPED.oSPEDSelecionado.Id_SPED <> 0 then
    begin
      EdtIdSPED.Text := IntToStr(FrmListarSPED.oSPEDSelecionado.Id_SPED);
      DateSPEDInicial.DateTime := StrToDate(converteFormatoData(FrmListarSPED.oSPEDSelecionado.Registro0000.DataInicial));
      DateSPEDFinal.DateTime := StrToDate(converteFormatoData(FrmListarSPED.oSPEDSelecionado.Registro0000.DataFinal));
      //if Application.MessageBox('Deseja Inserir Arquivo SPED a Lista?','Inserir',mb_yesno + MB_ICONWARNING + MB_DEFBUTTON1) = id_yes then
      //begin
        oListaSPED.AddRange(validaArquivoSPED(FrmListarSPED.oListaSPEDSelecionado));
        carregaGridSPED();
      //end;
    end;
  finally
    FreeAndNil(FrmListarSPED);
  end;
  //EdtIdSPED.SetFocus();
end;

procedure TFrmRelatoriosComparativo.FormShow(Sender: TObject);
begin
  //limpa a tela
  ActLimparExecute(self);
end;

Procedure TFrmRelatoriosComparativo.iniciaGridSPED();
begin
  limparGrid(StgSPED, 1);

  with StgSPED do
  begin
    FixedCols:= 0;

    Cells[1, 0]:= 'ID SPED';
    Cells[2, 0]:= 'CNPJ';
    Cells[3, 0]:= 'Emitente';
    Cells[4, 0]:= 'Periodo Inicial';
    Cells[5, 0]:= 'Periodo Final';
    Cells[6, 0]:= 'Entrada';
  end;

end;

procedure TFrmRelatoriosComparativo.MenuExcluirATFClick(Sender: TObject);
var
  i: integer;
begin
  for I := 0 to oListaATF.Count - 1 do
  begin
    if StgATF.Cells[1, StgATF.Row] = IntToStr(oListaATF[i].Id_ATF) then
    begin
      oListaATF.Delete(i);
      carregaGridATF();
      break;
    end;
  end;
end;

procedure TFrmRelatoriosComparativo.MenuExcluirSPEDClick(Sender: TObject);
var
  i: integer;
begin
  for I := 0 to oListaSPED.Count - 1 do
  begin
    if StgSPED.Cells[1, StgSPED.Row] = IntToStr(oListaSPED[i].Id_SPED) then
    begin
      oListaSPED.Delete(i);
      carregaGridSPED();
      break;
    end;
  end;
end;

Procedure TFrmRelatoriosComparativo.iniciaGridATF();
begin
  limparGrid(StgATF, 1);

  with StgATF do
  begin
    FixedCols:= 0;

    Cells[1, 0]:= 'ID ATF';
    Cells[2, 0]:= 'CNPJ';
    Cells[3, 0]:= 'Emitente';
    Cells[4, 0]:= 'Periodo Inicial';
    Cells[5, 0]:= 'Entrada';
  end;

end;

procedure TFrmRelatoriosComparativo.carregaGridATF();
var
  i: Integer;
  auxValor: double;
  auxQtde: integer;
begin
  limparGrid(StgATF, 1);
  auxValor:= 0;
  auxQtde:= 0;

  with StgATF do
  begin
    auxQtde := oListaATF.Count;
    if oListaATF.Count = 0 then
    begin
      StgATF.RowCount:= 2;
      LblQtdeATFEncontrados.Caption:= 'Nenhum ATF Encontrado';
    end
    else
      StgATF.RowCount:= oListaATF.Count + 1;

    for i:= 0 to oListaATF.Count - 1 do
    begin
      Cells[1, i + 1]:= IntToStr(oListaATF[i].Id_ATF);
      Cells[2, i + 1]:= oListaATF[i].Emitente.CNPJ;
      Cells[3, i + 1]:= oListaATF[i].Emitente.NomeEmpresa;
      Cells[4, i + 1]:= FormatDateTime('dd/mm/yyyy', oListaATF[i].DataEmissao);
      Cells[5, i + 1]:= FormatDateTime('dd/mm/yyyy hh:nn', oListaATF[i].dataentrada);
    end;

  end;
  //atualiza informa��o de totais
  LblQtdeATFEncontrados.Caption:= IntToStr(auxQtde) + ' ATF(s) encontrado(s)';
end;

procedure TFrmRelatoriosComparativo.carregaGridSPED();
var
  i: Integer;
  auxValor: double;
  auxQtde: integer;
begin
  limparGrid(StgSPED, 1);
  auxValor:= 0;
  auxQtde:= 0;

  with StgSPED do
  begin
    auxQtde := oListaSPED.Count;
    if oListaSPED.Count = 0 then
    begin
      StgSPED.RowCount:= 2;
      LblQtdeSPEDEncontrados.Caption:= 'Nenhum SPED Encontrado';
    end
    else
      StgSPED.RowCount:= oListaSPED.Count + 1;

    for i:= 0 to oListaSPED.Count - 1 do
    begin
      Cells[1, i + 1]:= IntToStr(oListaSPED[i].Id_SPED);
      Cells[2, i + 1]:= oListaSPED[i].Registro0000.CNPJ;
      Cells[3, i + 1]:= oListaSPED[i].Registro0000.NomeEmpresa;
      Cells[4, i + 1]:= converteFormatoData(oListaSPED[i].Registro0000.DataInicial);
      Cells[5, i + 1]:= converteFormatoData(oListaSPED[i].Registro0000.DataFinal);
      Cells[6, i + 1]:= FormatDateTime('dd/mm/yyyy hh:nn', oListaSPED[i].dataentrada);
    end;

  end;
  //atualiza informa��o de totais
  LblQtdeSPEDEncontrados.Caption:= IntToStr(auxQtde) + ' SPED(s) encontrado(s)';
end;

procedure TFrmRelatoriosComparativo.CmbTipoRelatorioChange(Sender: TObject);
begin
  {if CmbTipoRelatorio.ItemIndex = 0 then
    CkbRemoverDevolucaoPropria.Visible := true
  else
    CkbRemoverDevolucaoPropria.Visible := false;}
end;

procedure TFrmRelatoriosComparativo.EdtIdATFKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case key of
    VK_RETURN :
      BtnATFAdicionar.SetFocus();
  end;
end;

procedure TFrmRelatoriosComparativo.EdtIdSPEDKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case key of
    VK_RETURN :
      BtnSPEDAdicionar.SetFocus();
  end;
end;

end.
