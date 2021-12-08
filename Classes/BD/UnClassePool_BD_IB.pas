unit UnClassePool_BD_IB;

interface

uses
  System.Generics.Collections, XMLIntf, UnClasseConexao_IB, XMLDoc;

type

  TPool_BD_IB = class

  private

    bancosMapa : TDictionary<String, TConexao_IB>;

    procedure obtemListaDeBD_Do_XML;
    procedure criarBancosDoXML(node: IXMLNode);
    function pegaNodeBancoDeDados: IXMLNode;
    function pegaArquivoXML: TXMLDocument;

  public
    constructor Create();

    function getConexao(lNome: String): TConexao_IB;
    procedure criarConexao(nome, caminho : String);
    function adicionar(oConexao: TConexao_IB): Boolean;
    function excluir(lNome: String): Boolean;
    function abrir(lNome: String): Boolean;
    function qtdeConexoes(): Integer;
    function retornaNomesConexoesCX: TList<string>;
    procedure abrirConexoes;

    class function GetInstance : TPool_BD_IB;

  end;

var
  PoolDeConexoes : TPool_BD_IB;

implementation

uses
  SysUtils, StrUtils, Forms, Windows, Dialogs;

{ TPool_BD_IB }

class function TPool_BD_IB.GetInstance: TPool_BD_IB;
begin
  if (PoolDeConexoes = Nil) then
    PoolDeConexoes := TPool_BD_IB.Create;
  Result := PoolDeConexoes;
end;

constructor TPool_BD_IB.Create();
begin
  bancosMapa:= TDictionary<String, TConexao_IB>.Create();
  obtemListaDeBD_Do_XML;
  //abrirConexoes;
end;

procedure TPool_BD_IB.criarConexao(nome, caminho : String);
begin
  if not bancosMapa.ContainsKey(nome) then
    adicionar(TConexao_IB.Create(nome, caminho))
  else
    raise Exception.Create('Já existe uma conexão com o nome ' + QuotedStr(nome) + '.' + #13 + #13 +
                           'Revise a configuração do sistema!');
end;

procedure TPool_BD_IB.obtemListaDeBD_Do_XML;
var
  oNodeBancoDeDados: IXMLNode;
begin
  oNodeBancoDeDados := pegaNodeBancoDeDados;
  if oNodeBancoDeDados <> nil then
      criarBancosDoXML(oNodeBancoDeDados);
end;

function TPool_BD_IB.pegaNodeBancoDeDados : IXMLNode;
begin
  try
    Result := pegaArquivoXML.DocumentElement.ChildNodes.FindNode('ComparaFiscal').ChildNodes.FindNode('BancosDeDados');
  except
    Application.MessageBox('Arquivo Config XML não encontrado!',
                            'Erro', MB_OK + MB_ICONERROR);
  end;
end;

function TPool_BD_IB.pegaArquivoXML : TXMLDocument;
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

procedure TPool_BD_IB.criarBancosDoXML(node : IXMLNode);
var
  nome, caminho : String;
  i : Integer;
  nodeFilho : IXMLNode;
begin
  for i := 0 to node.ChildNodes.Count - 1 do
  begin
    nodeFilho := node.ChildNodes[i];
    if (nodeFilho.ChildNodes.Count > 0) then
      criarBancosDoXML(nodeFilho)
    else
    begin
      nome := node.NodeName;
      if node.IsTextElement then
      begin
        caminho := node.Text;
        try
          criarConexao(nome, caminho);
        except on E: Exception do
          ShowMessage(e.Message);
        end;
      end;
    end;
  end;
end;

function TPool_BD_IB.abrir(lNome: String): Boolean;
begin
  if bancosMapa.ContainsKey(lNome) then
    Result := bancosMapa.Items[lNome].abrir;
end;

procedure TPool_BD_IB.abrirConexoes();
var
  banco : TConexao_IB;
begin
  for banco in bancosMapa.Values do
  begin
    banco.abrir();
  end;
end;

function TPool_BD_IB.adicionar(oConexao: TConexao_IB): Boolean;
begin
  if not bancosMapa.ContainsKey(oConexao.name) then
    bancosMapa.Add(oConexao.name, oConexao)
  else
    raise Exception.Create('Conexão já adicionada!');
end;

function TPool_BD_IB.excluir(lNome: String): Boolean;
begin
  Result := bancosMapa.ContainsKey(lNome);
  if Result then
    bancosMapa.Remove(lNome);
end;

function TPool_BD_IB.getConexao(lNome: String): TConexao_IB;
begin
  if bancosMapa.ContainsKey(lNome) then
    Result := bancosMapa.Items[lNome]
  else
    Result := Nil;
end;

function TPool_BD_IB.qtdeConexoes: Integer;
begin
  Result:= bancosMapa.Count;
end;

function TPool_BD_IB.retornaNomesConexoesCX: TList<string>;
var
  banco : TConexao_IB;
begin
  result := TList<string>.Create();

  for banco in bancosMapa.Values do
  begin
    if ContainsText(banco.name,'Caixa') then
      Result.Add(banco.name);
  end;
end;

end.

