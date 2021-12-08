unit UnClasseConfiguracao;

interface

uses
  Generics.Collections, XMLIntf, XMLDoc;

type
  TConfiguracao = class
  private
    function pegaNodeConfiguracao : IXMLNode;
    function pegaArquivoXML : TXMLDocument;

  public
    constructor Create();

  end;

implementation

uses
  SysUtils, Forms, Windows, Dialogs;//, NetEncoding;

{ TConfiguracao }

constructor TConfiguracao.Create();
var
  oNodeConfiguracao: IXMLNode;
  //Base64: TBase64Encoding;

  procedure retornaConfiguracaoDoXML(node : IXMLNode);
  var
    nome: String;
    i : Integer;
    nodeFilho : IXMLNode;
  begin
    for i := 0 to node.ChildNodes.Count - 1 do
    begin
      nodeFilho := node.ChildNodes[i];
      if (nodeFilho.ChildNodes.Count > 0) then
        retornaConfiguracaoDoXML(nodeFilho)
      else
      begin
        nome := node.NodeName;
        if (node.IsTextElement) then
        begin
          //If nome = 'Usuario' then
            //sUsuario := node.Text;
        end;
      end;

    end;

  end;
begin
  //pega informações do arquivo de configurações .xml
  oNodeConfiguracao := pegaNodeConfiguracao;
  if oNodeConfiguracao <> nil then
    retornaConfiguracaoDoXML(oNodeConfiguracao);
end;

function TConfiguracao.pegaNodeConfiguracao : IXMLNode;
begin
  try
    Result := pegaArquivoXML.DocumentElement.ChildNodes.FindNode('ComparaFiscal').ChildNodes.FindNode('Configuracao');
  except
    Application.MessageBox('Arquivo Config XML não encontrado!',
                            'Erro', MB_OK + MB_ICONERROR);
  end;
end;

function TConfiguracao.pegaArquivoXML : TXMLDocument;
var
  caminhoXML: String;
begin
  caminhoXML:= ExtractFilePath(ParamStr(0)) + 'configComparaFiscal.xml';
  if FileExists(caminhoXML) then
  begin
    Result := TXMLDocument.Create(Application);
    Result.Active:= True;
    Result.LoadFromFile(caminhoXML);
  end;
end;

end.
