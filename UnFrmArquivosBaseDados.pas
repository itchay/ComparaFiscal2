unit UnFrmArquivosBaseDadosATF;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  System.Actions, Vcl.ActnList, Vcl.Grids, Vcl.ComCtrls, UnClasseSPED, System.IOUtils;

type
  TFrmArquivosBaseDadosATF = class(TForm)
    OpdCaminhoATF: TOpenDialog;
    ActionList1: TActionList;
    ActFechar: TAction;
    PnlBotoes: TPanel;
    BtnNovo: TBitBtn;
    BtnSalvar: TBitBtn;
    BtnListar: TBitBtn;
    PnlInfoDoc: TPanel;
    Label1: TLabel;
    EdtCaminhoArqATF: TEdit;
    SpbCaminhoArqReceita: TSpeedButton;
    SpbCaminhoArqATF: TSpeedButton;
    GroupBox1: TGroupBox;
    DateInicial: TDateTimePicker;
    GroupBox4: TGroupBox;
    EdtCodigoDocumento: TEdit;
    GroupBox3: TGroupBox;
    DateFinal: TDateTimePicker;
    Label2: TLabel;
    LblRazaoSocial: TLabel;
    StgSPED: TStringGrid;
    GroupBox5: TGroupBox;
    SpeedButton2: TSpeedButton;
    BtnExcluir: TBitBtn;
    ActLimpar: TAction;
    LblQtdeEncontradas: TLabel;
    LblTotalEncontradas: TLabel;
    procedure ActFecharExecute(Sender: TObject);
    procedure ActLimparExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpbCaminhoArqATFClick(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
    procedure BtnSalvarClick(Sender: TObject);
    procedure BtnNovoClick(Sender: TObject);
    procedure BtnListarClick(Sender: TObject);
    procedure BtnExcluirClick(Sender: TObject);
  private
    { Private declarations }
    oNovoSPED: TSPED;
    Procedure iniciaGridSPED();
    procedure carregaSPEDTela;
    procedure carregaGridSPED();
    procedure bloqueiaLiberaTela(lLibera: boolean);
    procedure bloqueiaLiberaBotoes(lNovo, lSalvar, lListar, lExcluir: boolean);

    function validaArquivoSPED(caminhoArquivo: String): Boolean;
    function carregaRegistroArquivoSPED(linha: String): Boolean;
  public
    { Public declarations }
  end;

var
  FrmArquivosSPED: TFrmArquivosBaseDadosATF;

implementation

uses
  UnClasseUtils, UnClasseRegistroC100_Notas, UnFrmListarSPED;

{$R *.dfm}

procedure TFrmArquivosSPED.ActFecharExecute(Sender: TObject);
begin
  if Application.MessageBox('Os dados n�o salvos ser�o perdidos. Deseja continuar?','Aviso',mb_yesno + MB_ICONWARNING + MB_DEFBUTTON2) = id_yes then
    Close();
end;

procedure TFrmArquivosSPED.ActLimparExecute(Sender: TObject);
begin
  oNovoSPED := TSPED.Create();
  iniciaGridSPED();
  EdtCaminhoArqSPED.Text := '...';
  EdtCodigoDocumento.Clear;
  LblRazaoSocial.Caption := '...';
  DateInicial.DateTime := now();
  DateFinal.DateTime := now();
end;

procedure TFrmArquivosSPED.BtnCancelarClick(Sender: TObject);
begin
  if Application.MessageBox('Os dados n�o salvos ser�o perdidos. Deseja continuar?','Aviso',mb_yesno + MB_ICONWARNING) = id_yes then
    ActLimparExecute(self);
end;

procedure TFrmArquivosSPED.BtnExcluirClick(Sender: TObject);
begin
  //salvar banco de dados
  try
    oNovoSPED.excluir();
    ShowMessage('SPED removido com Sucesso!');
    //retorna ao estado inicial
    FormShow(self);
  except on E: Exception do
    ShowMessage('N�o foi poss�vel excluir o SPED!' + #13 +
                'Mensagem de Erro: ' + E.Message);
  end;
end;

procedure TFrmArquivosSPED.BtnListarClick(Sender: TObject);
begin
  try
    FrmListarSPED := TFrmListarSPED.Create(Self);
    FrmListarSPED.ShowModal();
    if FrmListarSPED.oSPEDSelecionado.Id_SPED <> 0 then
    begin
      ActLimparExecute(Self);
      bloqueiaLiberaTela(true);
      bloqueiaLiberaBotoes(true, false, true, true);
      FrmArquivosSPED.Caption := '[Consulta] Arquivos - SPED';

      oNovoSPED := FrmListarSPED.oSPEDSelecionado;
      carregaSPEDTela();
    end;
  finally
    FreeAndNil(FrmListarSPED);
  end;
end;

procedure TFrmArquivosSPED.BtnNovoClick(Sender: TObject);
begin
  if (oNovoSPED.Arquivo <> '')
  AND(Application.MessageBox('Os dados n�o salvos ser�o perdidos. Deseja continuar?','Aviso',mb_yesno + MB_ICONWARNING) <> id_yes) then
    exit;
  ActLimparExecute(Self);
  bloqueiaLiberaTela(true);
  bloqueiaLiberaBotoes(true, true, true, false);
  FrmArquivosSPED.Caption := '[Novo] Arquivos - SPED';
end;

procedure TFrmArquivosSPED.BtnSalvarClick(Sender: TObject);
begin
  //salvar banco de dados
  try
    oNovoSPED.Id_SPED:= oNovoSPED.salvar();
    ShowMessage('SPED Salvo com Sucesso!');
    //retorna ao estado inicial
    FormShow(self);
  except on E: Exception do
    ShowMessage('N�o foi poss�vel salvar o SPED!' + #13 +
                'Mensagem de Erro: ' + E.Message);
  end;
end;

procedure TFrmArquivosSPED.FormShow(Sender: TObject);
begin
  //limpa a tela
  ActLimparExecute(self);
  BloqueiaLiberaTela(false);
  BloqueiaLiberaBotoes(true, false, true, false);
  FrmArquivosSPED.Caption := 'Arquivos - SPED';
end;

procedure TFrmArquivosSPED.bloqueiaLiberaTela(lLibera: boolean);
begin
  SpbCaminhoArqSPED.Enabled := lLibera;
end;

procedure TFrmArquivosSPED.bloqueiaLiberaBotoes(lNovo, lSalvar, lListar, lExcluir: boolean);
begin
  BtnNovo.Enabled := lNovo;
  BtnSalvar.Enabled := lSalvar;
  BtnListar.Enabled := lListar;
  BtnExcluir.Enabled := lExcluir;
end;

Procedure TFrmArquivosSPED.iniciaGridSPED();
begin
  limparGrid(StgSPED);

  with StgSPED do
  begin
    FixedCols:= 0;

    Cells[1, 0]:= 'Serie Documento';
    Cells[2, 0]:= 'N�mero Documento';
    Cells[3, 0]:= 'Chave de Acesso';
    Cells[4, 0]:= 'Data Emiss�o';
    Cells[5, 0]:= 'Tipo Operacao';
    Cells[6, 0]:= 'Valor Total';
  end;

  carregaGridSPED();
end;

procedure TFrmArquivosSPED.SpbCaminhoArqSPEDClick(Sender: TObject);
var
  arquivo: TextFile;
  linha: String;
  i:integer;
begin
  ActLimparExecute(Self);
  try
    Cursor := crHourGlass;
    if OpdCaminhoSPED.Execute then
    begin
      if validaArquivoSPED(OpdCaminhoSPED.FileName) then
      begin
        AssignFile(arquivo, OpdCaminhoSPED.FileName);
        Reset(arquivo);
        Application.ProcessMessages();
        while not Eof(arquivo) do
        begin
          Readln(arquivo, linha);
          carregaRegistroArquivoSPED(linha);
        end;
        CloseFile(arquivo);

        oNovoSPED.CaminhoArquivo := OpdCaminhoSPED.FileName;
        oNovoSPED.Arquivo := TPath.GetFileName(OpdCaminhoSPED.FileName);
        carregaSPEDTela();
      end
      else
      begin
        //if oListaChaveAcessoArqSPED <> Nil then
          //FreeAndNil(oListaChaveAcessoArqSPED);
        Application.MessageBox('Arquivo .txt a ser comparado (SPED) n�o possui estrutura de um arquivo SPED!' + #13 +
                               'Por favor selecione um arquivo .txt no formato de SPED',
                               'Aten��o', MB_ICONWARNING + MB_OK);
        SpbCaminhoArqSPEDClick(Self);
      end;
    end
    else
    begin
      //if oListaChaveAcessoArqSPED <> Nil then
        //FreeAndNil(oListaChaveAcessoArqSPED);
      //EdtCaminhoArqSPED.Text := '...';
    end;
  finally
    Cursor := crDefault;
  end;
end;

function TFrmArquivosSPED.validaArquivoSPED(caminhoArquivo: String): Boolean;
var
  arquivo: TextFile;
  linha: String;
begin
  Result := False;

  //Ler primeira linha do arquivo
  AssignFile(arquivo, caminhoArquivo);
  Reset(arquivo);
  Readln(arquivo, linha);

  Result := ((Trim(linha) <> '') and (Copy(linha, 1, 6) = '|0000|'));
end;

procedure TFrmArquivosSPED.carregaSPEDTela;
begin
  EdtCaminhoArqSPED.Text := oNovoSPED.CaminhoArquivo;
  EdtCodigoDocumento.Text := IntToStr(oNovoSPED.Id_SPED);
  LblRazaoSocial.Caption := oNovoSPED.Registro0000.NomeEmpresa;
  DateInicial.DateTime := StrToDate(converteFormatoData(oNovoSPED.Registro0000.DataInicial));
  DateFinal.DateTime := StrToDate(converteFormatoData(oNovoSPED.Registro0000.DataFinal));

  carregaGridSPED();
end;

procedure TFrmArquivosSPED.carregaGridSPED();
var
  i: Integer;
  auxValor: double;
  auxQtde: integer;
begin
  limparGrid(StgSPED);
  auxValor:= 0;
  auxQtde:= 0;

  with StgSPED do
  begin
    auxQtde := oNovoSPED.ListaRegistrosC100.Count;
    if oNovoSPED.ListaRegistrosC100.Count = 0 then
    begin
      StgSPED.RowCount:= 2;
      LblQtdeC100Encontradas.Caption:= 'Nenhum Registro Encontrado';
      LblTotalC100Encontradas.Caption:= 'Valor Total: R$ 0,00';
    end
    else
      StgSPED.RowCount:= oNovoSPED.ListaRegistrosC100.Count + 1;

    for i:= 0 to oNovoSPED.ListaRegistrosC100.Count - 1 do
    begin
      Cells[1, i + 1]:= oNovoSPED.ListaRegistrosC100[i].Ser;
      Cells[2, i + 1]:= oNovoSPED.ListaRegistrosC100[i].Num_Doc;
      Cells[3, i + 1]:= oNovoSPED.ListaRegistrosC100[i].Chv_Nfe;
      Cells[4, i + 1]:= converteFormatoData(oNovoSPED.ListaRegistrosC100[i].Dt_Doc);

      if oNovoSPED.ListaRegistrosC100[i].Ind_Oper = '0' then
        Cells[5, i + 1]:= 'Entrada'
      else
        Cells[5, i + 1]:= 'Saida';

      Cells[6, i + 1]:= retiraCaractere('.',oNovoSPED.ListaRegistrosC100[i].Vl_Doc);

      if oNovoSPED.ListaRegistrosC100[i].Vl_Doc <> '' then
        auxValor := auxValor + StrToFloat(oNovoSPED.ListaRegistrosC100[i].Vl_Doc);
    end;

  end;
  //atualiza informa��o de totais
  LblQtdeC100Encontradas.Caption:= IntToStr(auxQtde) + ' Registro(s) encontrada(s)';
  LblTotalC100Encontradas.Caption:= 'Valor Total: R$ ' + FloatToStrF(auxValor,ffnumber,10,02);
end;

function TFrmArquivosSPED.carregaRegistroArquivoSPED(linha: String): Boolean;
var
  auxLinhaRestante: string;
  auxColuna: string;
  i: integer;
  auxEmpresa: string;
  auxC100: TRegistroC100;
begin
  i:= 0;
  auxLinhaRestante:= linha;

  if Copy(linha, 1, 6) = '|0000|' then
  begin
    while(i <= 15) do
    begin
       auxLinhaRestante := Copy(auxLinhaRestante, Pos('|', auxLinhaRestante) + 1, Length(auxLinhaRestante) - (Pos('|', auxLinhaRestante)));
       auxColuna := Copy(auxLinhaRestante, 1, Pos('|', auxLinhaRestante) -1);

       case i of
          1: oNovoSPED.Registro0000.CodigoVersaoLeiaute := auxColuna;
          2: oNovoSPED.Registro0000.CodigoFinalidadeArquivo := StrToInt(auxColuna);
          3: oNovoSPED.Registro0000.DataInicial := auxColuna;
          4: oNovoSPED.Registro0000.DataFinal := auxColuna;
          5: oNovoSPED.Registro0000.NomeEmpresa := auxColuna;
          6: oNovoSPED.Registro0000.CNPJ := auxColuna;
          7: oNovoSPED.Registro0000.CPF := auxColuna;
          8: oNovoSPED.Registro0000.UF := auxColuna;
          9: oNovoSPED.Registro0000.InscricaoEstadual := auxColuna;
          10: oNovoSPED.Registro0000.Cod_Mun := auxColuna;
          11: oNovoSPED.Registro0000.IM := auxColuna;
          12: oNovoSPED.Registro0000.SUFRAMA := auxColuna;
          13: oNovoSPED.Registro0000.Ind_Perfil := auxColuna;
          14: oNovoSPED.Registro0000.Ind_Ativ := auxColuna;
       end;

       i:= i + 1;
    end;
  end;

  if Copy(linha, 2, 4) = 'C100' then
  begin
    auxC100 := TRegistroC100.Create();

    while(i <= 28) do
    begin
      auxLinhaRestante := Copy(auxLinhaRestante, Pos('|', auxLinhaRestante) + 1, Length(auxLinhaRestante) - (Pos('|', auxLinhaRestante)));
      auxColuna := Copy(auxLinhaRestante, 1, Pos('|', auxLinhaRestante) -1);

      case i of
          1: auxC100.Ind_Oper := auxColuna;
          2: auxC100.Ind_Emit := auxColuna;
          3: auxC100.Cod_Part := auxColuna;
          4: auxC100.Cod_Mod := auxColuna;
          5: auxC100.Cod_Sit := auxColuna;
          6: auxC100.Ser := auxColuna;
          7: auxC100.Num_Doc := auxColuna;
          8: auxC100.Chv_Nfe := auxColuna;
          9: auxC100.Dt_Doc := auxColuna;
          10: auxC100.Dt_E_S := auxColuna;
          12: auxC100.Ind_Pgto := auxColuna;
          16: auxC100.Ind_Frt := auxColuna;

          //apenas altera valor default desses campos, caso seja um currency(valor numerico) valido
          11,13,14,15,17,18,19,20,21,22,23,24,25,26,27,28:
          if auxColuna <> '' then
          begin
            case i of
                11: auxC100.Vl_Doc := auxColuna;
                13: auxC100.Vl_Desc := auxColuna;
                14: auxC100.Vl_Abat_Nt := auxColuna;
                15: auxC100.Vl_Merc := auxColuna;
                17: auxC100.Vl_Frt := auxColuna;
                18: auxC100.Vl_Seg := auxColuna;
                19: auxC100.Vl_Out_Da := auxColuna;
                20: auxC100.Vl_BC_ICMS := auxColuna;
                21: auxC100.Vl_ICMS := auxColuna;
                22: auxC100.Vl_BC_ICMS_ST := auxColuna;
                23: auxC100.Vl_ICMS_ST := auxColuna;
                24: auxC100.Vl_IPI := auxColuna;
                25: auxC100.Vl_PIS := auxColuna;
                26: auxC100.Vl_COFINS := auxColuna;
                27: auxC100.Vl_PIS_ST := auxColuna;
                28: auxC100.Vl_COFINS_ST := auxColuna;
            end;
          end;
      end;

      i:= i + 1;
    end;

    oNovoSPED.ListaRegistrosC100.Add(auxC100);
  end;

end;

end.
