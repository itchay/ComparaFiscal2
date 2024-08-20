unit UnFrmArquivosBaseDadosATF;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  System.Actions, Vcl.ActnList, Vcl.Grids, Vcl.ComCtrls, UnClasseATF, System.IOUtils, Generics.Collections;

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
    GroupBox4: TGroupBox;
    EdtCodigoDocumento: TEdit;
    GroupBox3: TGroupBox;
    DateEmissao: TDateTimePicker;
    Label2: TLabel;
    LblRazaoSocial: TLabel;
    StgATF: TStringGrid;
    GroupBox5: TGroupBox;
    SpeedButton2: TSpeedButton;
    BtnExcluir: TBitBtn;
    ActLimpar: TAction;
    LblQtdeEncontradas: TLabel;
    LblTotalEncontradas: TLabel;
    ProgressBar1: TProgressBar;
    LblQtdeArquivos: TLabel;
    GroupBox6: TGroupBox;
    RadioTipoNF: TRadioGroup;
    procedure ActFecharExecute(Sender: TObject);
    procedure ActLimparExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpbCaminhoArqATFClick(Sender: TObject);
    procedure BtnSalvarClick(Sender: TObject);
    procedure BtnNovoClick(Sender: TObject);
    procedure BtnListarClick(Sender: TObject);
    procedure BtnExcluirClick(Sender: TObject);
    procedure StgATFMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StgATFMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RadioTipoNFClick(Sender: TObject);
  private
    { Private declarations }
    oNovoATF: TATF;
    oListaATF: TObjectList<TATF>;

    _cod, GiRow, GiCol, coluna : integer;
    GCelda : TRect;

    Procedure iniciaGridATF();
    procedure carregaATFTela;
    procedure carregaGridATF();
    procedure carregaListaATFTela();
    procedure bloqueiaLiberaTela(lLibera: boolean);
    procedure bloqueiaLiberaBotoes(lNovo, lSalvar, lListar, lExcluir: boolean);

    function validaArquivoATF(caminhoArquivo: String): Boolean;
    function carregaRegistroArquivoATF(linha: String): Boolean;

    procedure Salvar;
    procedure Excluir;
  public
    { Public declarations }
  end;

var
  FrmArquivosBaseDadosATF: TFrmArquivosBaseDadosATF;

implementation

uses
  UnClasseUtils, UnClasseATF_Nota, UnFrmListarATF, UnClasseOrdenacaoStringGrid, UnClasseThread;//, UnFrmListarATF;

Const
  _MODELO_NF_TODOS = 1;
  _MODELO_NF_55 = 0;
  _TIPO_NF_ENTRADA = 1;
  _TIPO_NF_SAIDA = 2;

{$R *.dfm}

procedure TFrmArquivosBaseDadosATF.ActFecharExecute(Sender: TObject);
begin
  if Application.MessageBox('Os dados n�o salvos ser�o perdidos. Deseja continuar?','Aviso',mb_yesno + MB_ICONWARNING + MB_DEFBUTTON2) = id_yes then
    Close();
end;

procedure TFrmArquivosBaseDadosATF.ActLimparExecute(Sender: TObject);
begin
  oNovoATF := TATF.Create();
  oListaATF := TObjectList<TATF>.Create();
  iniciaGridATF();
  EdtCaminhoArqATF.Text := '...';
  EdtCodigoDocumento.Clear;
  LblRazaoSocial.Caption := '...';
  DateEmissao.DateTime := now();
  ProgressBar1.Position := 0;
end;

procedure TFrmArquivosBaseDadosATF.BtnExcluirClick(Sender: TObject);
begin
  executarThread(Excluir);
end;

