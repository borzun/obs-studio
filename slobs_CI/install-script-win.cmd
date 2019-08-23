set DepsURL=https://obs-studio-deployment.s3-us-west-2.amazonaws.com/dependencies2017.zip 
set VLCURL=https://obsproject.com/downloads/vlc.zip
set CEFURL=https://s3-us-west-2.amazonaws.com/streamlabs-cef-dist
set CMakeGenerator=Visual Studio 15 2017

if exist dependencies2017.zip (curl -kLO %DepsURL% -f --retry 5 -z dependencies2017.zip) else (curl -kLO %DepsURL% -f --retry 5 -C -)
if exist vlc.zip (curl -kLO %VLCURL% -f --retry 5 -z vlc.zip) else (curl -kLO %VLCURL% -f --retry 5 -C -)
ECHO %CEFURL%/cef_binary_%CEF_VERSION%_windows64.zip
if exist cef_binary_%CEF_VERSION%_windows64.zip (curl -kLO %CEFURL%/cef_binary_%CEF_VERSION%_windows64.zip -f --retry 5 -z cef_binary_%CEF_VERSION%_windows64.zip) else (curl -kLO %CEFURL%/cef_binary_%CEF_VERSION%_windows64.zip -f --retry 5 -C -)

https://s3-us-west-2.amazonaws.com/streamlabs-cef-dist/cef_binary_3.3578.1859.g3563564_windows64.zip

mkdir build

7z x dependencies2017.zip -odependencies2017
7z x vlc.zip -ovlc
7z x cef_binary_%CEF_VERSION%_windows64.zip -oCEF_64

cmake -G"%CMakeGenerator%" -A x64 -HCEF_64 -BCEF_64/build -DCEF_RUNTIME_LIBRARY_FLAG="/MD"
cmake --build CEF_64/build --config %CefBuildConfig% --target libcef_dll_wrapper -v

cmake -H.
         -Bbuild
         -G"%CmakeGenerator%"
         -A x64
         -DCMAKE_INSTALL_PREFIX="%InstallPath%"
         -DDepsPath=dependencies2017
         -DVLCPath=vlc
         -DCEF_ROOT_DIR=CEF_64
         -DENABLE_UI=false
         -DCOPIED_DEPENDENCIES=false
         -DCOPY_DEPENDENCIES=true
         -DENABLE_SCRIPTING=false
         -DBUILD_CAPTIONS=false
         -DCOMPILE_D3D12_HOOK=true
         -DBUILD_BROWSER=true
         -DBROWSER_FRONTEND_API_SUPPORT=false
         -DBROWSER_PANEL_SUPPORT=false
         -DBROWSER_USE_STATIC_CRT=false
         -DEXPERIMENTAL_SHARED_TEXTURE_SUPPORT=true'

cmake --build build --target install --config %BuildConfig% -v'