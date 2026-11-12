@echo off
setlocal

set "TOMCAT=C:\Users\lufed\Downloads\apache-tomcat-9.0.123\apache-tomcat-9.0.123"
set "JAVA_HOME=C:\Program Files\Java\jdk-25.0.4"
set "CATALINA_HOME=%TOMCAT%"
set "PROJETO=%TOMCAT%\webapps\BibliotecaLivro"
set "ORIGEM=%PROJETO%\src\main\java"
set "DESTINO=%PROJETO%\WEB-INF\classes"
set "SERVLET=%TOMCAT%\lib\servlet-api.jar"
set "SQLITE=%PROJETO%\WEB-INF\lib\sqlite-jdbc-3.34.0.jar"

echo.
echo === Iniciando BibliotecaLivro ===
echo.

if not exist "%TOMCAT%\bin\catalina.bat" (
  echo ERRO: Tomcat nao encontrado: %TOMCAT%
  pause
  exit /b 1
)
if not exist "%JAVA_HOME%\bin\javac.exe" (
  echo ERRO: JDK nao encontrado: %JAVA_HOME%
  pause
  exit /b 1
)
if not exist "%SQLITE%" (
  echo ERRO: Driver SQLite nao encontrado: %SQLITE%
  pause
  exit /b 1
)
if not exist "%DESTINO%" mkdir "%DESTINO%"

echo [1/3] Compilando os arquivos Java...
"%JAVA_HOME%\bin\javac.exe" -encoding UTF-8 -cp "%SERVLET%;%SQLITE%" -d "%DESTINO%" "%ORIGEM%\com\crudlivros\model\Livro.java" "%ORIGEM%\tpsemana11\Erro.java" "%ORIGEM%\tpsemana11\AFDAL.java" "%ORIGEM%\tpsemana11\ALDAL.java" "%ORIGEM%\com\crudlivros\bll\LivroBLL.java" "%ORIGEM%\com\crudlivros\controller\LivroServlet.java"
if errorlevel 1 (
  echo ERRO: A compilacao falhou. Veja as mensagens acima.
  pause
  exit /b 1
)

echo [2/3] Iniciando o Tomcat em uma nova janela...
start "Tomcat - BibliotecaLivro" /D "%TOMCAT%\bin" cmd /k ""%TOMCAT%\bin\catalina.bat" run"

echo [3/3] Aguardando o Tomcat responder na porta 8080...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ok=$false; for($i=0; $i -lt 30; $i++){ if(Test-NetConnection -ComputerName 127.0.0.1 -Port 8080 -InformationLevel Quiet){$ok=$true; break}; Start-Sleep -Seconds 1 }; if($ok){Start-Process 'http://localhost:8080/BibliotecaLivro/LivroServlet?acao=listar'; exit 0}else{exit 1}"
if errorlevel 1 (
  echo.
  echo O Tomcat nao respondeu na porta 8080.
  echo Abra a janela 'Tomcat - BibliotecaLivro' e veja a mensagem de erro.
  echo Nao feche essa janela; copie aqui as ultimas linhas exibidas.
  pause
  exit /b 1
)

echo.
echo Sistema aberto no navegador.
echo Mantenha a janela 'Tomcat - BibliotecaLivro' aberta.
echo Para desligar o servidor, pressione Ctrl+C nela.
pause