procedure TFrmArquivosBaseDadosATF.BtnListarClick(Sender: TObject);
begin
  try
    FrmListarATF := TFrmListarATF.Create(Self);
    FrmListarATF.ShowModal();
    if FrmListarATF.oATFSelecionado.Id_ATF <> 0 then
    begin
      ActLimparExecute(Self);
      bloqueiaLiberaTela(true);
      bloqueiaLiberaBotoes(true, false, true, true);
      FrmArquivosBaseDadosATF.Caption := '[Consulta] Arquivos - ATF';

      oListaATF := FrmListarATF.oListaATFSelecionados;
      carregaListaATFTela();
      //oNovoATF := FrmListarATF.oATFSelecionado;
      //carregaATFTela();
    end;
  finally
    FreeAndNil(FrmListarATF);
  end;
end;

procedure TFrmArquivosBaseDadosATF.BtnNovoClick(Sender: TObject);
begin
  if (oNovoATF.Arquivo <> '')
  AND(Application.MessageBox('Os dados n�o salvos ser�o perdidos. Deseja continuar?','Aviso',mb_yesno + MB_ICONWARNING) <> id_yes) then
    exit;
  ActLimparExecute(Self);
  bloqueiaLiberaTela(true);
  bloqueiaLiberaBotoes(true, true, true, false);
  FrmArquivosBaseDadosATF.Caption := '[Novo] Arquivos - ATF';
  SpbCaminhoArqATFClick(self);
end;

procedure TFrmArquivosBaseDadosATF.BtnSalvarClick(Sender: TObject);
begin
  executarThread(Salvar);
end;

procedure TFrmArquivosBaseDadosATF.Salvar;
var
  auxATF: TATF;
  i, iErros, iSucessos: integer;
begin
  iErros := 0;
  iSucessos := 0;
  try
    Screen.Cursor := crHourGlass;
    //salvar banco de dados
    try
      ProgressBar1.Position := 0;
      ProgressBar1.Max := oListaATF.Count;
      for i := 0 to oListaATF.Count - 1 do
      begin
        ProgressBar1.Position := ProgressBar1.Position + 1;
        ProgressBar1.Update;
        auxATF := oListaATF[i];
        if auxATF.Validar() then
        begin
          auxATF.Id_ATF:= auxATF.salvar();
          inc(iSucessos);
        end
        else
          Inc(iErros);
      end;
      //retorna ao estado inicial
      FormShow(self);
      Application.MessageBox(PChar('Arquivos salvos com sucesso: ' + IntToStr(iSucessos) + ', Arquivos de periodos j� inseridos previamente: ' + IntToStr(iErros)),'Banco de Dados',MB_OKCANCEL + MB_ICONINFORMATION)
    except on E: Exception do
      begin
        ProgressBar1.Position := 0;
        ShowMessage('N�o foi poss�vel salvar os Arquivos ATF!' + #13 +
                    'Mensagem de Erro: ' + E.Message);
      end;
    end;

    //salvar banco de dados
    {try
      oNovoATF.Id_ATF:= oNovoATF.salvar();
      ShowMessage('ATF Salvo com Sucesso!');
      //retorna ao estado inicial
      FormShow(self);
    except on E: Exception do
      ShowMessage('N�o foi poss�vel salvar o ATF!' + #13 +
                  'Mensagem de Erro: ' + E.Message);
    end;}
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrmArquivosBaseDadosATF.Excluir;
var
  i: integer;
  auxATF: TATF;
begin
  try
    Screen.Cursor := crHourGlass;
    //excluir banco de dados
    try
      if (Application.MessageBox('Os arquivos ser�o apagados permanentemente. Deseja continuar?','Aviso',mb_yesno + MB_ICONWARNING) <> id_yes) then
        exit;
      ProgressBar1.Position := 0;
      ProgressBar1.Max := oListaATF.Count;
      for i := 0 to oListaATF.Count - 1 do
      begin
        ProgressBar1.Position := ProgressBar1.Position + 1;
        ProgressBar1.Update;
        auxATF := oListaATF[i];
        auxATF.excluir();
      end;
      ShowMessage('ATFs removidos com Sucesso!');
      //retorna ao estado inicial
      FormShow(self);
    except on E: Exception do
      ShowMessage('N�o foi poss�vel excluir o ATF!' + #13 +
                  'Mensagem de Erro: ' + E.Message);
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrmArquivosBaseDadosATF.FormShow(Sender: TObject);
begin
  //limpa a tela
  ActLimparExecute(self);
  BloqueiaLiberaTela(false);
  BloqueiaLiberaBotoes(true, false, true, false);
  FrmArquivosBaseDadosATF.Caption := 'Arquivos - ATF';
