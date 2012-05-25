set PATH=C:\D\dmd2\windows\bin;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\\bin;%PATH%
dmd -g -debug -X -Xf"Debug\D OpenGL SandBox.json" -IC:\DLang\dmd2\src\Derelict2\import\ -deps="Debug\D OpenGL SandBox.dep" -of"Debug\D OpenGL SandBox.exe_cv" -map "Debug\D_OpenGL_SandBox.map" -L/NOMAP C:\DLang\dmd2\src\Derelict2\lib\DerelictGL.lib C:\DLang\dmd2\src\Derelict2\lib\DerelictUtil.lib C:\DLang\dmd2\src\Derelict2\lib\DerelictSDL.lib PActor.d PApp.d PDrawableObject.d PDrawText.d PFps.d PInput.d PlayStateManager.d PTime.d PUtil.d
if errorlevel 1 goto reportError
if not exist "Debug\D OpenGL SandBox.exe_cv" (echo "Debug\D OpenGL SandBox.exe_cv" not created! && goto reportError)
echo Converting debug information...
"C:\Program Files (x86)\Vis-ual-D\cv2pdb\cv2pdb.exe" -D2 "Debug\D OpenGL SandBox.exe_cv" "Debug\D OpenGL SandBox.exe"
if errorlevel 1 goto reportError
if not exist "Debug\D OpenGL SandBox.exe" (echo "Debug\D OpenGL SandBox.exe" not created! && goto reportError)

goto noError

:reportError
echo Building Debug\D OpenGL SandBox.exe failed!

:noError
