@echo off
setlocal EnableExtensions

rem ===== AJUSTE ESTES CAMINHOS SE ESTIVEREM DIFERENTES =====
set "TOMCAT=C:\Users\lufed\Downloads\apache-tomcat-9.0.123\apache-tomcat-9.0.123"
set "JAVA_HOME=C:\Program Files\Java\jdk-25.0.4"
rem ========================================================

set "PROJETO=%TOMCAT%\webapps\BibliotecaLivro"
set "ORIGEM=%PROJETO%\src\main\java"
set "WEBINF=%PROJETO%\WEB-INF"
set "LIB=%WEBINF%\lib"
set "CLASSES=%WEBINF%\classes"
set "SERVLET_JAR=%TOMCAT%\lib\servlet-api.jar"
set "SQLITE_JAR=%LIB%\sqlite-jdbc-3.34.0.jar"
set "SQLITE_URL=https://repo.maven.apache.org/maven2/org/xerial/sqlite-jdbc/3.34.0/sqlite-jdbc-3.34.0.jar"

echo.
echo ==========================================
echo   Instalador de recursos - BibliotecaLivro
echo ==========================================
echo.

if not exist "%TOMCAT%\bin\catalina.bat" (
  echo ERRO: Tomcat nao encontrado:
  echo %TOMCAT%
  echo Edite a variavel TOMCAT neste arquivo .bat.
  pause
  exit /b 1
)

if not exist "%JAVA_HOME%\bin\javac.exe" (
  echo ERRO: JDK nao encontrado:
  echo %JAVA_HOME%
  echo Edite a variavel JAVA_HOME neste arquivo .bat.
  pause
  exit /b 1
)

if not exist "%PROJETO%\index.jsp" (
  echo ERRO: Projeto nao encontrado:
  echo %PROJETO%
  echo Extraia/copie o projeto para a pasta webapps\BibliotecaLivro do Tomcat.
  pause
  exit /b 1
)

if not exist "%ORIGEM%" (
  echo ERRO: Pasta de codigos Java nao encontrada:
  echo %ORIGEM%
  pause
  exit /b 1
)

echo [1/5] Criando pastas necessarias...
if not exist "%WEBINF%" mkdir "%WEBINF%"
if not exist "%LIB%" mkdir "%LIB%"
if not exist "%CLASSES%" mkdir "%CLASSES%"

echo.
echo [2/5] Verificando o driver JDBC do SQLite...
if exist "%SQLITE_JAR%" (
  echo Driver SQLite ja instalado.
) else (
  echo Baixando driver SQLite...
  powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Invoke-WebRequest -Uri '%SQLITE_URL%' -OutFile '%SQLITE_JAR%' -UseBasicParsing; if ((Get-Item '%SQLITE_JAR%').Length -lt 100000) { throw 'Arquivo baixado parece incompleto.' } } catch { Write-Error $_; exit 1 }"
  if errorlevel 1 (
    echo ERRO: Nao foi possivel baixar o driver SQLite.
    echo Verifique sua conexao com a internet e tente novamente.
    if exist "%SQLITE_JAR%" del "%SQLITE_JAR%"
    pause
    exit /b 1
  )
)

echo.
echo [3/5] Verificando bibliotecas do Tomcat...
if not exist "%SERVLET_JAR%" (
  echo ERRO: servlet-api.jar nao encontrado em:
  echo %SERVLET_JAR%
  pause
  exit /b 1
)
echo Biblioteca Servlet encontrada no Tomcat.

echo.
echo [4/5] Compilando os arquivos Java...
set "CP=%SERVLET_JAR%;%SQLITE_JAR%"
"%JAVA_HOME%\bin\javac.exe" -encoding UTF-8 -cp "%CP%" -d "%CLASSES%" "%ORIGEM%\com\crudlivros\model\Livro.java" "%ORIGEM%\tpsemana11\Erro.java" "%ORIGEM%\tpsemana11\AFDAL.java" "%ORIGEM%\tpsemana11\ALDAL.java" "%ORIGEM%\com\crudlivros\bll\LivroBLL.java" "%ORIGEM%\com\crudlivros\controller\LivroServlet.java"
if errorlevel 1 (
  echo.
  echo ERRO: A compilacao falhou. Confira as mensagens acima.
  pause
  exit /b 1
)

echo.
echo [5/5] Conferindo arquivos compilados...
if not exist "%CLASSES%\com\crudlivros\controller\LivroServlet.class" (
  echo ERRO: LivroServlet.class nao foi gerado.
  pause
  exit /b 1
)
if not exist "%CLASSES%\tpsemana11\ALDAL.class" (
  echo ERRO: ALDAL.class nao foi gerado.
  pause
  exit /b 1
)

echo.
echo ==========================================
echo   INSTALACAO CONCLUIDA
echo ==========================================
echo Pastas WEB-INF\lib e WEB-INF\classes prontas.
echo Driver SQLite instalado.
echo Codigos Java compilados.
echo.
echo Para iniciar o sistema, execute:
echo Iniciar-BibliotecaLivro.bat
echo.
pause