end;

procedure TFrmArquivosBaseDadosATF.bloqueiaLiberaTela(lLibera: boolean);
begin
  SpbCaminhoArqATF.Enabled := lLibera;
end;

procedure TFrmArquivosBaseDadosATF.bloqueiaLiberaBotoes(lNovo, lSalvar, lListar, lExcluir: boolean);
begin
  BtnNovo.Enabled := lNovo;
  BtnSalvar.Enabled := lSalvar;
  BtnListar.Enabled := lListar;
  BtnExcluir.Enabled := lExcluir;
end;

Procedure TFrmArquivosBaseDadosATF.iniciaGridATF();
begin
  limparGrid(StgATF, 2);

  with StgATF do
  begin
    FixedCols:= 0;

    Cells[1, 0]:= 'Serie Documento';
    Cells[2, 0]:= 'N�mero Documento';
    Cells[3, 0]:= 'Chave de Acesso';
    Cells[4, 0]:= 'Data Emiss�o';
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

  carregaListaATFTela();
end;

procedure TFrmArquivosBaseDadosATF.RadioTipoNFClick(Sender: TObject);
begin
  carregaListaATFTela();
end;

procedure TFrmArquivosBaseDadosATF.SpbCaminhoArqATFClick(Sender: TObject);
var
  arquivo: TextFile;
  linha: String;
  i:integer;
begin
  ActLimparExecute(Self);
  try
    Cursor := crHourGlass;
    if OpdCaminhoATF.Execute then
    begin
        oListaATF := TObjectList<TATF>.Create();

        for I := 0 to OpdCaminhoATF.Files.Count - 1 do
        begin
          if validaArquivoATF(OpdCaminhoATF.Files[i]) then
          begin
            oNovoATF := TATF.Create();

            AssignFile(arquivo, OpdCaminhoATF.Files[i]);
            Reset(arquivo);
            Application.ProcessMessages();
            while not Eof(arquivo) do
            begin
              Readln(arquivo, linha);
              carregaRegistroArquivoATF(linha);
            end;
            CloseFile(arquivo);

            oNovoATF.CaminhoArquivo := OpdCaminhoATF.Files[i];
            oNovoATF.Arquivo := TPath.GetFileName(OpdCaminhoATF.Files[i]);
            oListaATF.Add(oNovoATF);
          end
          else
          begin
            Application.MessageBox('Arquivo .txt n�o possui estrutura de um arquivo ATF!' + #13 +
                               'Selecione um arquivo .txt em formato valido de ATF',
                               'Valida��o', MB_ICONWARNING + MB_OK);
            exit;
          end;
        end;

        //apenas se houver um unico arquivo na lista
        carregaListaATFTela();
      {end
      else
      begin
        //if oListaChaveAcessoArqSPED <> Nil then
          //FreeAndNil(oListaChaveAcessoArqSPED);
        Application.MessageBox('Arquivo .txt a ser comparado (SPED) n�o possui estrutura de um arquivo SPED!' + #13 +
                               'Por favor selecione um arquivo .txt no formato de SPED',
                               'Aten��o', MB_ICONWARNING + MB_OK);
        SpbCaminhoArqSPEDClick(Self);
      end;}
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

procedure TFrmArquivosBaseDadosATF.StgATFMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  Valor: String;
  tipo: integer;
  LGcCoord: TGridCoord; //Define as coordenadas do mouse na grid
