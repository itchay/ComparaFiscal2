object FrmListarSPED: TFrmListarSPED
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Listar - Arquivos SPED'
  ClientHeight = 483
  ClientWidth = 856
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 231
    Top = 464
    Width = 618
    Height = 13
    Alignment = taCenter
    Caption = 
      'Barra de espa'#231'o = marca arquivos; Enter = confirma sele'#231#227'o de ar' +
      'quivos; Delete = deleta arquivos marcados.'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object PnlInfoDoc: TPanel
    Left = 4
    Top = 7
    Width = 847
    Height = 453
    TabOrder = 0
    object LblQtdeSPEDEncontrados: TLabel
      Left = 10
      Top = 434
      Width = 9
      Height = 13
      Caption = '...'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object LblQtdeSPEDSelecionados: TLabel
      Left = 248
      Top = 433
      Width = 9
      Height = 13
      Caption = '...'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Visible = False
    end
    object GroupBox4: TGroupBox
      Left = 332
      Top = 14
      Width = 137
      Height = 41
      Caption = ' CNPJ Emitente '
      TabOrder = 1
      object EdtDocumentoEmitente: TEdit
        Left = 1
        Top = 16
        Width = 136
        Height = 21
        TabOrder = 0
        OnExit = EdtDocumentoEmitenteExit
        OnKeyDown = EdtDocumentoEmitenteKeyDown
      end
    end
    object GroupBox3: TGroupBox
      Left = 614
      Top = 14
      Width = 102
      Height = 41
      Caption = ' Data Final '
      TabOrder = 2
      object DateFinal: TDateTimePicker
        Left = 1
        Top = 16
        Width = 100
        Height = 21
        Date = 44300.155585694440000000
        Time = 44300.155585694440000000
        TabOrder = 0
        OnKeyDown = DateFinalKeyDown
      end
    end
    object StgSPED: TStringGrid
      Left = 2
      Top = 83
      Width = 843
      Height = 349
      Hint = 
        'Barra de espa'#231'o = marca arquivos; Delete = deleta arquivos marca' +
        'dos'
      ColCount = 7
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goColMoving]
      ParentShowHint = False
      PopupMenu = PopupMenu1
      ShowHint = True
      TabOrder = 3
      OnDblClick = StgSPEDDblClick
      OnKeyDown = StgSPEDKeyDown
      ColWidths = (
        25
        90
        110
        320
        80
        80
        150)
      RowHeights = (
        24
        24
        24
        24
        24)
    end
    object GroupBox5: TGroupBox
      Left = 2
      Top = 59
      Width = 843
      Height = 23
      Caption = ' Lista de Arquivos SPED '
      TabOrder = 4
    end
    object GroupBox1: TGroupBox
      Left = 508
      Top = 14
      Width = 102
      Height = 41
      Caption = ' Data Inicial '
      TabOrder = 5
      object DateInicial: TDateTimePicker
        Left = 1
        Top = 16
        Width = 100
        Height = 21
        Date = 44300.155585694440000000
        Time = 44300.155585694440000000
        TabOrder = 0
        OnKeyDown = DateInicialKeyDown
      end
    end
    object BitBtn1: TBitBtn
      Left = 470
      Top = 26
      Width = 20
      Height = 26
      Glyph.Data = {
        F6060000424DF606000000000000360000002800000018000000180000000100
        180000000000C0060000120B0000120B00000000000000000000FF00FFFF00FF
        FF00FFFF00FF24B8FF24B8FF24B8FF24B8FF24B8FF24B8FF24B8FF24B8FF24B8
        FF24B8FF24B8FF24B8FF24B8FF24B8FF24B8FF24B8FFFF00FFAAAAAAABAAABFF
        00FFFF00FFFF00FFFF00FF24B8FF20B4FF22B6FF3CC1FF4DCBFF4FCFFF4ACFFF
        46D0FF4AD3FF4FD7FF54DAFF58DDFF57DCFF50D7FF42CFFF3BCAFF43B7EA9A9A
        9AD9D9D98A8A8A9B9A9BFF00FFFF00FFFF00FF24B8FF2EB8FF4AC9FF8BE0FFAE
        EBFFA7ECFF8EE8FF7EE6FF85E9FF8DECFF94EFFF98F1FF98F1FF8DEDFF76E4FF
        59D1F88598A0D0D1D1898989A2A4A4FF00FFFF00FFFF00FFFF00FF24B8FF5DCF
        FF4FCDFF89DFFFADEBFFA5EBFF8CE7FF7AE4FF80E7FF87EAFF8DEDFF90EEFF8F
        EEFF86EAFF72E2FF7FA6B2C2C3C39090909E9F9FFF00FFFF00FFFF00FFFF00FF
        FF00FF24B8FF6BD3FF4DCDFF88DFFFACEAFFA3EAFF89E5FF76E2FF7BE5FF81E8
        FF85E9FF87EAFF87EAFF7FE7FF7ABCCDAFB0B0999999989A9AFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FF24B8FF79D8FF4CCCFF86DEFFAAEAFFA0E9FF85E3FF
        70E0FF77D7F17ECEE381D0E382D6EA7EE7FF7CD4EAA0A0A0A1A2A295969652AC
        D7FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF24B8FF89DCFF4ACCFF85DEFFA7
        E9FF9DE8FF83D2EA7D9AA27E7E7E92919199979894929389969A92989BA4A4A5
        8E909051AEDB24B8FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF24B8FF97E1
        FF47CCFF83DDFFA5E8FF96CBDC7991999CB8C0D7DCDEE5F2F6FEFFFFFBFBFBD5
        D3D4A5A2A38C8B8B6CB6D121B4FF24B8FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FF24B8FFA7E6FF45CBFF80DDFFA1E0F581959CABC3C9D4F2FAD5F3FBD5F3
        FBE4F6FBFDFDFAFEFDFBEAE9E7B0ABAD67A7BE1EB2FF24B8FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FF24B8FFB6EAFF43CBFF7EDDFF95BCC88C9FA2D9EEEF
        D2F0F5D3F0F6D3F0F6D4F0F6E6F4F6FEFAF4FEFAF5DFDBD89C999A22A8F024B8
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF24B8FFC4EEFF6ED8FF7BDDFF80
        9499BBC9C6D6EBEAD0ECF1D0EDF1D0EDF2D1EDF2DCF0F1FEF6EEFEF7EEF4EDE6
        ADA9A978B4CC24B8FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF24B8FF5ECF
        FFA9E8FFCAF1FF909697DAD7CBF1EEE2F2F3ECF2F3ECF2F3ECF2F3EDF3F3EDFD
        F3E7FDF3E8FDF3E7AFA9A67AAFC624B8FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FF24B8FF20B4FF27B7FF3DC2FF6B8B96B7CAC4CDE1DBCDE7E7CEE8E8CFE9
        E8D0EAE9D4E9E5FCEDDCFCEEDEFBEEE0B0AAA660A8C624B8FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FF24B8FF2DB8FF4ECAFF8DE1FF8A9DA2AEB3AADEE4D5
        DBE7DCDCEAE1DFE9DEE0ECE1E9EEE3FCEEDDFCEEDDF0E4D5A7A2A149AEDC24B8
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF24B8FF5DCFFF51CDFF8CE0FF9F
        C0CB869190D5DBCDDBEBE5DCECE6DEEDE6DFEEE6ECEEE2FCEEDDFAECDCD1C8BE
        93999C29BCFF24B8FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF24B8FF6BD4
        FF50CDFF8AE0FFABE7FA8FA4AB8D9C99CBDAD2DBECE6DCECE6E8EDE3FCEEDDF7
        EAD9CFC5BA9B96956DBCD427BBFF24B8FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FF24B8FF79D8FF4ECDFF89DFFFAAEAFF9DDBEE89A3AA839798ABB7B1C7CB
        C1D7CBBDCABEB0AEA49B9B969475BFD455D5FF25B9FF24B8FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FF24B8FF88DCFF4CCDFF87DFFFA8E9FF9CE8FF81DDF8
        7CB6C68D999D948F8D948F8B96929189AAB378CCE360DAFF50D2FF23B7FF24B8
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF24B8FF97E1FF4ACCFF85DEFFA6
        E8FF99E6FF7BE0FF63DBFF67DDFF6ADEFF6DDFFF6EE0FF6EE0FF68DDFF5AD6FF
        4ACFFF21B5FF24B8FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF24B8FFA6E5
        FF48CCFF83DEFFA4E8FF96E5FF75DDFF5CD8FF5FD9FF62DBFF64DCFF65DCFF65
        DCFF60DAFF53D3FF45CDFF1EB2FF24B8FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FF24B8FFB5EAFF45CCFF80DEFFA1E8FF92E5FF70DCFF55D5FF57D6FF5AD7
        FF5CD8FF5DD9FF5DD9FF58D6FF4CD0FF3FC9FF1CB0FF24B8FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FF24B8FFC4EEFF56D1FF7EDEFF9FE7FF8FE5FF6BDBFF
        4FD4FF50D4FF52D4FF54D5FF54D5FF54D5FF50D3FF45CDFF4DCDFF6BD5FF24B8
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF24B8FF7CD9FFCAF1FFCFF3FFD3
        F4FFD4F5FFD2F5FFD1F4FFD1F4FFD2F4FFD2F4FFD3F4FFD3F4FFD1F4FFCFF2FF
        C3EEFF7ED9FF24B8FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF24B8
        FF24B8FF24B8FF24B8FF24B8FF24B8FF24B8FF24B8FF24B8FF24B8FF24B8FF24
        B8FF24B8FF24B8FF24B8FF24B8FFFF00FFFF00FFFF00FFFF00FF}
      TabOrder = 6
      Visible = False
    end
    object BtnListar: TBitBtn
      Left = 720
      Top = 20
      Width = 99
      Height = 32
      Caption = 'Listar'
      Glyph.Data = {
        F6060000424DF606000000000000360000002800000018000000180000000100
        180000000000C0060000120B0000120B00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FF7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B
        7B7B7B7B7A7A7A7A7A7A7A7A7A7A7A7A7A7A7A7A7A7A7A7A7A7A7A7A7A7A7AFF
        00FFFF00FF4086AF4086AF4086AF4086AF3E83AC397EA8868686FDFDFDF8F8F8
        C3CCDFF8F8F8F9F9F9F9F9F9F9F9F9F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
        F8FDFDFD828282FF00FFFF00FF4388AF579FC168B1CF69B2D06AB4D16BB5D290
        9090F8F8F8E5E5E5C3CCDFE6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E5E5E5E5E5E5
        E4E4E4E4E4E4E4E4E4F8F8F88C8C8CFF00FFFF00FF478CB369B2D06AB3D16BB4
        D26CB6D36DB7D4989898959596E9D0BAC3CCDFE9D0BAE9D0BAE9D0BAE9D0BAE9
        D0BAE9D0BAE9D0BAE9D0BAE9D0BAE9D0BAE9D0BA959595FF00FFFF00FF498CB3
        6AB4D16BB5D26CB6D36DB8D46EBAD5A0A0A0FAFAFAEAEAEAC3CCDFEBEBEBEBEB
        EBEBEBEBEBEBEBEAEAEAEAEAEAE9E9E9E9E9E9E8E8E8E7E7E7F9F9F99D9D9DFF
        00FFFF00FF4E91B76CB6D36DB7D46EB9D56EBAD66FBCD7A6A6A6E9D0BAE9D0BA
        C3CCDFE9D0BAE9D0BAE9D0BAE9D0BAE9D0BAE9D0BAE9D0BAE9D0BAE9D0BAE9D0
        BAE9D0BAA4A4A4FF00FFFF00FF5296BB6DB8D46EB9D56FBBD670BDD771BED8AB
        ABABFBFBFBEEEEEEC3CCDFEFEFEFEFEFEFEFEFEFEFEFEFEEEEEEEEEEEEEDEDED
        ECECECECECECEBEBEBFAFAFAA9A9A9FF00FFFF00FF5B9EC16EBAD66FBCD770BD
        D871BFD972C0DAB0B0B0E9D0BAE9D0BAC3CCDFE9D0BAE9D0BAE9D0BAE9D0BAE9
        D0BAE9D0BAE9D0BAE9D0BAE9D0BAE9D0BAE9D0BAAFAFAFFF00FFFF00FF60A3C5
        70BDD771BED872BFD973C1DB74C2DCB4B4B4FBFBFBF1F1F1C3CCDFF2F2F2F2F2
        F2F2F2F2F2F2F2F2F2F2F1F1F1F1F1F1F0F0F0EFEFEFEEEEEEFBFBFBB3B3B3FF
        00FFFF00FF67A7C771BFD972C0DA73C1DB74C3DD75C4DEB7B7B7959596E9D0BA
        C3CCDFE9D0BAE9D0BAE9D0BAE9D0BAE9D0BAE9D0BAE9D0BAE9D0BAE9D0BAE9D0
        BAE9D0BAB6B6B6FF00FFFF00FF6BA9C873C1DB74C2DC75C3DD76C5DE77C6DFBA
        BABAF4F4F4F4F4F4C3CCDFF5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F4F4F4F4F4F4
        F3F3F3F2F2F2F1F1F1FBFBFBB9B9B9FF00FFFF00FF6FADCB74C3DD75C4DE76C5
        DF77C7E078C8E1BCBCBCE9D0BAE9D0BAC3CCDFE9D0BAE9D0BAE9D0BAE9D0BAE9
        D0BAE9D0BAE9D0BAE9D0BAE9D0BAE9D0BAE9D0BABBBBBBFF00FFFF00FF78B5D0
        76C5DE77C6DF78C7E079C9E17ACAE2BDBDBDFDFDFDF7F7F7C3CCDFF8F8F8F8F8
        F8F8F8F8F8F8F8F7F7F7F7F7F7F6F6F6F5F5F5F4F4F4F3F3F3FCFCFCBDBDBDFF
        00FFFF00FF74B1CE77C7E078C8E179C9E27ACBE37BCCE4BEBEBEE9D0BAE9D0BA
        C3CCDFE9D0BAE9D0BAE9D0BAE9D0BAE9D0BAE9D0BAE9D0BAE9D0BAE9D0BAE9D0
        BAE9D0BABEBEBEFF00FFFF00FF79B6D178C9E179CAE27ACBE37BCDE47CCEE5BF
        BFBFFDFDFDF8F8F8C3CCDFFAFAFAFAFAFAFAFAFAFAFAFAF9F9F9F9F9F9F8F8F8
        F7F7F7F6F6F6F5F5F5FCFCFCBFBFBFFF00FFFF00FF79B6D27ACBE37BCCE47CCD
        E57DCFE67ED0E7BFBFBF959596E9D0BAC3CCDFE9D0BAE9D0BAE9D0BAE9D0BAE9
        D0BAE9D0BAE9D0BAE9D0BAE9D0BAE9D0BAE9D0BABFBFBFFF00FFFF00FF7AB7D2
        7BCDE47CCEE57DCFE67ED1E77FD2E8C0C0C0FEFEFEFAFAFAC3CCDFFBFBFBFBFB
        FBFBFBFBFBFBFBFBFBFBFAFAFAF9F9F9ABABABBCBCBCC6C6C6C8C8C8C0C0C0FF
        00FFFF00FF7BB7D27DCFE67ED0E77FD1E880D3E981D4EAC0C0C0E9D0BAE9D0BA
        C3CCDFE9D0BAE9D0BAE9D0BAE9D0BAE9D0BAE9D0BAE9D0BAB8B8B8FBFBFBD4D4
        D4C0C0C0FF00FFFF00FFFF00FF7BB8D37ED1E77FD2E868686868686868686868
        6868686868686868686868686868686868686868686868686868FBFBFBFAFAFA
        CCCCCCDCDCDCC0C0C0FF00FFFF00FFFF00FFFF00FF7BB8D380D3E981D4EA708A
        917D7F7F7D7F7F7B7C7CA4A7A7AFB7BAB4BEC1B1B8BA7D7E7E8082827E7F7F8E
        8E8EFEFEFEFDFDFDD0D0D0C0C0C0FF00FFFF00FFFF00FFFF00FFFF00FF7CB9D4
        81D5EA82D6EB83D7EC848787D2DBDD8C8E8EA2A4A5BAC1C3BFC8CAAFB4B69191
        91C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0B8BEC0FF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FF7DBAD582C9E184D8ED85D9EE8F9292EAF3F4909393A0A2A2C0C7C8
        C8D0D2ADB2B38F9293DEE4E5A0A2A28FE9FA90EBFB8ADAEE78C2DCFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FF7DBAD57DBAD57DBAD57EBBD59A9D9DA0A2A2A0
        A2A2848787B0B5B6B4B9BA848787A0A2A2A0A2A2A0A2A27BBCD678C2DC78C2DC
        78C2DCFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FF848787848787FF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      TabOrder = 7
      OnClick = BtnListarClick
    end
    object RdgSelecionar: TRadioGroup
      Left = 128
      Top = 14
      Width = 185
      Height = 41
      Caption = 'Selecionar'
      Columns = 2
      Items.Strings = (
        'Todos'
        'Nenhum')
      TabOrder = 0
      OnClick = RdgSelecionarClick
    end
  end
  object ActionList1: TActionList
    Left = 100
    Top = 15
    object ActFechar: TAction
      Caption = 'ActFechar'
      ShortCut = 27
      OnExecute = ActFecharExecute
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 28
    Top = 15
    object DeletarSPED: TMenuItem
      Caption = 'Deletar/Excluir'
      ShortCut = 46
      OnClick = DeletarSPEDClick
    end
  end
end