unit FrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, Vcl.ComCtrls;

type
  TFrmPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    MenuArquivo: TMenuItem;
    MenuRelatorios: TMenuItem;
    MenuArquivosSPED: TMenuItem;
    Configuraes1: TMenuItem;
    Ajuda1: TMenuItem;
    MenuRelatoriosFinanceiro: TMenuItem;
    MenuArquivosBaseDados: TMenuItem;
    MenuCadastros: TMenuItem;
    Panel1: TPanel;
    Image1: TImage;
    Panel2: TPanel;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

end.