begin
  LGcCoord := TCustomGrid(StgATF).MouseCoord(x,y);
  GiCol := LGcCoord.X;
  GiRow := LGcCoord.Y;
  if (GiRow = 0) And (Button = mbleft) And (GiCol <> -1) then
  Begin
    with StgATF do
    Begin
      GCelda := CellRect(GiCol,0);
      Valor := Cells[GiCol, 0];
      {Canvas.Font := Font;
      Canvas.Brush.Color := clInactiveCaptionText;
      Canvas.FillRect(GCelda);
      Canvas.TextRect(GCelda, GCelda.Left + 2, GCelda.Top + 2, Valor);
      DrawEdge(Canvas.Handle, GCelda, 10, 2 or 4 or 8);
      DrawEdge(Canvas.Handle, GCelda, 2 or 4, 1);}
    End;

    if (StgATF.Cells[GiCol,1] = 'N') then
      tipo := 1
    else if (StgATF.Cells[GiCol,1] = 'S') then
      tipo := 2
    else
      tipo := 3;

    if ( (GiCol > 0) and (GiRow < (StgATF.RowCount-1)) ) then
    begin
      if (GiCol = coluna) then
      begin
        StrGridSort(StgATF,GiCol,tipo, true, false);
        coluna := -1
      end
      else
      begin
        StrGridSort(StgATF,GiCol,tipo, false,false);
        coluna := GiCol;
      end;
    end;
  end;
end;

procedure TFrmArquivosBaseDadosATF.StgATFMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  Valor :String;
begin
  if (GiRow = 0) And (Button = mbleft) And (GiCol <> -1) then
  begin
    with StgATF do
    Begin
      Valor := Cells[Gicol, 0];
      {Canvas.Font := Font;
      Canvas.Brush.Color := clInactiveCaptionText;
      Canvas.FillRect(GCelda);
      Canvas.TextRect(GCelda, GCelda.Left + 2, GCelda.Top + 2, Valor);
      DrawEdge(Canvas.Handle, GCelda, 4, 4 or 8);
      DrawEdge(Canvas.Handle, GCelda, 4, 1 or 2);}
      GCelda := StgATF.CellRect(1, 1);
    end;
  end;
end;

function TFrmArquivosBaseDadosATF.validaArquivoATF(caminhoArquivo: String): Boolean;
var
  arquivo: TextFile;
  linha: String;
begin
  Result := False;

  //Ler primeira linha do arquivo
  AssignFile(arquivo, caminhoArquivo);
  Reset(arquivo);
  Readln(arquivo, linha);

  Result := ((Trim(linha) <> '') and (Copy(linha, 1, 15) = 'Chave_de_acesso'));
end;

//descontinuado
procedure TFrmArquivosBaseDadosATF.carregaATFTela;
  procedure carregaDataEmissaoNotas();
  var
    y: integer;
    auxMenorDataEmissao: TDate;
  begin
    for y := 0 to oNovoATF.ListaNotas.Count - 1 do
    begin
      If (y = 0) OR (oNovoATF.ListaNotas[y].DATA_EMISSAO < auxMenorDataEmissao) then
        auxMenorDataEmissao := oNovoATF.ListaNotas[y].DATA_EMISSAO;
    end;

    oNovoATF.DataEmissao:= auxMenorDataEmissao;
  end;
begin
  EdtCaminhoArqATF.Text := oNovoATF.CaminhoArquivo;
  EdtCodigoDocumento.Text := IntToStr(oNovoATF.Id_ATF);
  LblRazaoSocial.Caption := oNovoATF.Emitente.NomeEmpresa;

  carregaDataEmissaoNotas();
  DateEmissao.DateTime := oNovoATF.DataEmissao;

  carregaGridATF();
end;

//descontinuado
procedure TFrmArquivosBaseDadosATF.carregaGridATF();
var
  i, linhasOcultadas, auxRegistrosSelecionados: Integer;
  auxValor: double;
  auxQtde: integer;
