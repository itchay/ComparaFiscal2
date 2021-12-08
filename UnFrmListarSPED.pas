unit UnFrmListarSPED;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  System.Actions, Vcl.ActnList, Vcl.Grids, Vcl.ComCtrls, UnClasseSPED, System.IOUtils, Generics.collections,
  Vcl.Menus;

type
  TFrmListarSPED = class(TForm)
    PnlInfoDoc: TPanel;
    GroupBox4: TGroupBox;
    EdtDocumentoEmitente: TEdit;
    GroupBox3: TGroupBox;
    DateFinal: TDateTimePicker;
    StgSPED: TStringGrid;
    GroupBox5: TGroupBox;
    LblQtdeSPEDEncontrados: TLabel;
    LblQtdeSPEDSelecionados: TLabel;
    GroupBox1: TGroupBox;
    DateInicial: TDateTimePicker;
    BitBtn1: TBitBtn;
    BtnListar: TBitBtn;
    ActionList1: TActionList;
    ActFechar: TAction;
    PopupMenu1: TPopupMenu;
    DeletarSPED: TMenuItem;
    Label1: TLabel;
    RdgSelecionar: TRadioGroup;
    procedure ActFecharExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StgSPEDDblClick(Sender: TObject);
    procedure BtnListarClick(Sender: TObject);
    procedure EdtDocumentoEmitenteExit(Sender: TObject);
    procedure EdtDocumentoEmitenteKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DateInicialKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DateFinalKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DeletarSPEDClick(Sender: TObject);
    procedure StgSPEDKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RdgSelecionarClick(Sender: TObject);
  private
    { Private declarations }
    oListaSPED: TObjectlist<TSPED>;
    Procedure iniciaGridSPED();
    procedure carregaGridSPED;
  public
    { Public declarations }
    oSPEDSelecionado: TSPED;
    oListaSPEDSelecionado: TObjectList<TSPED>;
    procedure selecionarArquivosSPED;
    procedure marcarTodosNenhum(bTodos: boolean);
  end;

var
  FrmListarSPED: TFrmListarSPED;

const
  _MARCADOR = ' X';
  _TODOS = 0;
  _NENHUM = 1;
  _NUMERO_COLUNA_MARCADOR = 0;

implementation

uses
  UnClasseUtils, UnClasseRegistroC100_Notas;

{$R *.dfm}

procedure TFrmListarSPED.ActFecharExecute(Sender: TObject);
begin
  Close();
end;

procedure TFrmListarSPED.FormShow(Sender: TObject);
begin
  iniciaGridSPED();
  oSPEDSelecionado := TSPED.Create();
  DateInicial.DateTime := now() - 665;
  DateFinal.DateTime := now();
end;

Procedure TFrmListarSPED.iniciaGridSPED();
begin
  limparGrid(StgSPED, 1);

  with StgSPED do
  begin
    FixedCols:= 0;

    Cells[0, 0]:= ' ';
    Cells[1, 0]:= 'ID SPED';
    Cells[2, 0]:= 'CNPJ';
    Cells[3, 0]:= 'Emitente';
    Cells[4, 0]:= 'Periodo Inicial';
    Cells[5, 0]:= 'Periodo Final';
    Cells[6, 0]:= 'Entrada';
  end;
end;

{procedure TFrmListarSPED.StgSPEDDblClick(Sender: TObject);
var
  I: Integer;
  auxC100: TRegistroC100;
begin
  oListaSPEDSelecionado := TObjectList<TSPED>.Create();
  for I := 0 to oListaSPED.Count - 1 do
  begin
    //if StgSPED.Cells[1, StgSPED.Row] = IntToStr(oListaSPED[i].Id_SPED) then
    if (StgSPED.Cells[_NUMERO_COLUNA_MARCADOR, i + 1] = _MARCADOR) then
    begin
      oSPEDSelecionado := oListaSPED[i];
      //carrega lista de C100
      auxC100:= TRegistroC100.Create();
      oSPEDSelecionado.ListaRegistrosC100 := auxC100.listar(IntToStr(oSPEDSelecionado.Id_SPED));
      oListaSPEDSelecionado.Add(oSPEDSelecionado);
    end;
  end;
  close();
end;}

procedure TFrmListarSPED.StgSPEDDblClick(Sender: TObject);
begin
  //marca linha ao qual foi dado double click
  if (StgSPED.Cells[_NUMERO_COLUNA_MARCADOR, StgSPED.Row] = _MARCADOR) then
      StgSPED.Cells[_NUMERO_COLUNA_MARCADOR, StgSPED.Row] := ''
  else
    StgSPED.Cells[_NUMERO_COLUNA_MARCADOR, StgSPED.Row] := _MARCADOR;
end;

procedure TFrmListarSPED.selecionarArquivosSPED;
var
  I: Integer;
  auxC100: TRegistroC100;
  auxPrimeiroCNPJ: string;
