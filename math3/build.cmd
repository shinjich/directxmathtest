set MSB_LOGGING=/fl1 /fl2 /fl3 /flp1:logfile=build.log;append=true /flp2:logfile=build.err;errorsonly;append=true /flp3:logfile=build.wrn;warningsonly;append=true
del build.log
del build.err
del build.wrn
REM VS 2017
for %%1 in ("Debug" "Release" "NI Debug" "NI Release" "x87 Debug" "x87 Release" "SSE3 Debug" "SSE3 Release" "SSE4 Debug" "SSE4 Release" "AVX Debug" "AVX Release" "AVX2 Debug" "AVX2 Release") do (
msbuild math3_2017.sln /p:Configuration=%%1 /p:Platform=x86 %MSB_LOGGING%
@if ERRORLEVEL 1 goto error )
for %%1 in ("Debug" "Release" "NI Debug" "NI Release" "SSE3 Debug" "SSE3 Release" "SSE4 Debug" "SSE4 Release" "AVX Debug" "AVX Release" "AVX2 Debug" "AVX2 Release") do (
msbuild math3_2017.sln /p:Configuration=%%1 /p:Platform=x64 %MSB_LOGGING%
@if ERRORLEVEL 1 goto error )
@if NOT %VisualStudioVersion%.==16.0. goto skipvs2019
REM VS 2019
for %%1 in ("Debug" "Release" "NI Debug" "NI Release" "x87 Debug" "x87 Release" "SSE3 Debug" "SSE3 Release" "SSE4 Debug" "SSE4 Release" "AVX Debug" "AVX Release" "AVX2 Debug" "AVX2 Release" "NoSVML Release" "NoSVML Debug") do (
msbuild math3_2019.sln /p:Configuration=%%1 /p:Platform=x86 %MSB_LOGGING%
@if ERRORLEVEL 1 goto error )
for %%1 in ("Debug" "Release" "NI Debug" "NI Release" "SSE3 Debug" "SSE3 Release" "SSE4 Debug" "SSE4 Release" "AVX Debug" "AVX Release" "AVX2 Debug" "AVX2 Release" "NoSVML Release" "NoSVML Debug") do (
msbuild math3_2019.sln /p:Configuration=%%1 /p:Platform=x64 %MSB_LOGGING%
@if ERRORLEVEL 1 goto error )
for %%1 in ("Debug" "Release" "NI Debug" "NI Release") do (
msbuild math3_2019.sln /p:Configuration=%%1 /p:Platform=ARM64 %MSB_LOGGING%
@if ERRORLEVEL 1 goto error )
if not exist "%VCINSTALLDIR%Tools/Llvm/bin/clang-cl.exe" (echo "INFO: Visual Studio missing components required to build with clang") else (
pushd ..\
cmake -G "Visual Studio 16 2019" -T clangcl -A x64 -DCMAKE_CXX_COMPILER:FILEPATH="%VCINSTALLDIR%Tools/Llvm/bin/clang-cl.exe" -B out
@if ERRORLEVEL 1 goto error
cd out
devenv directxmath.sln /Build
@if ERRORLEVEL 1 goto error
popd
)
:skipvs2019
@echo --- BUILD COMPLETE ---
type build.wrn
@goto :eof
:error
@echo --- ERROR: BUILD FAILED ---