begin
  limparGrid(StgATF, 2);
  auxValor:= 0;
  linhasOcultadas:= 0;

  with StgATF do
  begin
    if oNovoATF.ListaNotas.Count = 0 then
    begin
      StgATF.RowCount:= 3;
      LblQtdeEncontradas.Caption:= 'Nenhum Registro Encontrado';
      LblTotalEncontradas.Caption:= 'Valor Total: R$ 0,00';
    end
    else
      StgATF.RowCount:= oNovoATF.ListaNotas.Count + 2;

    auxRegistrosSelecionados := oNovoATF.ListaNotas.Count;
    for i:= 0 to auxRegistrosSelecionados - 1 do
    begin
      //filtra os resultados na tela
      if RadioTipoNF.ItemIndex = _TIPO_NF_ENTRADA then
      begin
        if oNovoATF.ListaNotas[i].TIPO_OPERACAO <> '0' then
        begin
            inc(linhasOcultadas);
            StgATF.RowCount := StgATF.RowCount - 1;
            auxRegistrosSelecionados := auxRegistrosSelecionados - 1;
            Continue;
        end;
      end
      else if RadioTipoNF.ItemIndex = _TIPO_NF_SAIDA then
      begin
        if oNovoATF.ListaNotas[i].TIPO_OPERACAO <> '1' then
        begin
            inc(linhasOcultadas);
            StgATF.RowCount := StgATF.RowCount - 1;
            auxRegistrosSelecionados := auxRegistrosSelecionados - 1;
            Continue;
        end;
      end;

      Cells[1, i + 2 - linhasOcultadas]:= IntToStr(oNovoATF.ListaNotas[i].SERIE);
      Cells[2, i + 2 - linhasOcultadas]:= IntToStr(oNovoATF.ListaNotas[i].Num_Doc);
      Cells[3, i + 2 - linhasOcultadas]:= oNovoATF.ListaNotas[i].CHAVE_ACESSO;
      Cells[4, i + 2 - linhasOcultadas]:= FormatDateTime('dd/mm/yyyy', oNovoATF.ListaNotas[i].DATA_EMISSAO);

      if oNovoATF.ListaNotas[i].TIPO_OPERACAO = '0' then
        Cells[5, i + 2 - linhasOcultadas]:= 'Entrada'
      else
        Cells[5, i + 2 - linhasOcultadas]:= 'Saida';

      Cells[6, i + 2 - linhasOcultadas]:= FloatToStrF(oNovoATF.ListaNotas[i].VALOR_TOTAL_NOTA, ffnumber, 15, 02);
      auxValor := auxValor + oNovoATF.ListaNotas[i].VALOR_TOTAL_NOTA;
    end;

  end;
  //atualiza informa��o de totais
  LblQtdeEncontradas.Caption:= IntToStr(auxRegistrosSelecionados) + ' Registro(s) encontrada(s)';
  LblTotalEncontradas.Caption:= 'Valor Total: R$ ' + FloatToStrF(auxValor,ffnumber,10,02);
end;


//carregar notas da lista de ATF no grid
procedure TFrmArquivosBaseDadosATF.carregaListaATFTela;
var
  i, y: Integer;
  auxValor: double;
  auxQtde: integer;
  auxATF: TATF;

  auxListaNotasSelecionadas: TObjectList<TATF_Nota>;
  auxNota: TATF_Nota;
