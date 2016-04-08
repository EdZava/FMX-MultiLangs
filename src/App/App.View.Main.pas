unit App.View.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox, System.ImageList,
  FMX.ImgList;

type
  TfrmMainForm = class(TForm)
    btnTestMsg: TButton;
    btnLoad: TButton; lstIdiomas: TListBox;
    Label1: TLabel;
    lstTraducciones: TListBox;
    Label2: TLabel;
    lblAutoTraduccion: TLabel;
    procedure btnTestMsgClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure lstIdiomasChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function GetDirectoryLangs: string;
    procedure RefreshScreenIdiomasDisp;
  public
    { Public declarations }
  end;

var
  frmMainForm: TfrmMainForm;

resourcestring
  RS_Prueba = 'Traducción con Firemonkey!';

implementation

{$R *.fmx}

uses
  System.IOUtils,
  Comun.Utils.Langs;

function TfrmMainForm.GetDirectoryLangs: string;
var
  sDir: string;
begin
  sDir := ExtractFileDir( ParamStr(0) );
  sDir := TDirectory.GetParent( TDirectory.GetParent( TDirectory.GetParent(sDir) ) ); //Up 3 Directorys
  sDir := TPath.Combine(sDir, 'Langs');
  Result := sDir;
end;

procedure TfrmMainForm.btnLoadClick(Sender: TObject);
begin
  TLanguageUtils.Lang.FindAndAddAllLang( Self.GetDirectoryLangs );
  Self.RefreshScreenIdiomasDisp;
end;

procedure TfrmMainForm.RefreshScreenIdiomasDisp;
var
  i: Integer;
begin
  lstIdiomas.BeginUpdate;
  try
     for i := 0 to TLanguageUtils.Lang.Resources.Count-1 do
        lstIdiomas.Items.Add( Trim( TLanguageUtils.Lang.Resources.Strings[i] ) );
  finally
     lstIdiomas.EndUpdate;
  end;
end;

procedure TfrmMainForm.lstIdiomasChange(Sender: TObject);
var
  sIdioma: string;
  i: Integer;
begin
  lstTraducciones.BeginUpdate;
  try
     lstTraducciones.Clear;
     if lstIdiomas.ItemIndex > -1 then
     begin
        sIdioma    := lstIdiomas.Items[lstIdiomas.ItemIndex];
        TLanguageUtils.Lang.ChangeLang(sIdioma); //Change Idioma

        for i:=0 to TLanguageUtils.Lang.LangStr[sIdioma].Count-1 do
           lstTraducciones.Items.Add( Trim(TLanguageUtils.Lang.LangStr[sIdioma].Strings[i]) );
     end;
  finally
     lstTraducciones.EndUpdate;
  end;
end;

procedure TfrmMainForm.btnTestMsgClick(Sender: TObject);
begin
  ShowMessage( Translate(RS_Prueba) );
end;

procedure TfrmMainForm.FormCreate(Sender: TObject);
begin
  lblAutoTraduccion.Text := RS_Prueba;
end;

end.
