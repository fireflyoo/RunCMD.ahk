#Requires Autohotkey v2
#include <RunCMD>

MsgBox RunCMD("ping autohotkey.com -n 1",,,pingHelper)
MsgBox RunCMD("cmd /c dir")

pingHelper(Line, LineNum) {
  If (LineNum=2)
    {
      RunCMD.PID := 0 ; Cancel RunTerminal()
      Return Line
    }
}