begin
  //limpa a grid
  limparGrid(StgATF, 2);
  auxValor:= 0;

  //comportamento padr�o caso n�o seja encontrado nenhum valor
  if oListaATF.Count = 0 then
  begin
    LblQtdeEncontradas.Caption:= 'Nenhum Registro Encontrado';
    LblTotalEncontradas.Caption:= 'Valor Total: R$ 0,00';
    LblQtdeArquivos.Caption := IntToStr(oListaATF.Count) + ' Arquivo(s)';
    exit;
  end;

  //cria lista de notas selecionadas
  auxListaNotasSelecionadas := TObjectList<TATF_Nota>.Create();

  //navega pela lista de arquivos
  for y := 0 to oListaATF.Count - 1 do
  begin
    //selecionar cada arquivo da lista
    auxATF := oListaATF[y];

    for i:= 0 to auxATF.ListaNotas.Count - 1 do
    begin
      auxNota := auxATF.ListaNotas[i];
      //filtra os resultados que ser�o exibidos na tela
      if RadioTipoNF.ItemIndex = _TIPO_NF_ENTRADA then
      begin
        if auxATF.ListaNotas[i].TIPO_OPERACAO <> '0' then
          continue;
      end
      else if RadioTipoNF.ItemIndex = _TIPO_NF_SAIDA then
      begin
        if auxATF.ListaNotas[i].TIPO_OPERACAO <> '1' then
          continue;
      end;

      auxListaNotasSelecionadas.Add(auxNota);
    end;
  end;

  StgATF.RowCount:= StgATF.RowCount + auxListaNotasSelecionadas.Count;
  for i:= 0 to auxListaNotasSelecionadas.Count - 1 do
  begin
    with StgATF do
    begin
      Cells[1, i + 2]:= IntToStr(auxListaNotasSelecionadas[i].SERIE);
      Cells[2, i + 2]:= IntToStr(auxListaNotasSelecionadas[i].Num_Doc);
      Cells[3, i + 2]:= auxListaNotasSelecionadas[i].CHAVE_ACESSO;
      Cells[4, i + 2]:= FormatDateTime('dd/mm/yyyy', auxListaNotasSelecionadas[i].DATA_EMISSAO);

      if auxListaNotasSelecionadas[i].TIPO_OPERACAO = '0' then
        Cells[5, i + 2]:= 'Entrada'
      else
        Cells[5, i + 2]:= 'Saida';

      Cells[6, i + 2]:= retiraCaractere('.',FloatToStrF(auxListaNotasSelecionadas[i].VALOR_TOTAL_NOTA, ffnumber, 15, 02));

      auxValor := auxValor + auxListaNotasSelecionadas[i].VALOR_TOTAL_NOTA;
    end;
  end;

  //atualiza informa��o de totais
  LblQtdeEncontradas.Caption:= IntToStr(auxListaNotasSelecionadas.Count) + ' Registro(s) encontrada(s)';
  LblQtdeArquivos.Caption := IntToStr(oListaATF.Count) + ' Arquivo(s)';
  LblTotalEncontradas.Caption:= 'Valor Total: R$ ' + FloatToStrF(auxValor,ffnumber,10,02);
end;

function TFrmArquivosBaseDadosATF.carregaRegistroArquivoATF(linha: String): Boolean;
var
  auxLinhaRestante: string;
  auxColuna: string;
  i: integer;
  auxEmpresa: string;
  auxNota: TATF_Nota;
