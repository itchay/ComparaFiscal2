program comparaFiscal;

uses
  Vcl.Forms,
  UnClassePool_BD_IB in 'Classes\BD\UnClassePool_BD_IB.pas',
  UnClasseConexao_IB in 'Classes\BD\UnClasseConexao_IB.pas',
  UnConstantes in 'Classes\Utils\UnConstantes.pas',
  UnClasseComparaFiscal in 'Classes\Source\UnClasseComparaFiscal.pas',
  UnClasseVersao in 'Classes\Source\UnClasseVersao.pas',
  UnClasseLOG_Txt in 'Classes\Source\UnClasseLOG_Txt.pas',
  UnClasseConfiguracao in 'Classes\Source\UnClasseConfiguracao.pas',
  Vcl.Themes,
  Vcl.Styles,
  UnFrmArquivosSPED in 'UnFrmArquivosSPED.pas' {FrmArquivosSPED},
  UnFrmArquivosBaseDadosATF in 'UnFrmArquivosBaseDadosATF.pas' {FrmArquivosBaseDadosATF},
  UnFrmPrincipal in 'UnFrmPrincipal.pas' {FrmPrincipal},
  UnClasseUtils in 'Classes\Utils\UnClasseUtils.pas',
  UnClasseRegistro0000_Emitente in 'Classes\SPED\UnClasseRegistro0000_Emitente.pas',
  UnClasseRegistroC100_Notas in 'Classes\SPED\UnClasseRegistroC100_Notas.pas',
  UnClasseSPED in 'Classes\SPED\UnClasseSPED.pas',
  UnFrmListarSPED in 'UnFrmListarSPED.pas' {FrmListarSPED},
  UnClasseATF in 'Classes\ATF\UnClasseATF.pas',
  UnClasseATF_Emitente in 'Classes\ATF\UnClasseATF_Emitente.pas',
  UnClasseATF_Nota in 'Classes\ATF\UnClasseATF_Nota.pas',
  UnFrmListarATF in 'UnFrmListarATF.pas' {FrmListarATF},
  UnFrmRelatoriosComparativo in 'UnFrmRelatoriosComparativo.pas' {FrmRelatoriosComparativo},
  UnClasseOrdenacaoStringGrid in 'Classes\Utils\UnClasseOrdenacaoStringGrid.pas',
  UnClasseRegistro0150_Participante in 'Classes\SPED\UnClasseRegistro0150_Participante.pas',
  UnETipoParticipante in 'Classes\SPED\UnETipoParticipante.pas',
  UnClasseThread in 'Classes\Utils\UnClasseThread.pas';

{$R *.res}

begin
  //retorna conexões do compara fiscal
  PoolDeConexoes := TPool_BD_IB.Create();
  //cria variavel global da classe scanntech
  oComparaFiscal := TComparaFiscal.Create();

  Application.Initialize;
  Application.Title:= 'Compara Fiscal - Supera Solution';
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(TFrmArquivosSPED, FrmArquivosSPED);
  Application.CreateForm(TFrmArquivosBaseDadosATF, FrmArquivosBaseDadosATF);
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(TFrmListarSPED, FrmListarSPED);
  Application.CreateForm(TFrmListarATF, FrmListarATF);
  Application.CreateForm(TFrmRelatoriosComparativo, FrmRelatoriosComparativo);
  Application.Run;
end.
