unit Popup_Reconstruction;

{$MODE Delphi}

{ Version vom 7.9.2019 }

interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, defaults;

type
  TPopup_Reconstruct = class(TForm)
    Check_CP: TCheckBox;
    Check_C1: TCheckBox;
    Check_C2: TCheckBox;
    Check_C3: TCheckBox;
    Check_C4: TCheckBox;
    Check_CL: TCheckBox;
    Check_CMie: TCheckBox;
    Check_CY: TCheckBox;
    Check_S: TCheckBox;
    Check_n: TCheckBox;
    Check_TW: TCheckBox;
    Check_Q: TCheckBox;
    Check_rho_L: TCheckBox;
    Check_rho_dd: TCheckBox;
    Check_dummy: TCheckBox;
    Check_rho_ds: TCheckBox;
    Check_beta: TCheckBox;
    Check_alpha: TCheckBox;
    Check_f_dd: TCheckBox;
    Check_f_ds: TCheckBox;
    Check_H_oz: TCheckBox;
    Check_WV: TCheckBox;
    Check_f: TCheckBox;
    Check_g_dsr: TCheckBox;
    GroupSaveErr: TGroupBox;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    Check_C5: TCheckBox;
    Check_z: TCheckBox;
    Check_zB: TCheckBox;
    Check_sun: TCheckBox;
    Check_view: TCheckBox;
    Check_dphi: TCheckBox;
    Check_fA0: TCheckBox;
    Check_fA1: TCheckBox;
    Check_fA2: TCheckBox;
    Check_fA3: TCheckBox;
    Check_fA4: TCheckBox;
    Check_fA5: TCheckBox;
    Check_CD: TCheckBox;
    Check_g_dd: TCheckBox;
    Check_g_dsa: TCheckBox;
    Check_delta_r: TCheckBox;
    Check_beta_d: TCheckBox;
    Check_alpha_d: TCheckBox;
    Check_gamma_d: TCheckBox;
    Check_delta_d: TCheckBox;
    Check_fluo: TCheckBox;
    Check_test: TCheckBox;
    Check_f_nw: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure set_temp_parameters(Sender: TObject);
    procedure define_temp_parameters(Sender: TObject);
    procedure Check_CPClick(Sender: TObject);
    procedure Check_C1Click(Sender: TObject);
    procedure Check_C2Click(Sender: TObject);
    procedure Check_C3Click(Sender: TObject);
    procedure Check_C4Click(Sender: TObject);
    procedure Check_CLClick(Sender: TObject);
    procedure Check_CMieClick(Sender: TObject);
    procedure Check_CYClick(Sender: TObject);
    procedure Check_SClick(Sender: TObject);
    procedure Check_nClick(Sender: TObject);
    procedure Check_TWClick(Sender: TObject);
    procedure Check_QClick(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure Check_C5Click(Sender: TObject);
    procedure Check_rho_LClick(Sender: TObject);
    procedure Check_rho_ddClick(Sender: TObject);
    procedure Check_dummyClick(Sender: TObject);
    procedure Check_rho_dsClick(Sender: TObject);
    procedure Check_betaClick(Sender: TObject);
    procedure Check_alphaClick(Sender: TObject);
    procedure Check_f_ddClick(Sender: TObject);
    procedure Check_f_dsClick(Sender: TObject);
    procedure Check_H_ozClick(Sender: TObject);
    procedure Check_WVClick(Sender: TObject);
    procedure Check_fClick(Sender: TObject);
    procedure Check_zClick(Sender: TObject);
    procedure Check_zBClick(Sender: TObject);
    procedure Check_sunClick(Sender: TObject);
    procedure Check_viewClick(Sender: TObject);
    procedure Check_dphiClick(Sender: TObject);
    procedure Check_fA0Click(Sender: TObject);
    procedure Check_fA1Click(Sender: TObject);
    procedure Check_fA2Click(Sender: TObject);
    procedure Check_fA3Click(Sender: TObject);
    procedure Check_fA4Click(Sender: TObject);
    procedure Check_fA5Click(Sender: TObject);
    procedure Check_CDClick(Sender: TObject);
    procedure Check_g_ddClick(Sender: TObject);
    procedure Check_g_dsrClick(Sender: TObject);
    procedure Check_g_dsaClick(Sender: TObject);
    procedure Check_delta_rClick(Sender: TObject);
    procedure Check_alpha_dClick(Sender: TObject);
    procedure Check_beta_dClick(Sender: TObject);
    procedure Check_gamma_dClick(Sender: TObject);
    procedure Check_delta_dClick(Sender: TObject);
    procedure Check_fluoClick(Sender: TObject);
    procedure Check_testClick(Sender: TObject);
    procedure Check_f_nwClick(Sender: TObject);
  private
    tsv : array[1..M1]of boolean;
  public
  end;

var Popup_Reconstruct: TPopup_Reconstruct;

implementation
uses privates;

{$R *.lfm}

procedure TPopup_Reconstruct.FormCreate(Sender: TObject);
begin
    Check_CP.Caption      :=par.name[1];
    Check_C1.Caption      :=par.name[2];
    Check_C2.Caption      :=par.name[3];
    Check_C3.Caption      :=par.name[4];
    Check_C4.Caption      :=par.name[5];
    Check_C5.Caption      :=par.name[6];
    Check_CL.Caption      :=par.name[7];
    Check_CMie.Caption    :=par.name[8];
    Check_CD.Caption      :=par.name[36];
    Check_CY.Caption      :=par.name[9];
    Check_S.Caption       :=par.name[10];
    Check_n.Caption       :=par.name[11];
    Check_TW.Caption      :=par.name[12];
    Check_Q.Caption       :=par.name[13];
    Check_fluo.Caption    :=par.name[14];
    Check_rho_L.Caption   :=par.name[15];
    Check_rho_dd.Caption  :=par.name[16];
    Check_rho_ds.Caption  :=par.name[17];
    Check_beta.Caption    :=par.name[18];
    Check_alpha.Caption   :=par.name[19];
    Check_f_dd.Caption    :=par.name[20];
    Check_f_ds.Caption    :=par.name[21];
    Check_H_oz.Caption    :=par.name[22];
    Check_WV.Caption      :=par.name[23];
    Check_f.Caption       :=par.name[24];
    Check_z.Caption       :=par.name[25];
    Check_zB.Caption      :=par.name[26];
    Check_sun.Caption     :=par.name[27];
    Check_view.Caption    :=par.name[28];
    Check_dphi.Caption    :=par.name[29];
    Check_fa0.Caption     :=par.name[30];
    Check_fa1.Caption     :=par.name[31];
    Check_fa2.Caption     :=par.name[32];
    Check_fa3.Caption     :=par.name[33];
    Check_fa4.Caption     :=par.name[34];
    Check_fa5.Caption     :=par.name[35];
    Check_g_dd.Caption    :=par.name[37];
    Check_g_dsr.Caption   :=par.name[38];
    Check_g_dsa.Caption   :=par.name[39];
    Check_delta_r.Caption :=par.name[40];
    Check_alpha_d.Caption :=par.name[41];
    Check_beta_d.Caption  :=par.name[42];
    Check_gamma_d.Caption :=par.name[43];
    Check_delta_d.Caption :=par.name[44];
    Check_dummy.Caption   :=par.name[45];
    Check_test.Caption    :=par.name[46];
    Check_f_nw.Caption    :=par.name[50];
    define_temp_parameters(Sender);
    end;

procedure TPopup_Reconstruct.define_temp_parameters(Sender: TObject);
var i : integer;
begin
    for i:=0 to 5 do tsv[i+1]:=C[i].sv=1;
    tsv[7] :=C_X.sv=1;
    tsv[8] :=C_Mie.sv=1;
    tsv[9] :=C_Y.sv=1;
    tsv[10]:=S.sv=1;
    tsv[11]:=n.sv=1;
    tsv[12]:=T_W.sv=1;
    tsv[13]:=Q.sv=1;
    tsv[14]:=fluo.sv=1;
    tsv[15]:=rho_L.sv=1;
    tsv[16]:=rho_dd.sv=1;
    tsv[17]:=rho_ds.sv=1;
    tsv[18]:=beta.sv=1;
    tsv[19]:=alpha.sv=1;
    tsv[20]:=f_dd.sv=1;
    tsv[21]:=f_ds.sv=1;
    tsv[22]:=H_oz.sv=1;
    tsv[23]:=WV.sv=1;
    tsv[24]:=f.sv=1;
    tsv[25]:=z.sv=1;
    tsv[26]:=zB.sv=1;
    tsv[27]:=sun.sv=1;
    tsv[28]:=view.sv=1;
    tsv[29]:=dphi.sv=1;
    for i:=0 to 5 do tsv[30+i]:=fA[i].sv=1;
    tsv[36] :=bbs_phy.sv=1;
    tsv[37]:=g_dd.sv=1;
    tsv[38]:=g_dsr.sv=1;
    tsv[39]:=g_dsa.sv=1;
    tsv[40]:=delta_r.sv=1;
    tsv[41]:=alpha_d.sv=1;
    tsv[42]:=beta_d.sv=1;
    tsv[43]:=gamma_d.sv=1;
    tsv[44]:=delta_d.sv=1;
    tsv[45]:=dummy.sv=1;
    tsv[46]:=test.sv=1;
    tsv[47]:=alpha_r.sv=1;
    tsv[48]:=beta_r.sv=1;
    tsv[49]:=gamma_r.sv=1;
    tsv[50]:=f_nw.sv=1;
    Check_CP.checked:=tsv[1];
    Check_C1.checked:=tsv[2];
    Check_C2.checked:=tsv[3];
    Check_C3.checked:=tsv[4];
    Check_C4.checked:=tsv[5];
    Check_C5.checked:=tsv[6];
    Check_CL.checked:=tsv[7];
    Check_CMie.checked:=tsv[8];
    Check_CY.checked:=tsv[9];
    Check_S.checked:=tsv[10];
    Check_n.checked:=tsv[11];
    Check_TW.checked:=tsv[12];
    Check_Q.checked:=tsv[13];
    Check_fluo.checked:=tsv[14];
    Check_rho_L.checked:=tsv[15];
    Check_rho_dd.checked:=tsv[16];
    Check_rho_ds.checked:=tsv[17];
    Check_beta.checked:=tsv[18];
    Check_alpha.checked:=tsv[19];
    Check_f_dd.checked:=tsv[20];
    Check_f_ds.checked:=tsv[21];
    Check_H_oz.checked:=tsv[22];
    Check_WV.checked:=tsv[23];
    Check_f.checked:=tsv[24];
    Check_z.checked:=tsv[25];
    Check_zB.checked:=tsv[26];
    Check_sun.checked:=tsv[27];
    Check_view.checked:=tsv[28];
    Check_dphi.checked:=tsv[29];
    Check_fA0.checked:=tsv[30];
    Check_fA1.checked:=tsv[31];
    Check_fA2.checked:=tsv[32];
    Check_fA3.checked:=tsv[33];
    Check_fA4.checked:=tsv[34];
    Check_fA5.checked:=tsv[35];
    Check_CD.checked:=tsv[36];
    Check_g_dd.checked:=tsv[37];
    Check_g_dsr.checked:=tsv[38];
    Check_g_dsa.checked:=tsv[39];
    Check_delta_r.checked:=tsv[40];
    Check_alpha_d.checked:=tsv[41];
    Check_beta_d.checked:=tsv[42];
    Check_gamma_d.checked:=tsv[43];
    Check_delta_d.checked:=tsv[44];
    Check_dummy.checked:=tsv[45];
    Check_test.checked:=tsv[46];
    Check_f_nw.checked:=tsv[50];
    if flag_public then begin
        Check_delta_r.visible:=FALSE;
        Check_alpha_d.visible:=FALSE;
        Check_beta_d.visible:=FALSE;
        Check_gamma_d.visible:=FALSE;
        Check_delta_d.visible:=FALSE;
        Check_test.visible:=FALSE;
        Check_dummy.visible:=FALSE;
        end;
    end;
    
procedure TPopup_Reconstruct.set_temp_parameters(Sender: TObject);
var i : integer;
begin
    for i:=0 to 5 do
        if tsv[i+1] then C[i].sv:=1  else C[i].sv:=0;
    if tsv[7]  then C_X.sv:=1  else C_X.sv:=0;
    if tsv[8]  then C_Mie.sv:=1 else C_Mie.sv:=0;
    if tsv[9]  then C_Y.sv:=1  else C_Y.sv:=0;
    if tsv[10] then S.sv:=1    else S.sv:=0;
    if tsv[11] then n.sv:=1    else n.sv:=0;
    if tsv[12] then T_W.sv:=1  else T_W.sv:=0;
    if tsv[13] then Q.sv:=1    else Q.sv:=0;
    if tsv[14] then fluo.sv:=1 else fluo.sv:=0;
    if tsv[15] then rho_L.sv:=1  else rho_L.sv:=0;
    if tsv[16] then rho_dd.sv:=1  else rho_dd.sv:=0;
    if tsv[17] then rho_ds.sv:=1 else rho_ds.sv:=0;
    if tsv[18] then beta.sv:=1  else beta.sv:=0;
    if tsv[19] then alpha.sv:=1 else alpha.sv:=0;
    if tsv[20] then f_dd.sv:=1  else f_dd.sv:=0;
    if tsv[21] then f_ds.sv:=1  else f_ds.sv:=0;
    if tsv[22] then H_oz.sv:=1  else H_oz.sv:=0;
    if tsv[23] then WV.sv:=1    else WV.sv:=0;
    if tsv[24] then f.sv:=1     else f.sv:=0;
    if tsv[25] then z.sv:=1     else z.sv:=0;
    if tsv[26] then zB.sv:=1    else zB.sv:=0;
    if tsv[27] then sun.sv:=1   else sun.sv:=0;
    if tsv[28] then view.sv:=1  else view.sv:=0;
    if tsv[29] then dphi.sv:=1  else dphi.sv:=0;
    for i:=0 to 5 do
        if tsv[30+i] then fA[i].sv:=1 else fA[i].sv:=0;
    if tsv[36] then bbs_phy.sv:=1  else bbs_phy.sv:=0;
    if tsv[37] then g_dd.sv:=1     else g_dd.sv:=0;
    if tsv[38] then g_dsr.sv:=1    else g_dsr.sv:=0;
    if tsv[39] then g_dsa.sv:=1    else g_dsa.sv:=0;
    if tsv[40] then delta_r.sv:=1  else delta_r.sv:=0;
    if tsv[41] then alpha_d.sv:=1  else alpha_d.sv:=0;
    if tsv[42] then beta_d.sv:=1   else beta_d.sv:=0;
    if tsv[43] then gamma_d.sv:=1  else gamma_d.sv:=0;
    if tsv[44] then delta_d.sv:=1  else delta_d.sv:=0;
    if tsv[45] then dummy.sv:=1    else dummy.sv:=0;
    if tsv[46] then test.sv:=1     else test.sv:=0;
    if tsv[47] then alpha_r.sv:=1  else alpha_r.sv:=0;
    if tsv[48] then beta_r.sv:=1   else beta_r.sv:=0;
    if tsv[49] then gamma_r.sv:=1  else gamma_r.sv:=0;
    if tsv[50] then f_nw.sv:=1     else f_nw.sv:=0;
    end;

procedure TPopup_Reconstruct.Check_CPClick(Sender: TObject);
begin
    tsv[1]:=Check_CP.checked;
    end;

procedure TPopup_Reconstruct.Check_C1Click(Sender: TObject);
begin
    tsv[2]:=Check_C1.checked;
    end;

procedure TPopup_Reconstruct.Check_C2Click(Sender: TObject);
begin
    tsv[3]:=Check_C2.checked;
    end;

procedure TPopup_Reconstruct.Check_C3Click(Sender: TObject);
begin
    tsv[4]:=Check_Cd.checked;
    end;

procedure TPopup_Reconstruct.Check_C4Click(Sender: TObject);
begin
    tsv[5]:=Check_C4.checked;
    end;

procedure TPopup_Reconstruct.Check_C5Click(Sender: TObject);
begin
    tsv[6]:=Check_C5.checked;
    end;

procedure TPopup_Reconstruct.Check_CLClick(Sender: TObject);
begin
    tsv[7]:=Check_CL.checked;
    end;

procedure TPopup_Reconstruct.Check_CMieClick(Sender: TObject);
begin
    tsv[8]:=Check_CMie.checked;
    end;

procedure TPopup_Reconstruct.Check_CYClick(Sender: TObject);
begin
    tsv[9]:=Check_CY.checked;
    end;

procedure TPopup_Reconstruct.Check_SClick(Sender: TObject);
begin
    tsv[10]:=Check_S.checked;
    end;

procedure TPopup_Reconstruct.Check_nClick(Sender: TObject);
begin
    tsv[11]:=Check_n.checked;
    end;

procedure TPopup_Reconstruct.Check_TWClick(Sender: TObject);
begin
    tsv[12]:=Check_TW.checked;
    end;

procedure TPopup_Reconstruct.Check_QClick(Sender: TObject);
begin
    tsv[13]:=Check_Q.checked;
    end;

procedure TPopup_Reconstruct.ButtonOKClick(Sender: TObject);
begin
    ModalResult := mrOK;
    end;

procedure TPopup_Reconstruct.ButtonCancelClick(Sender: TObject);
begin
    ModalResult := mrCancel;
    end;


procedure TPopup_Reconstruct.Check_rho_LClick(Sender: TObject);
begin
    tsv[15]:=Check_rho_L.checked;
    end;

procedure TPopup_Reconstruct.Check_rho_ddClick(Sender: TObject);
begin
    tsv[16]:=Check_rho_dd.checked;
    end;

procedure TPopup_Reconstruct.Check_dummyClick(Sender: TObject);
begin
    tsv[45]:=Check_dummy.checked;
    end;

procedure TPopup_Reconstruct.Check_rho_dsClick(Sender: TObject);
begin
    tsv[17]:=Check_rho_ds.checked;
    end;

procedure TPopup_Reconstruct.Check_betaClick(Sender: TObject);
begin
    tsv[18]:=Check_beta.checked;
    end;

procedure TPopup_Reconstruct.Check_alphaClick(Sender: TObject);
begin
    tsv[19]:=Check_alpha.checked;
    end;

procedure TPopup_Reconstruct.Check_f_ddClick(Sender: TObject);
begin
    tsv[20]:=Check_f_dd.checked;
    end;

procedure TPopup_Reconstruct.Check_f_dsClick(Sender: TObject);
begin
    tsv[21]:=Check_f_ds.checked;
    end;

procedure TPopup_Reconstruct.Check_H_ozClick(Sender: TObject);
begin
    tsv[22]:=Check_H_oz.checked;
    end;

procedure TPopup_Reconstruct.Check_WVClick(Sender: TObject);
begin
    tsv[23]:=Check_WV.checked;
    end;

procedure TPopup_Reconstruct.Check_fClick(Sender: TObject);
begin
    tsv[24]:=Check_f.checked;
    end;

procedure TPopup_Reconstruct.Check_zClick(Sender: TObject);
begin
    tsv[25]:=Check_z.checked;
    end;

procedure TPopup_Reconstruct.Check_zBClick(Sender: TObject);
begin
    tsv[26]:=Check_zB.checked;
    end;

procedure TPopup_Reconstruct.Check_sunClick(Sender: TObject);
begin
    tsv[27]:=Check_sun.checked;
    end;

procedure TPopup_Reconstruct.Check_viewClick(Sender: TObject);
begin
    tsv[28]:=Check_view.checked;
    end;

procedure TPopup_Reconstruct.Check_dphiClick(Sender: TObject);
begin
    tsv[29]:=Check_dphi.checked;
    end;

procedure TPopup_Reconstruct.Check_fA0Click(Sender: TObject);
begin
    tsv[30]:=Check_fA0.checked;
    end;

procedure TPopup_Reconstruct.Check_fA1Click(Sender: TObject);
begin
    tsv[31]:=Check_fA1.checked;
    end;

procedure TPopup_Reconstruct.Check_fA2Click(Sender: TObject);
begin
    tsv[32]:=Check_fA2.checked;
    end;

procedure TPopup_Reconstruct.Check_fA3Click(Sender: TObject);
begin
    tsv[33]:=Check_fA3.checked;
    end;

procedure TPopup_Reconstruct.Check_fA4Click(Sender: TObject);
begin
    tsv[34]:=Check_fA4.checked;
    end;

procedure TPopup_Reconstruct.Check_fA5Click(Sender: TObject);
begin
    tsv[35]:=Check_fA5.checked;
    end;


procedure TPopup_Reconstruct.Check_CDClick(Sender: TObject);
begin
    tsv[36]:=Check_CD.checked;
    end;

procedure TPopup_Reconstruct.Check_g_ddClick(Sender: TObject);
begin
    tsv[37]:=Check_g_dd.checked;
    end;

procedure TPopup_Reconstruct.Check_g_dsrClick(Sender: TObject);
begin
    tsv[38]:=Check_g_dsr.checked;
    end;

procedure TPopup_Reconstruct.Check_g_dsaClick(Sender: TObject);
begin
    tsv[39]:=Check_g_dsa.checked;
    end;

procedure TPopup_Reconstruct.Check_delta_rClick(Sender: TObject);
begin
    tsv[40]:=Check_delta_r.checked;
    end;

procedure TPopup_Reconstruct.Check_alpha_dClick(Sender: TObject);
begin
    tsv[41]:=Check_alpha_d.checked;
    end;

procedure TPopup_Reconstruct.Check_beta_dClick(Sender: TObject);
begin
    tsv[42]:=Check_beta_d.checked;
    end;

procedure TPopup_Reconstruct.Check_gamma_dClick(Sender: TObject);
begin
    tsv[43]:=Check_gamma_d.checked;
    end;

procedure TPopup_Reconstruct.Check_delta_dClick(Sender: TObject);
begin
    tsv[44]:=Check_delta_d.checked;
    end;

procedure TPopup_Reconstruct.Check_fluoClick(Sender: TObject);
begin
    tsv[14]:=Check_fluo.checked;
    end;

procedure TPopup_Reconstruct.Check_testClick(Sender: TObject);
begin
    tsv[46]:=Check_test.checked;
    end;

procedure TPopup_Reconstruct.Check_f_nwClick(Sender: TObject);
begin
    tsv[50]:=Check_f_dd.checked;
    end;


end.
