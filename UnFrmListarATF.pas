unit UnFrmListarATF;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  System.Actions, Vcl.ActnList, Vcl.Grids, Vcl.ComCtrls, UnClasseATF, System.IOUtils, Generics.collections,
  Vcl.Menus;

type
  TFrmListarATF = class(TForm)
    PnlInfoDoc: TPanel;
    GroupBox4: TGroupBox;
    EdtDocumentoEmitente: TEdit;
    GroupBox3: TGroupBox;
    DateFinal: TDateTimePicker;
    StgATF: TStringGrid;
    GroupBox5: TGroupBox;
    LblQtdeATFEncontrados: TLabel;
    LblTotalATFEncontrados: TLabel;
    GroupBox1: TGroupBox;
    DateInicial: TDateTimePicker;
    BitBtn1: TBitBtn;
    BtnListar: TBitBtn;
    ActionList1: TActionList;
    ActFechar: TAction;
    PopupMenu1: TPopupMenu;
    DeletarATF: TMenuItem;
    Label1: TLabel;
    RdgSelecionar: TRadioGroup;
    procedure ActFecharExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnListarClick(Sender: TObject);
    procedure EdtDocumentoEmitenteExit(Sender: TObject);
    procedure EdtDocumentoEmitenteKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DateInicialKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DateFinalKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DeletarATFClick(Sender: TObject);
    procedure StgATFKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure StgATFDblClick(Sender: TObject);
    procedure marcarTodosNenhum(bTodos: boolean);
    procedure RdgSelecionarClick(Sender: TObject);
  private
    { Private declarations }
    oListaATF: TObjectlist<TATF>;
    Procedure iniciaGridATF();
    procedure carregaGridATF;
  public
    { Public declarations }
    oATFSelecionado: TATF;
    oListaATFSelecionados: TObjectlist<TATF>;
    procedure selecionarArquivosATF();
  end;

var
  FrmListarATF: TFrmListarATF;

const
  _MARCADOR = ' X';
  _TODOS = 0;
  _NENHUM = 1;
  _NUMERO_COLUNA_MARCADOR = 0;

implementation

uses
  UnClasseUtils, UnClasseATF_Nota;

{$R *.dfm}

procedure TFrmListarATF.ActFecharExecute(Sender: TObject);
begin
  Close();
end;

procedure TFrmListarATF.FormShow(Sender: TObject);
begin
  iniciaGridATF();
  oATFSelecionado := TATF.Create();
  DateInicial.DateTime := now() - 665;
  DateFinal.DateTime := now();
end;

Procedure TFrmListarATF.iniciaGridATF();
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

procedure TFrmListarATF.selecionarArquivosATF;
var
  I: Integer;
  auxNota: TATF_Nota;
  auxPrimeiroCNPJ: string;
begin
  oListaATFSelecionados := TObjectList<TATF>.Create();
  auxPrimeiroCNPJ := '';

  if (Application.MessageBox('Deseja selecionar mais arquivos?','Aviso',mb_yesno + MB_ICONWARNING + MB_DEFBUTTON2) = id_yes) then
    exit;

  for I := 0 to oListaATF.Count - 1 do
  begin
    //if StgATF.Cells[1, StgATF.Row] = IntToStr(oListaATF[i].Id_ATF) then
    if (StgATF.Cells[_NUMERO_COLUNA_MARCADOR, i + 1] = _MARCADOR) then
    begin
      oATFSelecionado := oListaATF[i];

      //se o atf for do mesmo emitente, carrega lista de C100
      if auxPrimeiroCNPJ = '' then
        auxPrimeiroCNPJ := oATFSelecionado.Emitente.CNPJ;

      if oATFSelecionado.Emitente.CNPJ = auxPrimeiroCNPJ then
      begin
        auxNota:= TATF_Nota.Create();
        oATFSelecionado.ListaNotas := auxNota.listar(IntToStr(oATFSelecionado.Id_ATF));
        oListaATFSelecionados.Add(oATFSelecionado);
      end;
    end;
  end;
  Close();
end;

procedure TFrmListarATF.StgATFDblClick(Sender: TObject);
begin
  //marca linha ao qual foi dado double click
  if (StgATF.Cells[_NUMERO_COLUNA_MARCADOR, StgATF.Row] = _MARCADOR) then
      StgATF.Cells[_NUMERO_COLUNA_MARCADOR, StgATF.Row] := ''
  else
    StgATF.Cells[_NUMERO_COLUNA_MARCADOR, StgATF.Row] := _MARCADOR;
end;