begin
  i:= 0;
  auxLinhaRestante:= linha;

  if ((Trim(linha) <> '') and (Copy(linha, 1, 15) <> 'Chave_de_acesso')) then
  begin
    auxNota := TATF_Nota.Create();

    while(i <= 38) do
    begin
      auxColuna := Copy(auxLinhaRestante, 1, Pos('|', auxLinhaRestante) -1);
      auxLinhaRestante := Copy(auxLinhaRestante, Pos('|', auxLinhaRestante) + 1, Length(auxLinhaRestante) - (Pos('|', auxLinhaRestante)));

      case i of
          0: auxNota.CHAVE_ACESSO := auxColuna;
          1: auxNota.NUM_DOC := StrToInt(auxColuna);
          2: auxNota.SERIE := StrToInt(auxColuna);
          3: auxNota.DATA_EMISSAO := StrToDate(auxColuna);
          4: auxNota.HORA_EMISSAO := StrToTime(auxColuna);
          5: auxNota.SITUACAO := auxColuna;
          6: auxNota.TIPO_OPERACAO := auxColuna;
          7: auxNota.VALOR_TOTAL_NOTA := StrToFloatCorrigido(retiraCaractere('.', auxColuna));
          8: auxNota.Emitente.NomeEmpresa := auxColuna;
          9: auxNota.Emitente.CNPJ := auxColuna;
          10: auxNota.Emitente.InscricaoEstadual := auxColuna;
          11: auxNota.Emitente.UF := auxColuna;
          //ADICIONA INFORMA��ES DO EMITENTE DO DOCUMENTO
          12:
          begin
            auxNota.NOME_RAZAO_SOCIAL_DEST := auxColuna;
            if auxNota.TIPO_OPERACAO = '1' then
              oNovoATF.Emitente.NomeEmpresa := auxColuna;
          end;
          13:
          begin
            auxNota.CPF_CNPJ_DEST := auxColuna;
            if auxNota.TIPO_OPERACAO = '1' then
              oNovoATF.Emitente.CNPJ := auxColuna;
          end;
          14:
          begin
            auxNota.INSCRICAO_ESTADUAL_DEST := auxColuna;
            if auxNota.TIPO_OPERACAO = '1' then
              oNovoATF.Emitente.InscricaoEstadual := auxColuna;
          end;
          15:
          begin
            auxNota.UF_DEST := auxColuna;
            if auxNota.TIPO_OPERACAO = '1' then
              oNovoATF.Emitente.UF := auxColuna;
          end;
          16: auxNota.PLACA_VEICULO_REBOQUE := auxColuna;
          17: auxNota.UF_PLACA := auxColuna;
          18: auxNota.NOME_TRANSPORTADORA := auxColuna;
          19: auxNota.INSCRICAO_ESTADUAL_TRANSP := auxColuna;
          20: auxNota.CPF_CNPJ_TRANSPORTADORA := auxColuna;
          21: auxNota.MODALIDADE_FRETE := auxColuna;
          22: auxNota.BASE_ICMS := StrToFloatCorrigido(retiraCaractere('.', auxColuna));
          23: auxNota.VALOR_ICMS := StrToFloatCorrigido(retiraCaractere('.', auxColuna));
          24: auxNota.BASE_ICMS_ST := StrToFloatCorrigido(retiraCaractere('.', auxColuna));
          25: auxNota.VALOR_ICMS_SUBSTITUICAO := StrToFloatCorrigido(retiraCaractere('.', auxColuna));
          26: auxNota.VALOR_TOTAL_DOS_PRODUTOS := StrToFloatCorrigido(retiraCaractere('.', auxColuna));
          27: auxNota.VALOR_FRETE := StrToFloatCorrigido(retiraCaractere('.', auxColuna));
          28: auxNota.VALOR_SEGURO := StrToFloatCorrigido(retiraCaractere('.', auxColuna));
          29: auxNota.VALOR_DESCONTO := StrToFloatCorrigido(retiraCaractere('.', auxColuna));
          30: auxNota.VALOR_OUTRAS_DESPESAS := StrToFloatCorrigido(retiraCaractere('.', auxColuna));
          31: auxNota.VALOR_IPI := StrToFloatCorrigido(retiraCaractere('.', auxColuna));
          32: auxNota.VALOR_TOTAL_ICMS_UF_DEST := StrToFloatCorrigido(retiraCaractere('.', auxColuna));
          33: auxNota.VALOR_TOTAL_ICMS_UF_REMET := StrToFloatCorrigido(retiraCaractere('.', auxColuna));
          34: auxNota.VALOR_ICMS_FCP_UF_DEST := StrToFloatCorrigido(retiraCaractere('.', auxColuna));
          35: auxNota.IP_EMITENTE := auxColuna;
          36: auxNota.PORTA_CONEXAO_ORIGEM := auxColuna;
          37: auxNota.DATA_HORA_CONEXAO_ORIGEM := StrToDateTimeCorrigido(auxLinhaRestante);
      end;

      i:= i + 1;
    end;

    oNovoATF.ListaNotas.Add(auxNota);
  end;

end;

end.
