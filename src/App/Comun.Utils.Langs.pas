unit Comun.Utils.Langs;

interface

uses
  FMX.Types;

type
  { Class helper para TLang }
  TLangHelper = class helper for TLang
  protected
    procedure AddLangFormFile(inLangName: string; inFileName: string);
  public
    procedure FindAndAddAllLang(inDirectory: string; inFileExt: string='*.txt');
    procedure ChangeLang(inLangName: string);
  end;

  { Singleton gestor de Idiomas (unico en la app) }
  TLanguageUtils = class
  private
    class var FLang: TLang;
    class function GetLang: TLang; static;
  private
    { Private declarations }
  public
    class property Lang: TLang read GetLang;
  end;

implementation

uses
  System.Types,
  System.IOUtils,
  System.SysUtils;

{ TLangHelper }

procedure TLangHelper.FindAndAddAllLang(inDirectory, inFileExt: string);
var
  aFiles: TStringDynArray;
  i: Integer;
  sFile, sIdioma: string;
  sFileName: string;
begin
  aFiles := TDirectory.GetFiles(inDirectory, inFileExt);

  for i:=0 to Length(aFiles)-1 do
  begin
     sFile     := ExtractFileName(aFiles[i]);        //'ES.txt'
     sIdioma   := ChangeFileExt(sFile, '');          //Quitamos la Extension .txt y quedamos con la sigla del idioma | 'ES'
     sFileName := TPath.Combine(inDirectory, sFile); //Quedamos con ruta + filename completo.

     Self.AddLangFormFile(sIdioma, sFileName);
  end;
end;

procedure TLangHelper.AddLangFormFile(inLangName, inFileName: string);
begin
  if inLangName = '' then
     raise Exception.Create('Lang name is empty.');

  if not TFile.Exists(inFileName) then
     raise Exception.CreateFmt('FileName is not found. (%s)', [inLangName]);

  Self.AddLang(inLangName);
  Self.LangStr[inLangName].LoadFromFile(inFileName);
end;

procedure TLangHelper.ChangeLang(inLangName: string);
begin
  Self.Lang := inLangName;
end;

{ TLanguageUtils }

class function TLanguageUtils.GetLang: TLang;
begin
  if not Assigned(TLanguageUtils.FLang) then
  begin
     TLanguageUtils.FLang := TLang.Create(nil);
     TLanguageUtils.FLang.AutoSelect  := False;
     TLanguageUtils.FLang.StoreInForm := False;
  end;

  Result := TLanguageUtils.FLang;
end;

initialization
begin
  TLanguageUtils.FLang := nil;
end;

finalization
begin
  if Assigned(TLanguageUtils.FLang) then
     FreeAndNil(TLanguageUtils.FLang);
end;

end.
