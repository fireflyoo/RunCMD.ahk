#Requires Autohotkey v2
#Warn
#Include "<RunCMD>"
#SingleInstance Force
SetWorkingDir(A_ScriptDir)
TraySetIcon(A_Comspec)

W := 0
myGui := Gui()
myGui.MarginX := "15", myGui.MarginY := "15"
myGui.SetFont("s9", "Consolas")
myGui.Add("Text", , "Output")
ogcEdit1 := myGui.Add("Edit", "y+3 -Wrap +HScroll R20 ReadOnly", Format("{:81}", ""))
hEdit1 := ogcEdit1.hwnd
ControlGetPos(, , &W, , hEdit1, "ahk_id " hEdit1)
myGui.Add("Text", , "Command Line")
ogcEdit2 := myGui.Add("Edit", "y+3 -Wrap w" . W, "Dir")
hEdit2 := ogcEdit2.hwnd
ogcButton1 := myGui.Add("Button", "x+0 w0 h0 Default", "<F2> RunCMD")
ogcButton1.OnEvent("Click", Run)
SB := myGui.Add("StatusBar")
SB.SetParts(200,200), SB.SetText("`t<Esc> Cancel/Clear", 1),  SB.SetText("`t<Enter> RunCMD", 2)
ogcEdit1.Value := ""
myGui.Title := "RunCMD() - Realtime per line streaming demo"
myGui.OnEvent("Escape", myGui_Escape)
myGui.Show()


Run(*)
{
  SB.SetText("", 3)
  Cmd := ogcEdit2.Text
  ogcButton1.Enabled := false
  RunCMD(A_Comspec . " /c " . Cmd,,,RunCMD_Output)
  SB.SetText("`tExitCode : " RunCMD.ExitCode, 3)
  ogcButton1.Enabled := true
  Edit_Append(hEdit2,"")
ogcEdit2.Focus()
Return                                                            ; end of auto-execute section
}
myGui_Escape(thisGui){
  ogcEdit2.Focus()
  Edit_Append(hEdit2,"")
  If(RunCMD.PID) {
    RunCMD.PID := 0
    Return
  }
  SB.SetText("",3)
  ogcEdit1.Value := ""
  ogcEdit2.Value := ""
}

RunCMD_Output(Line, LineNum) {

  Edit_Append(hEdit1, Line)

}


Edit_Append(hEdit, Txt) { ; Modified version by SKAN
        ; Original by TheGood on 09-Apr-2010 @ autohotkey.com/board/topic/52441-/?p=328342
  L := DllCall("SendMessage", "Ptr", hEdit, "UInt", 0x0E, "Ptr", 0, "Ptr", 0)   ; WM_GETTEXTLENGTH
       DllCall("SendMessage", "Ptr", hEdit, "UInt", 0xB1, "Ptr", L, "Ptr", L)   ; EM_SETSEL
       DllCall("SendMessage", "Ptr", hEdit, "UInt", 0xC2, "Ptr", 0, "Str", Txt) ; EM_REPLACESEL
}