begin
  oListaSPEDSelecionado := TObjectList<TSPED>.Create();
  auxPrimeiroCNPJ := '';

  if (Application.MessageBox('Deseja selecionar mais arquivos?','Aviso',mb_yesno + MB_ICONWARNING + MB_DEFBUTTON2) = id_yes) then
    exit;

  for I := 0 to oListaSPED.Count - 1 do
  begin
    //if StgSPED.Cells[1, StgSPED.Row] = IntToStr(oListaSPED[i].Id_SPED) then
    if (StgSPED.Cells[_NUMERO_COLUNA_MARCADOR, i + 1] = _MARCADOR) then
    begin
      oSPEDSelecionado := oListaSPED[i];

      if auxPrimeiroCNPJ = '' then
        auxPrimeiroCNPJ := oSPEDSelecionado.Registro0000.CNPJ;

      //se o SPED for do mesmo emitente, carrega lista de C100
      if oSPEDSelecionado.Registro0000.CNPJ = auxPrimeiroCNPJ then
      begin
        auxC100:= TRegistroC100.Create();
        oSPEDSelecionado.ListaRegistrosC100 := auxC100.listar(IntToStr(oSPEDSelecionado.Id_SPED));
        oListaSPEDSelecionado.Add(oSPEDSelecionado);
      end;
    end;
  end;
  Close();
end;

procedure TFrmListarSPED.StgSPEDKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 32 then
  begin
    if (StgSPED.Cells[_NUMERO_COLUNA_MARCADOR, StgSPED.Row] = _MARCADOR) then
      StgSPED.Cells[_NUMERO_COLUNA_MARCADOR, StgSPED.Row] := ''
    else
      StgSPED.Cells[_NUMERO_COLUNA_MARCADOR, StgSPED.Row] := _MARCADOR;
  end
  else if key = VK_RETURN then
    selecionarArquivosSPED();
end;

procedure TFrmListarSPED.BtnListarClick(Sender: TObject);
begin
  carregaGridSPED();
end;

procedure TFrmListarSPED.carregaGridSPED();
var
  i: Integer;
  auxValor: double;
  auxQtde: integer;
  auxQtdeSelecionada: integer;
begin
  limparGrid(StgSPED, 1);
  auxValor:= 0;
  auxQtde:= 0;
  auxQtdeSelecionada:= 0;

  oListaSPED := TObjectList<TSPED>.Create();
  oListaSPED := oSPEDSelecionado.listar(true, EdtDocumentoEmitente.Text, DateInicial.DateTime, DateFinal.DateTime);
  with StgSPED do
  begin
    auxQtde := oListaSPED.Count;
    if oListaSPED.Count = 0 then
    begin
      StgSPED.RowCount:= 2;
      ShowMessage('Nenhum SPED foi encontrado.');
      LblQtdeSPEDEncontrados.Caption:= 'Nenhum SPED Encontrado';
      //LblTotalSPEDEncontrados.Caption:= 'Valor Total: R$ 0,00';
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

      //verifica se linha est� marcada
      //if (Cells[0, i + 1] = _MARCADOR) then
        //inc(auxQtdeSelecionada);
      //if oListaSPED[i].Vl_Doc <> '' then
        //auxValor := auxValor + StrToFloat(oListaSPED[i].Vl_Doc);
    end;

  end;
  //atualiza informa��o de totais
  LblQtdeSPEDEncontrados.Caption:= IntToStr(auxQtde) + ' SPED(s) encontrado(s)';
  //LblQtdeSPEDSelecionados.Caption:= IntToStr(auxQtdeSelecionada) + ' SPED(s) selecionado(s)';
  //LblTotalSPEDEncontrados.Caption:= 'Valor Total: R$ ' + FloatToStrF(auxValor,ffnumber,10,02);
end;

procedure TFrmListarSPED.DateFinalKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_RETURN :
    begin
      BtnListar.SetFocus();
    end;
  end;
end;

procedure TFrmListarSPED.DateInicialKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_RETURN :
    begin
      DateFinal.SetFocus();
    end;
  end;
end;

procedure TFrmListarSPED.DeletarSPEDClick(Sender: TObject);
var
  i: integer;
  auxSPED: TSPED;
begin
  If (Application.MessageBox('Deseja excluir permanentemente os arquivos selecionados?','Aviso',mb_yesno + MB_ICONWARNING + MB_DEFBUTTON2) = id_yes)
    AND (oListaSPED.Count > 0) then
  begin
    for i:= 0 to oListaSPED.Count - 1 do
    begin
      if (StgSPED.Cells[_NUMERO_COLUNA_MARCADOR, i + 1] = _MARCADOR) then
      begin
        auxSPED := oListaSPED[i];
        auxSPED.excluir();
      end;
    end;
    BtnListarClick(Self);
  end;
end;

procedure TFrmListarSPED.EdtDocumentoEmitenteExit(Sender: TObject);
begin
  EdtDocumentoEmitente.Text := retiraFormatacaoCPFCNPJ(EdtDocumentoEmitente.Text);
end;

procedure TFrmListarSPED.EdtDocumentoEmitenteKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case key of
    VK_RETURN :
    begin
      DateInicial.SetFocus();
    end;
  end;
end;

procedure TFrmListarSPED.marcarTodosNenhum(bTodos: boolean);
var
  i: Integer;
begin
  for i:= 1 to StgSPED.RowCount - 1 do
  begin
    if bTodos then
      StgSPED.Cells[_NUMERO_COLUNA_MARCADOR, i] := _MARCADOR
    else
      StgSPED.Cells[_NUMERO_COLUNA_MARCADOR, i] := '';
  end;
end;

procedure TFrmListarSPED.RdgSelecionarClick(Sender: TObject);
begin
  if RdgSelecionar.ItemIndex = 0 then
    marcarTodosNenhum(true)
  else if RdgSelecionar.ItemIndex = 1 then
    marcarTodosNenhum(false);

  StgSPED.SetFocus;
end;

end.