procedure TFrmListarATF.StgATFKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 32 then
  begin
    if (StgATF.Cells[_NUMERO_COLUNA_MARCADOR, StgATF.Row] = _MARCADOR) then
      StgATF.Cells[_NUMERO_COLUNA_MARCADOR, StgATF.Row] := ''
    else
      StgATF.Cells[_NUMERO_COLUNA_MARCADOR, StgATF.Row] := _MARCADOR;
  end
  else if key = VK_RETURN then
    selecionarArquivosATF();
end;

procedure TFrmListarATF.BtnListarClick(Sender: TObject);
begin
  carregaGridATF();
end;

procedure TFrmListarATF.carregaGridATF();
var
  i: Integer;
  auxValor: double;
  auxQtde: integer;
begin
  limparGrid(StgATF, 1);
  auxValor:= 0;
  auxQtde:= 0;

  oListaATF := TObjectList<TATF>.Create();
  oListaATF := oATFSelecionado.listar(true, EdtDocumentoEmitente.Text, DateInicial.DateTime, DateFinal.DateTime);
  with StgATF do
  begin
    auxQtde := oListaATF.Count;
    if oListaATF.Count = 0 then
    begin
      StgATF.RowCount:= 2;
      ShowMessage('Nenhum ATF foi encontrado.');
      LblQtdeATFEncontrados.Caption:= 'Nenhum ATF Encontrado';
      //LblTotalATFEncontrados.Caption:= 'Valor Total: R$ 0,00';
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

      //if oListaATF[i].Vl_Doc <> '' then
        //auxValor := auxValor + StrToFloat(oListaATF[i].Vl_Doc);
    end;

  end;
  //atualiza informação de totais
  LblQtdeATFEncontrados.Caption:= IntToStr(auxQtde) + ' ATF(s) encontrado(s)';
  //LblTotalATFEncontrados.Caption:= 'Valor Total: R$ ' + FloatToStrF(auxValor,ffnumber,10,02);
end;

procedure TFrmListarATF.DateFinalKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_RETURN :
    begin
      BtnListar.SetFocus();
    end;
  end;
end;

procedure TFrmListarATF.DateInicialKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_RETURN :
    begin
      DateFinal.SetFocus();
    end;
  end;
end;

procedure TFrmListarATF.DeletarATFClick(Sender: TObject);
var
  i: integer;
  auxATF: TATF;
begin
  If (Application.MessageBox('Deseja excluir permanentemente os arquivos selecionados?','Aviso',mb_yesno + MB_ICONWARNING + MB_DEFBUTTON2) = id_yes)
    AND (oListaATF.Count > 0) then
  begin
    for i:= 0 to oListaATF.Count - 1 do
    begin
      if (StgATF.Cells[_NUMERO_COLUNA_MARCADOR, i + 1] = _MARCADOR) then
      begin
        auxATF := oListaATF[i];
        auxATF.excluir();
      end;
    end;
    BtnListarClick(Self);
  end;
end;

procedure TFrmListarATF.EdtDocumentoEmitenteExit(Sender: TObject);
var
  auxCNPJSemFormatacao: string;

  function insereFormatacaoCNPJ(sCNPJ:string): string;
  begin
    if Length(sCNPJ) = 14 then
      result := copy(sCNPJ,1,2) + '.'
              + copy(sCNPJ,3,3) + '.'
              + copy(sCNPJ,6,3) + '/'
              + copy(sCNPJ,9,4) + '-'
              + copy(sCNPJ,13,2);
  end;
begin
  auxCNPJSemFormatacao := retiraFormatacaoCPFCNPJ(EdtDocumentoEmitente.Text);
  EdtDocumentoEmitente.Text := insereFormatacaoCNPJ(auxCNPJSemFormatacao);
end;

procedure TFrmListarATF.EdtDocumentoEmitenteKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case key of
    VK_RETURN :
    begin
      DateInicial.SetFocus();
    end;
  end;
end;

procedure TFrmListarATF.marcarTodosNenhum(bTodos: boolean);
var
  i: Integer;
begin
  for i:= 1 to StgATF.RowCount - 1 do
  begin
    if bTodos then
      StgATF.Cells[_NUMERO_COLUNA_MARCADOR, i] := _MARCADOR
    else
      StgATF.Cells[_NUMERO_COLUNA_MARCADOR, i] := '';
  end;
end;

procedure TFrmListarATF.RdgSelecionarClick(Sender: TObject);
begin
  if RdgSelecionar.ItemIndex = 0 then
    marcarTodosNenhum(true)
  else if RdgSelecionar.ItemIndex = 1 then
    marcarTodosNenhum(false);

  StgATF.SetFocus;
end;

end.
