unit UnFrmArquivosSPED;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  System.Actions, Vcl.ActnList, Vcl.Grids, Vcl.ComCtrls, UnClasseSPED, System.IOUtils, Generics.Collections;

type
  TFrmArquivosSPED = class(TForm)
    OpdCaminhoSPED: TOpenDialog;
    ActionList1: TActionList;
    ActFechar: TAction;
    PnlBotoes: TPanel;
    BtnNovo: TBitBtn;
    BtnSalvar: TBitBtn;
    BtnListar: TBitBtn;
    PnlInfoDoc: TPanel;
    Label1: TLabel;
    EdtCaminhoArqSPED: TEdit;
    SpbCaminhoArqReceita: TSpeedButton;
    SpbCaminhoArqSPED: TSpeedButton;
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
    LblQtdeC100Encontradas: TLabel;
    LblTotalC100Encontradas: TLabel;
    LblQtdeArquivos: TLabel;
    ProgressBar1: TProgressBar;
    GroupBox6: TGroupBox;
    GroupBox9: TGroupBox;
    CmbModelo: TComboBox;
    RadioTipoNF: TRadioGroup;
    procedure ActFecharExecute(Sender: TObject);
    procedure ActLimparExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpbCaminhoArqSPEDClick(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
    procedure BtnSalvarClick(Sender: TObject);
    procedure BtnNovoClick(Sender: TObject);
    procedure BtnListarClick(Sender: TObject);
    procedure BtnExcluirClick(Sender: TObject);
    procedure StgSPEDMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StgSPEDMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CmbModeloChange(Sender: TObject);
    procedure RadioTipoNFClick(Sender: TObject);
  private
    { Private declarations }
    oNovoSPED: TSPED;
    oListaSPED: TObjectList<TSPED>;

    _cod, GiRow, GiCol, coluna : integer;
    GCelda : TRect;

    Procedure iniciaGridSPED();
    procedure carregaSPEDTela;
    procedure carregaListaSPEDTela;
    procedure bloqueiaLiberaTela(lLibera: boolean);
    procedure bloqueiaLiberaBotoes(lNovo, lSalvar, lListar, lExcluir: boolean);

    function validaArquivoSPED(caminhoArquivo: String): Boolean;
    function carregaRegistroArquivoSPED(linha: String): Boolean;
    procedure carregaGridSPED;

    procedure Salvar;
    procedure Excluir;
  public
    { Public declarations }
  end;

var
  FrmArquivosSPED: TFrmArquivosSPED;

implementation

uses
  UnClasseUtils, UnClasseRegistroC100_Notas, UnClasseRegistro0150_Participante, UnFrmListarSPED, UnClasseOrdenacaoStringGrid, UnClasseThread;

Const
  _MODELO_NF_TODOS = 2;
  _MODELO_NF_65 = 1;
  _MODELO_NF_55 = 0;
  _TIPO_NF_ENTRADA = 1;
  _TIPO_NF_SAIDA = 2;

{$R *.dfm}

procedure TFrmArquivosSPED.ActFecharExecute(Sender: TObject);
begin
  if Application.MessageBox('Os dados não salvos serão perdidos. Deseja continuar?','Aviso',mb_yesno + MB_ICONWARNING + MB_DEFBUTTON2) = id_yes then
    Close();
end;

procedure TFrmArquivosSPED.ActLimparExecute(Sender: TObject);
begin
  oNovoSPED := TSPED.Create();
  oListaSPED := TObjectList<TSPED>.Create();
  iniciaGridSPED();
  EdtCaminhoArqSPED.Text := '...';
  EdtCodigoDocumento.Clear;
  LblRazaoSocial.Caption := '...';
  DateInicial.DateTime := now();
  DateFinal.DateTime := now();
  ProgressBar1.Position := 0;
end;

procedure TFrmArquivosSPED.BtnCancelarClick(Sender: TObject);
begin
  if Application.MessageBox('Os dados não salvos serão perdidos. Deseja continuar?','Aviso',mb_yesno + MB_ICONWARNING) = id_yes then
    ActLimparExecute(self);
end;

procedure TFrmArquivosSPED.BtnExcluirClick(Sender: TObject);
begin
  executarThread(Excluir);
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

      oListaSPED := FrmListarSPED.oListaSPEDSelecionado;
      carregaListaSPEDTela();
      //oNovoSPED := FrmListarSPED.oSPEDSelecionado;
      //carregaSPEDTela();
    end;
  finally
    FreeAndNil(FrmListarSPED);
  end;
end;

procedure TFrmArquivosSPED.BtnNovoClick(Sender: TObject);
begin
  if (oNovoSPED.Arquivo <> '')
  AND(Application.MessageBox('Os dados não salvos serão perdidos. Deseja continuar?','Aviso',mb_yesno + MB_ICONWARNING) <> id_yes) then
    exit;
  ActLimparExecute(Self);
  bloqueiaLiberaTela(true);
  bloqueiaLiberaBotoes(true, true, true, false);
  FrmArquivosSPED.Caption := '[Novo] Arquivos - SPED';
  SpbCaminhoArqSPEDClick(self);
end;

procedure TFrmArquivosSPED.BtnSalvarClick(Sender: TObject);
begin
  executarThread(Salvar);
end;

procedure TFrmArquivosSPED.Excluir;
var
  i: integer;
  auxSPED: TSPED;
begin
  try
    try
      if (Application.MessageBox('Os arquivos serão apagados permanentemente. Deseja continuar?','Aviso',mb_yesno + MB_ICONWARNING) <> id_yes) then
        exit;
      ProgressBar1.Position := 0;
      ProgressBar1.Max := oListaSPED.Count;
      for i := 0 to oListaSPED.Count - 1 do
      begin
        ProgressBar1.Position := ProgressBar1.Position + 1;
        ProgressBar1.Update;
        auxSPED := oListaSPED[i];
        auxSPED.excluir();
      end;
      ShowMessage('SPEDs removidos com Sucesso!');
      //retorna ao estado inicial
      FormShow(self);
    except on E: Exception do
      ShowMessage('Não foi possível excluir o SPED!' + #13 +
                  'Mensagem de Erro: ' + E.Message);
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrmArquivosSPED.salvar;
var
  auxSPED: TSPED;
  i, iErros, iSucessos: integer;
begin
  iErros := 0;
  iSucessos := 0;

  try
    Screen.Cursor := crHourGlass;
    //salvar banco de dados
    try
      ProgressBar1.Position := 0;
      ProgressBar1.Max := oListaSPED.Count;
      for i := 0 to oListaSPED.Count - 1 do
      begin
        ProgressBar1.Position := ProgressBar1.Position + 1;
        ProgressBar1.Update;
        auxSPED := oListaSPED[i];
        if auxSPED.Validar() then
        begin
          auxSPED.Id_SPED:= auxSPED.salvar();
          inc(iSucessos);
        end
        else
          Inc(iErros);
        Application.ProcessMessages;
      end;
      //retorna ao estado inicial
      FormShow(self);
      Application.MessageBox(PChar('Arquivos salvos com sucesso: ' + IntToStr(iSucessos) + ', Arquivos de periodos já inseridos previamente: ' + IntToStr(iErros)),'Banco de Dados',MB_OKCANCEL + MB_ICONINFORMATION)
    except on E: Exception do
      begin
        ProgressBar1.Position := 0;
        ShowMessage('Não foi possível salvar os Arquivos SPED!' + #13 +
                    'Mensagem de Erro: ' + E.Message);
      end;
    end;
  finally
    Screen.Cursor := crDefault;
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
  limparGrid(StgSPED, 2);

  with StgSPED do
  begin
    FixedCols:= 0;

    Cells[1, 0]:= 'Serie Documento';
    Cells[2, 0]:= 'Número Documento';
    Cells[3, 0]:= 'Chave de Acesso';
    Cells[4, 0]:= 'Data Emissão';
    Cells[5, 0]:= 'Tipo Operacao';
    Cells[6, 0]:= 'Valor Total';

    //tipo de campo
    Cells[1,1] := 'N';
    Cells[2,1] := 'N';
    Cells[3,1] := 'S';
    Cells[4,1] := 'D';
    Cells[5,1] := 'S';
    Cells[6,1] := 'N';
    RowHeights[1]:=0;
  end;

  carregaListaSPEDTela();
end;

procedure TFrmArquivosSPED.RadioTipoNFClick(Sender: TObject);
begin
  carregaListaSPEDTela();
end;

procedure TFrmArquivosSPED.SpbCaminhoArqSPEDClick(Sender: TObject);
var
  arquivo: TextFile;
  linha: String;
  i:integer;
begin
  ActLimparExecute(Self);
  try
    Screen.Cursor := crHourGlass;
    if OpdCaminhoSPED.Execute then
    begin
        oListaSPED := TObjectList<TSPED>.Create();

        for I := 0 to OpdCaminhoSPED.Files.Count - 1 do
        begin
          //adicionar validação pra verificar se a data já foi inserida previamente
          if validaArquivoSPED(OpdCaminhoSPED.Files[i]) then
          begin
            oNovoSPED := TSPED.Create();

            AssignFile(arquivo, OpdCaminhoSPED.Files[i]);
            Reset(arquivo);
            Application.ProcessMessages();
            while not Eof(arquivo) do
            begin
              Readln(arquivo, linha);
              carregaRegistroArquivoSPED(linha);
            end;
            CloseFile(arquivo);

            oNovoSPED.CaminhoArquivo := OpdCaminhoSPED.Files[i];
            oNovoSPED.Arquivo := TPath.GetFileName(OpdCaminhoSPED.Files[i]);
            oListaSPED.Add(oNovoSPED);
          end
          else
          begin
            Application.MessageBox(PChar('Arquivo ' + IntToStr(i + 1) + ' .txt não possui estrutura de um arquivo SPED!' + #13 +
                                   'Selecione um arquivo .txt em formato valido de SPED'),
                                   'Validação', MB_ICONWARNING + MB_OK);
            exit;
          end;
        end;

        carregaListaSPEDTela();
    end
    else
    begin
      //if oListaChaveAcessoArqSPED <> Nil then
        //FreeAndNil(oListaChaveAcessoArqSPED);
      //EdtCaminhoArqSPED.Text := '...';
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrmArquivosSPED.StgSPEDMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  Valor: String;
  tipo: integer;
  LGcCoord: TGridCoord; //Define as coordenadas do mouse na grid
begin
  LGcCoord := TCustomGrid(StgSPED).MouseCoord(x,y);
  GiCol := LGcCoord.X;
  GiRow := LGcCoord.Y;
  if (GiRow = 0) And (Button = mbleft) And (GiCol <> -1) then
  Begin
    with StgSPED do
    Begin
      GCelda := CellRect(GiCol,0);
      Valor := Cells[GiCol, 0];
      {Canvas.Font := Font;
      Canvas.Brush.Color := clInactiveCaption;
      Canvas.FillRect(GCelda);
      Canvas.TextRect(GCelda, GCelda.Left + 1, GCelda.Top + 1, Valor);
      DrawEdge(Canvas.Handle, GCelda, 10, 2 or 4 or 8);
      DrawEdge(Canvas.Handle, GCelda, 2 or 4, 1);}
    End;

    if (StgSPED.Cells[GiCol,1] = 'N') then
      tipo := 1
    else if (StgSPED.Cells[GiCol,1] = 'S') then
      tipo := 2
    else
      tipo := 3;

    if ( (GiCol > 0) and (GiRow < (StgSPED.RowCount-1)) ) then
    begin
      if (GiCol = coluna) then
      begin
        StrGridSort(StgSPED,GiCol,tipo, true, false);
        coluna := -1
      end
      else
      begin
        StrGridSort(StgSPED,GiCol,tipo, false,false);
        coluna := GiCol;
      end;
    end;
  end;
end;

procedure TFrmArquivosSPED.StgSPEDMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
  Valor :String;
begin
  if (GiRow = 0) And (Button = mbleft) And (GiCol <> -1) then
  begin
    with StgSPED do
    Begin
      Valor := Cells[Gicol, 0];
      Canvas.Font := Font;
      {Canvas.Brush.Color := clInactiveCaption;
      Canvas.FillRect(GCelda);
      Canvas.TextRect(GCelda, GCelda.Left + 1, GCelda.Top + 1, Valor);
      DrawEdge(Canvas.Handle, GCelda, 4, 4 or 8);
      DrawEdge(Canvas.Handle, GCelda, 4, 1 or 2);}
      GCelda := StgSPED.CellRect(1, 1);
    end;
  end;
end;

function TFrmArquivosSPED.validaArquivoSPED(caminhoArquivo: String): Boolean;
var
  arquivo: TextFile;
  linha: String;
  contaRegistro0000: integer;
begin
  try
  Result := False;
  contaRegistro0000 := 0;

  AssignFile(arquivo, caminhoArquivo);
  Reset(arquivo);
  Application.ProcessMessages();

  //contar registros 0000
  while not Eof(arquivo) do
  begin
    Readln(arquivo, linha);

    //ao encontrar registro 0000 incrementa e muda o result para true
    if (Trim(linha) <> '') and (Copy(linha, 1, 6) = '|0000|') then
    begin
      Result := true;
      Inc(contaRegistro0000);
    end;

    //caso encontre novamente outro registro 0000 retorna falso
    if (contaRegistro0000 > 1) then
    begin
      Result := false;
      break;
    end;
  end;

  finally
    CloseFile(arquivo);
  end;
end;

//descontinuado
procedure TFrmArquivosSPED.carregaSPEDTela;
begin
  EdtCaminhoArqSPED.Text := oNovoSPED.CaminhoArquivo;
  EdtCodigoDocumento.Text := IntToStr(oNovoSPED.Id_SPED);
  LblRazaoSocial.Caption := oNovoSPED.Registro0000.NomeEmpresa;
  DateInicial.DateTime := StrToDate(converteFormatoData(oNovoSPED.Registro0000.DataInicial));
  DateFinal.DateTime := StrToDate(converteFormatoData(oNovoSPED.Registro0000.DataFinal));

  carregaGridSPED();
end;

procedure TFrmArquivosSPED.CmbModeloChange(Sender: TObject);
begin
  carregaListaSPEDTela();
end;

//descontinuado
procedure TFrmArquivosSPED.carregaGridSPED;
var
  i, linhasOcultadas: Integer;
  auxValor: double;
  auxQtde: integer;
  auxRegistrosSelecionados: integer;
begin
  limparGrid(StgSPED, 2);
  auxValor:= 0;
  linhasOcultadas := 0;

  with StgSPED do
  begin
    if oNovoSPED.ListaRegistrosC100.Count = 0 then
    begin
      StgSPED.RowCount:= 3;
      LblQtdeC100Encontradas.Caption:= 'Nenhum Registro Encontrado';
      LblTotalC100Encontradas.Caption:= 'Valor Total: R$ 0,00';
    end
    else
      //é preciso ser +2 devido a linha de titulos e a linha oculta que determina o filtro
      StgSPED.RowCount:= oNovoSPED.ListaRegistrosC100.Count + 2;

    auxRegistrosSelecionados := oNovoSPED.ListaRegistrosC100.Count;
    for i:= 0 to auxRegistrosSelecionados - 1 do
    begin
      //filtra os resultados na tela pelo tipo de nota
      if CmbModelo.ItemIndex = _MODELO_NF_55 then
      begin
        if oNovoSPED.ListaRegistrosC100[i].Cod_Mod <> '55' then
        begin
          inc(linhasOcultadas);
          StgSPED.RowCount := StgSPED.RowCount - 1;
          auxRegistrosSelecionados := auxRegistrosSelecionados - 1;
          Continue;
        end;
      end
      else if CmbModelo.ItemIndex = _MODELO_NF_65 then
      begin
        if oNovoSPED.ListaRegistrosC100[i].Cod_Mod <> '65' then
        begin
          inc(linhasOcultadas);
          StgSPED.RowCount := StgSPED.RowCount - 1;
          auxRegistrosSelecionados := auxRegistrosSelecionados - 1;
          Continue;
        end;
      end;


      if RadioTipoNF.ItemIndex = _TIPO_NF_ENTRADA then
      begin
        if oNovoSPED.ListaRegistrosC100[i].Ind_Oper <> '0' then
        begin
          inc(linhasOcultadas);
          StgSPED.RowCount := StgSPED.RowCount - 1;
          auxRegistrosSelecionados := auxRegistrosSelecionados - 1;
          Continue;
        end;
      end
      else if RadioTipoNF.ItemIndex = _TIPO_NF_SAIDA then
      begin
        if oNovoSPED.ListaRegistrosC100[i].Ind_Oper <> '1' then
        begin
          inc(linhasOcultadas);
          StgSPED.RowCount := StgSPED.RowCount - 1;
          auxRegistrosSelecionados := auxRegistrosSelecionados - 1;
          Continue;
        end;
      end;

      Cells[1, i + 2 - linhasOcultadas]:= oNovoSPED.ListaRegistrosC100[i].Ser;
      Cells[2, i + 2 - linhasOcultadas]:= oNovoSPED.ListaRegistrosC100[i].Num_Doc;
      Cells[3, i + 2 - linhasOcultadas]:= oNovoSPED.ListaRegistrosC100[i].Chv_Nfe;
      Cells[4, i + 2 - linhasOcultadas]:= converteFormatoData(oNovoSPED.ListaRegistrosC100[i].Dt_Doc);

      if oNovoSPED.ListaRegistrosC100[i].Ind_Oper = '0' then
        Cells[5, i + 2 - linhasOcultadas]:= 'Entrada'
      else
        Cells[5, i + 2 - linhasOcultadas]:= 'Saida';

      Cells[6, i + 2 - linhasOcultadas]:= retiraCaractere('.',oNovoSPED.ListaRegistrosC100[i].Vl_Doc);

      if oNovoSPED.ListaRegistrosC100[i].Vl_Doc <> '' then
        auxValor := auxValor + StrToFloat(oNovoSPED.ListaRegistrosC100[i].Vl_Doc);
    end;

  end;
  //atualiza informação de totais
  LblQtdeC100Encontradas.Caption:= IntToStr(auxRegistrosSelecionados) + ' Registro(s) encontrada(s)';
  LblQtdeArquivos.Caption := IntToStr(oListaSPED.Count) + ' Arquivo(s)';
  LblTotalC100Encontradas.Caption:= 'Valor Total: R$ ' + FloatToStrF(auxValor,ffnumber,10,02);
end;

procedure TFrmArquivosSPED.carregaListaSPEDTela;
var
  i, y, linhasOcultadas, auxRegistrosSelecionados, auxTotalRegistrosSelecionados: Integer;
  auxValor: double;
  auxSPED: TSPED;
  auxRegistroC100: TRegistroC100;
begin
  limparGrid(StgSPED, 2);
  auxValor:= 0;
  auxTotalRegistrosSelecionados:= 0;

  if oListaSPED.Count = 0 then
  begin
    StgSPED.RowCount:= 3;
    LblQtdeC100Encontradas.Caption:= 'Nenhum Registro Encontrado';
    LblTotalC100Encontradas.Caption:= 'Valor Total: R$ 0,00';
    LblQtdeArquivos.Caption := IntToStr(oListaSPED.Count) + ' Arquivo(s)';
    exit;
  end;

  for y := 0 to oListaSPED.Count - 1 do
  begin
    with StgSPED do
    begin
      auxSPED := oListaSPED[y];
      if auxSPED.ListaRegistrosC100.Count <> 0 then
        StgSPED.RowCount:= auxSPED.ListaRegistrosC100.Count + 2; // é preciso ser +2 devido a linha de titulos e a linha oculta que determina o filtro

      linhasOcultadas:= 0;
      auxRegistrosSelecionados := auxSPED.ListaRegistrosC100.Count;
      for i:= 0 to auxRegistrosSelecionados - 1 do
      begin
        //filtra os resultados na tela pelo tipo de nota
        if CmbModelo.ItemIndex = _MODELO_NF_55 then
        begin
          if auxSPED.ListaRegistrosC100[i].Cod_Mod <> '55' then
          begin
            inc(linhasOcultadas);
            StgSPED.RowCount := StgSPED.RowCount - 1;
            auxRegistrosSelecionados := auxRegistrosSelecionados - 1;
            Continue;
          end;
        end
        else if CmbModelo.ItemIndex = _MODELO_NF_65 then
        begin
          if auxSPED.ListaRegistrosC100[i].Cod_Mod <> '65' then
          begin
            inc(linhasOcultadas);
            StgSPED.RowCount := StgSPED.RowCount - 1;
            auxRegistrosSelecionados := auxRegistrosSelecionados - 1;
            Continue;
          end;
        end;

        if RadioTipoNF.ItemIndex = _TIPO_NF_ENTRADA then
        begin
          if auxSPED.ListaRegistrosC100[i].Ind_Oper <> '0' then
          begin
            inc(linhasOcultadas);
            StgSPED.RowCount := StgSPED.RowCount - 1;
            auxRegistrosSelecionados := auxRegistrosSelecionados - 1;
            Continue;
          end;
        end
        else if RadioTipoNF.ItemIndex = _TIPO_NF_SAIDA then
        begin
          if auxSPED.ListaRegistrosC100[i].Ind_Oper <> '1' then
          begin
            inc(linhasOcultadas);
            StgSPED.RowCount := StgSPED.RowCount - 1;
            auxRegistrosSelecionados := auxRegistrosSelecionados - 1;
            Continue;
          end;
        end;

        Cells[1, i + 2 - linhasOcultadas]:= auxSPED.ListaRegistrosC100[i].Ser;
        Cells[2, i + 2 - linhasOcultadas]:= auxSPED.ListaRegistrosC100[i].Num_Doc;
        Cells[3, i + 2 - linhasOcultadas]:= auxSPED.ListaRegistrosC100[i].Chv_Nfe;
        Cells[4, i + 2 - linhasOcultadas]:= converteFormatoData(auxSPED.ListaRegistrosC100[i].Dt_Doc);

        if auxSPED.ListaRegistrosC100[i].Ind_Oper = '0' then
          Cells[5, i + 2 - linhasOcultadas]:= 'Entrada'
        else
          Cells[5, i + 2 - linhasOcultadas]:= 'Saida';

        Cells[6, i + 2 - linhasOcultadas]:= retiraCaractere('.',auxSPED.ListaRegistrosC100[i].Vl_Doc);

        if auxSPED.ListaRegistrosC100[i].Vl_Doc <> '' then
          auxValor := auxValor + StrToFloat(auxSPED.ListaRegistrosC100[i].Vl_Doc);
      end;

      auxTotalRegistrosSelecionados := auxTotalRegistrosSelecionados + auxRegistrosSelecionados;
    end;
  end;

  //atualiza informação de totais
  LblQtdeC100Encontradas.Caption:= IntToStr(auxTotalRegistrosSelecionados) + ' Registro(s) encontrada(s)';
  LblQtdeArquivos.Caption := IntToStr(oListaSPED.Count) + ' Arquivo(s)';
  LblTotalC100Encontradas.Caption:= 'Valor Total: R$ ' + FloatToStrF(auxValor,ffnumber,10,02);
end;

function TFrmArquivosSPED.carregaRegistroArquivoSPED(linha: String): Boolean;
var
  auxLinhaRestante: string;
  auxColuna: string;
  i: integer;
  auxEmpresa: string;
  auxC100: TRegistroC100;
  aux0150: TRegistro0150;
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

  if Copy(linha, 2, 4) = '0150' then
  begin
    aux0150 := TRegistro0150.Create();

    while(i <= 12) do
    begin
      auxLinhaRestante := Copy(auxLinhaRestante, Pos('|', auxLinhaRestante) + 1, Length(auxLinhaRestante) - (Pos('|', auxLinhaRestante)));
      auxColuna := Copy(auxLinhaRestante, 1, Pos('|', auxLinhaRestante) -1);

      case i of
          1: aux0150.Cod_Part := auxColuna;
          2: aux0150.Nome := auxColuna;
          3: aux0150.Cod_Pais := auxColuna;
          4: aux0150.CNPJ := auxColuna;
          5: aux0150.CPF := auxColuna;
          6: aux0150.IE := auxColuna;
          7: aux0150.Cod_Mun := auxColuna;
          8: aux0150.Suframa := auxColuna;
          9: aux0150.Endereco := auxColuna;
          10: aux0150.Num := auxColuna;
          11: aux0150.Compl := auxColuna;
          12: aux0150.Bairro := auxColuna;
      end;

      i:= i + 1;
    end;

    oNovoSPED.ListaRegistros0150.Add(aux0150);
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
