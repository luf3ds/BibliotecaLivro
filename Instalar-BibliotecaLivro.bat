@echo off
setlocal EnableExtensions
title Instalador completo - BibliotecaLivro

set "ROOT=%LOCALAPPDATA%\BibliotecaLivro"
set "DL=%ROOT%\downloads"
set "RUNTIME=%ROOT%\runtime"
set "TOMCAT_HOME=%RUNTIME%\apache-tomcat-9.0.123"
set "JAVA_HOME_LOCAL=%RUNTIME%\jdk"
set "APP=%TOMCAT_HOME%\webapps\BibliotecaLivro"
set "ZIP_PROJETO=%~dp0arquivos\BibliotecaLivro_codigos_corrigidos.zip"
set "TOMCAT_URL=https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.123/bin/apache-tomcat-9.0.123-windows-x64.zip"
set "JDK_URL=https://api.adoptium.net/v3/binary/latest/17/ga/windows/x64/jdk/hotspot/normal/eclipse"
set "SQLITE_URL=https://repo.maven.apache.org/maven2/org/xerial/sqlite-jdbc/3.34.0/sqlite-jdbc-3.34.0.jar"

echo.
echo ==============================================
echo   INSTALACAO COMPLETA - BIBLIOTECALIVRO
echo ==============================================
echo.
echo Este processo baixa e prepara Java, Tomcat,
echo driver SQLite e os arquivos do projeto.
echo O destino sera:
echo %ROOT%
echo.

if not exist "%ZIP_PROJETO%" (
  echo ERRO: Nao encontrei o pacote do projeto:
  echo %ZIP_PROJETO%
  echo Extraia o instalador completo mantendo a pasta arquivos.
  pause
  exit /b 1
)

where powershell >nul 2>nul
if errorlevel 1 (
  echo ERRO: Windows PowerShell nao encontrado.
  pause
  exit /b 1
)

if not exist "%DL%" mkdir "%DL%"
if not exist "%RUNTIME%" mkdir "%RUNTIME%"

echo [1/6] Preparando Java JDK 17...
if not exist "%JAVA_HOME_LOCAL%\bin\javac.exe" (
  echo Baixando JDK 17...
  powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; Invoke-WebRequest -Uri '%JDK_URL%' -OutFile '%DL%\jdk17.zip'; Expand-Archive -LiteralPath '%DL%\jdk17.zip' -DestinationPath '%RUNTIME%\jdk-extract' -Force; $jdk=Get-ChildItem '%RUNTIME%\jdk-extract' -Directory | Select-Object -First 1; if(-not $jdk){throw 'Pasta do JDK nao encontrada'}; if(Test-Path '%JAVA_HOME_LOCAL%'){Remove-Item '%JAVA_HOME_LOCAL%' -Recurse -Force}; Move-Item $jdk.FullName '%JAVA_HOME_LOCAL%'; Remove-Item '%RUNTIME%\jdk-extract' -Recurse -Force; if(-not (Test-Path '%JAVA_HOME_LOCAL%\bin\javac.exe')){throw 'JDK nao foi extraido corretamente'}"
  if errorlevel 1 goto :falha
) else (
  echo JDK ja preparado.
)

echo.
echo [2/6] Preparando Apache Tomcat 9...
if not exist "%TOMCAT_HOME%\bin\catalina.bat" (
  echo Baixando Tomcat...
  powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; Invoke-WebRequest -Uri '%TOMCAT_URL%' -OutFile '%DL%\tomcat.zip'; Expand-Archive -LiteralPath '%DL%\tomcat.zip' -DestinationPath '%RUNTIME%' -Force; if(-not (Test-Path '%TOMCAT_HOME%\bin\catalina.bat')){throw 'Tomcat nao foi extraido corretamente'}"
  if errorlevel 1 goto :falha
) else (
  echo Tomcat ja preparado.
)

echo.
echo [3/6] Instalando os arquivos do projeto...
if not exist "%APP%\index.jsp" (
  if not exist "%APP%" mkdir "%APP%"
  powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; Expand-Archive -LiteralPath '%ZIP_PROJETO%' -DestinationPath '%APP%' -Force"
  if errorlevel 1 goto :falha
) else (
  echo Projeto ja existe; mantendo os arquivos atuais.
)

echo.
echo [4/6] Instalando o driver SQLite...
if not exist "%APP%\WEB-INF\lib" mkdir "%APP%\WEB-INF\lib"
if not exist "%APP%\WEB-INF\classes" mkdir "%APP%\WEB-INF\classes"
if not exist "%APP%\WEB-INF\lib\sqlite-jdbc-3.34.0.jar" (
  powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; Invoke-WebRequest -Uri '%SQLITE_URL%' -OutFile '%APP%\WEB-INF\lib\sqlite-jdbc-3.34.0.jar'; if((Get-Item '%APP%\WEB-INF\lib\sqlite-jdbc-3.34.0.jar').Length -lt 100000){throw 'Driver SQLite parece incompleto'}"
  if errorlevel 1 goto :falha
) else (
  echo Driver SQLite ja existe.
)

echo.
echo [5/6] Compilando os arquivos Java...
set "CP=%TOMCAT_HOME%\lib\servlet-api.jar;%APP%\WEB-INF\lib\sqlite-jdbc-3.34.0.jar"
"%JAVA_HOME_LOCAL%\bin\javac.exe" -encoding UTF-8 -cp "%CP%" -d "%APP%\WEB-INF\classes" "%APP%\src\main\java\com\crudlivros\model\Livro.java" "%APP%\src\main\java\tpsemana11\Erro.java" "%APP%\src\main\java\tpsemana11\AFDAL.java" "%APP%\src\main\java\tpsemana11\ALDAL.java" "%APP%\src\main\java\com\crudlivros\bll\LivroBLL.java" "%APP%\src\main\java\com\crudlivros\controller\LivroServlet.java"
if errorlevel 1 goto :falha

echo.
echo [6/6] Iniciando o sistema...
start "Tomcat - BibliotecaLivro" /D "%TOMCAT_HOME%\bin" cmd /k "set JAVA_HOME=%JAVA_HOME_LOCAL% && set CATALINA_HOME=%TOMCAT_HOME% && call catalina.bat run"

echo Aguardando o servidor iniciar...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ready=$false; for($i=0;$i -lt 60;$i++){if(Test-NetConnection 127.0.0.1 -Port 8080 -InformationLevel Quiet){$ready=$true;break};Start-Sleep 1};if($ready){Start-Process 'http://localhost:8080/BibliotecaLivro/LivroServlet?acao=listar';exit 0}else{exit 1}"
if errorlevel 1 (
  echo O Tomcat nao respondeu na porta 8080.
  echo Veja a janela Tomcat - BibliotecaLivro para identificar o erro.
  pause
  exit /b 1
)

echo.
echo INSTALACAO CONCLUIDA.
echo Para abrir novamente, execute:
echo %ROOT%\Abrir-BibliotecaLivro.bat
echo Mantenha a janela do Tomcat aberta enquanto usa o sistema.
pause
exit /b 0

:falha
echo.
echo A instalacao foi interrompida. Confira a mensagem de erro acima.
echo Se for problema de internet, tente novamente.
pause
exit /b 1
