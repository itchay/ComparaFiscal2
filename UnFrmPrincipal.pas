unit UnFrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, Vcl.ComCtrls, Vcl.StdCtrls, UnClasseComparaFiscal,
  System.Actions, Vcl.ActnList;

type
  TFrmPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    MenuArquivo: TMenuItem;
    MenuRelatorios: TMenuItem;
    MenuArquivosSPED: TMenuItem;
    Configuraes1: TMenuItem;
    Ajuda1: TMenuItem;
    MenuArquivosBaseDados: TMenuItem;
    MenuCadastros: TMenuItem;
    Panel1: TPanel;
    Image1: TImage;
    Panel2: TPanel;
    Label1: TLabel;
    LblVersao: TLabel;
    MenuRelatoriosComparativos: TMenuItem;
    ActionList1: TActionList;
    ActFechar: TAction;
    procedure FormShow(Sender: TObject);
    procedure MenuArquivosSPEDClick(Sender: TObject);
    procedure MenuArquivosBaseDadosClick(Sender: TObject);
    procedure MenuRelatoriosComparativosClick(Sender: TObject);
    procedure ActFecharExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

uses
  UnClasseVersao, UnFrmArquivosSPED, UnFrmArquivosBaseDadosATF,
  UnFrmRelatoriosComparativo;

{$R *.dfm}

procedure TFrmPrincipal.ActFecharExecute(Sender: TObject);
begin
  if Application.MessageBox('Os dados não salvos serão perdidos. Deseja continuar?','Aviso',mb_yesno + MB_ICONWARNING + MB_DEFBUTTON2) = id_yes then
    Close();
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  FrmPrincipal.Caption := FrmPrincipal.Caption + ' v ' + oComparaFiscal.Versao.ToString;
  LblVersao.Caption := 'v ' + oComparaFiscal.Versao.toString;
end;

procedure TFrmPrincipal.MenuArquivosSPEDClick(Sender: TObject);
begin
  try
    FrmArquivosSPED := TFrmArquivosSPED.Create(Self);
    FrmArquivosSPED.ShowModal();
  finally
    FreeAndNil(FrmArquivosSPED);
  end;
end;

procedure TFrmPrincipal.MenuArquivosBaseDadosClick(Sender: TObject);
begin
  try
    FrmArquivosBaseDadosATF := TFrmArquivosBaseDadosATF.Create(Self);
    FrmArquivosBaseDadosATF.ShowModal();
  finally
    FreeAndNil(FrmArquivosBaseDadosATF);
  end;
end;

procedure TFrmPrincipal.MenuRelatoriosComparativosClick(Sender: TObject);
begin
  try
    FrmRelatoriosComparativo := TFrmRelatoriosComparativo.Create(Self);
    FrmRelatoriosComparativo.ShowModal();
  finally
    FreeAndNil(FrmRelatoriosComparativo);
  end;
end;

end.
