set PATH=C:\D\dmd2\windows\bin;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\\bin;%PATH%
dmd -release -X -Xf"Release\D OpenGL SandBox.json" -IC:\DLang\dmd2\src\Derelict2\import\ -deps="Release\D OpenGL SandBox.dep" -of"Release\D OpenGL SandBox.exe" -map "Release\D_OpenGL_SandBox.map" -L/NOMAP C:\DLang\dmd2\src\Derelict2\lib\DerelictGL.lib C:\DLang\dmd2\src\Derelict2\lib\DerelictUtil.lib C:\DLang\dmd2\src\Derelict2\lib\DerelictSDL.lib PActor.d PApp.d PDrawableObject.d PDrawText.d PFps.d PInput.d PlayStateManager.d PTime.d PUtil.d
if errorlevel 1 goto reportError
if not exist "Release\D OpenGL SandBox.exe" (echo "Release\D OpenGL SandBox.exe" not created! && goto reportError)

goto noError

:reportError
echo Building Release\D OpenGL SandBox.exe failed!

:noError
